#
# Makefile
# Peter Jones, 2021-02-01 13:56
#

LARCH ?= $(shell $(CC) -dumpmachine | cut -f1 -d- | sed -e s,i[3456789]86,i686,)
EARCH ?= $(shell $(CC) -dumpmachine | cut -f1 -d- | sed -e s,i[3456789]86,ia32, -e s,aarch64,aa64, -e s,x86_64,x64,)
DARCH ?= $(shell $(CC) -dumpmachine | cut -f1 -d- | sed -e s,i[3456789]86,i686, -e s,aarch64,arm64v8, -e s,x86_64,amd64,)


all: image manifest

image:
	podman build -t vathpela/efi-ci:f33-$(EARCH) -f Containerfile \
		--build-arg ARCH=$(DARCH)/ \
		--build-arg LARCH=$(LARCH)
	podman push vathpela/efi-ci:f33-$(EARCH) docker://vathpela/efi-ci:f33-$(EARCH)


manifest:
	podman manifest create \
		vathpela/efi-ci:f34 \
		--amend vathpela/efi-ci:f34-aa64 \
		--amend vathpela/efi-ci:f34-x64
	podman manifest push docker://vathpela/efi-ci:f34

.ONESHELL: all manifest

# vim:ft=make
#
