
USER	?= pjones
ACCOUNT	?= vathpela
DISTRO	?= f32
TAG	?=
LOCAL_IMAGE ?= $(USER)/efi-ci-$(DISTRO)$(TAG)
IMAGE ?= $(ACCOUNT)/efi-ci-$(DISTRO)$(TAG)

all : snapshot upload

snapshot:
	podman build -f Containerfile-$(DISTRO) -t $(LOCAL_IMAGE) .

upload:
	podman push $(LOCAL_IMAGE) docker://docker.io/$(IMAGE)

.PHONY: all snapshot upload
