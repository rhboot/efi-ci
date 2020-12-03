
USER	?= pjones
ACCOUNT	?= vathpela
DISTRO	?= f32
TAG	?=
ifneq ($(TAG),)
	TAG := :$(TAG)
endif
IMAGE_NAME ?= efi-ci-$(DISTRO)$(TAG)
LOCAL_IMAGE ?= $(USER)/$(IMAGE_NAME)
IMAGE ?= $(ACCOUNT)/$(IMAGE_NAME)
TAR_FILE ?= $(IMAGE_NAME).tar
IMAGE_FILE ?= $(TAR_FILE).xz
TARGET=$(USER).fedorapeople.org:public_html/containers/$(IMAGE_FILE)
THREADS != grep -c "^model name" /proc/cpuinfo

all : snapshot upload

snapshot:
	podman build -f Containerfile-$(DISTRO) -t $(LOCAL_IMAGE) .

$(TAR_FILE): snapshot
	@rm -vf $@
	podman container create --name $(IMAGE_NAME) $(IMAGE_NAME)
	podman export -o $@ $(IMAGE_NAME)
	podman container rm $(IMAGE_NAME)

%.xz : %
	xz --compress -9 --threads=$(THREADS) -v $<

upload: $(IMAGE_FILE)
	rsync -avSHP $(IMAGE_FILE) $(TARGET)

clean:
	@rm -vf *.tar *.tar.*

.PHONY: all upload
