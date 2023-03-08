#
# Makefile
# Peter Jones, 2021-02-01 13:56
#

RELEASE ?= f37

LARCH ?= $(shell $(CC) -dumpmachine | cut -f1 -d- | sed -e s,i[3456789]86,i686,)

get_efi_arch = $(shell echo -n "${1}" | sed -e s,aarch64,aa64, -e s,x86_64,x64,)
get_docker_arch = $(shell echo -n "${1}" | sed -e s,aarch64,arm64v8, -e s,x86_64,amd64,)
get_manifest_arch = $(shell echo -n "${1}" | sed -e s,aarch64,arm64, -e s,x86_64,amd64,)

EARCH = $(call get_efi_arch,$(LARCH))
DARCH = $(call get_docker_arch,$(LARCH))
MARCH = $(call get_manifest_arch,$(LARCH))

ARCHES := aarch64 x86_64

all: update

image-create:
	podman build -t "localhost/vathpela/efi-ci:$(RELEASE)-$(EARCH)" -f Containerfile \
		--build-arg ARCH=$(DARCH)/

image-pull:
	$(foreach ARCH, $(ARCHES),\
		podman pull --arch "$(call get_manifest_arch,$(ARCH))" \
			"docker://vathpela/efi-ci:$(RELEASE)-$(call get_efi_arch,$(ARCH))" ; \
		)

image-push:
	podman push "localhost/vathpela/efi-ci:$(RELEASE)-$(EARCH)" "docker://vathpela/efi-ci:$(RELEASE)-$(EARCH)"

manifest-remove:
	podman rmi "localhost/vathpela/efi-ci:$(RELEASE)"

manifest-create:
	podman manifest create "localhost/vathpela/efi-ci:$(RELEASE)"

manifest-pull:
	$(foreach ARCH, $(ARCHES),\
		podman pull --arch "$(call get_manifest_arch,$(ARCH))" \
			"docker://vathpela/efi-ci:$(RELEASE)" ; \
		)

manifest-clean:
	podman manifest inspect "localhost/vathpela/efi-ci:$(RELEASE)" \
	| grep -B5 '"architecture": "$(MARCH)"' \
	| grep '"digest":' \
	| cut -d'"' -f4 \
	| xargs -r -n1 podman manifest remove "localhost/vathpela/efi-ci:$(RELEASE)"

manifest-add:
	podman manifest add "localhost/vathpela/efi-ci:$(RELEASE)" "docker://vathpela/efi-ci:$(RELEASE)-$(EARCH)"

manifest-push:
	podman manifest push --all "localhost/vathpela/efi-ci:$(RELEASE)" "docker://vathpela/efi-ci:$(RELEASE)"

local-update:
	$(MAKE) image-pull || :
	$(MAKE) manifest-remove || :
	$(MAKE) manifest-create
	$(MAKE) image-create

update:
	$(MAKE) image-pull || :
	$(MAKE) manifest-remove || :
	$(MAKE) manifest-create
	$(MAKE) image-create image-push
	$(MAKE) manifest-add EARCH=x64 || :
	$(MAKE) manifest-add EARCH=aa64 || :
	$(MAKE) manifest-push

.ONESHELL: update

# vim:ft=make
#
