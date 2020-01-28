
USER	?= vathpela
DISTRO	?= f32
TAG	?= v0
IMAGE	?= $(USER)/efi-ci-$(DISTRO):$(TAG)

all : snapshot upload

snapshot:
	podman build -f Dockerfile-$(DISTRO) -t $(IMAGE) .

upload:
	podman push $(IMAGE) docker://docker.io/$(IMAGE)

.PHONY: all snapshot upload
