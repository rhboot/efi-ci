ARG ARCH=
FROM ${ARCH}fedora:32
MAINTAINER Peter Jones <pjones@redhat.com>

RUN dnf --nodocs -y --best --allowerasing --disablerepo='*' --enablerepo=fedora --enablerepo=updates install dnf-plugins-core
RUN dnf config-manager --set-disabled '*'
RUN dnf config-manager --set-enabled fedora updates
RUN dnf --nodocs -y --best --allowerasing install @buildsys-build ccache git make popt-devel nss-devel nspr-devel gettext elfutils-libelf-devel make gcc binutils clang-analyzer 'binutils-*-linux-gnu' 'gcc-*-linux-gnu' 'mingw*-binutils' 'mingw*-gcc' efivar-devel
# builddep on shim-unsigned-* doesn't work and I want this to be arch-agnostic, so manually add them by name
RUN dnf --nodocs -y --best --allowerasing install elfutils-libelf-devel git gnu-efi gnu-efi-devel openssl openssl-devel pesign
RUN dnf --nodocs -y --best --allowerasing builddep efivar pesign
RUN dnf --nodocs -y --best --allowerasing install qemu-user-static docker ccache vim-enhanced mandoc
RUN dnf --nodocs -y --best --allowerasing install glibc-devel.i686 efivar-devel.i686 || :
# increment this to force an update
RUN echo 1
RUN dnf --nodocs -y --best --allowerasing update
RUN rpm -qa 'gnu-efi*' --qf '%{name}\n' | xargs -r rpm -e
RUN dnf -y clean all

RUN rm -rf /usr/share/doc/* /usr/share/man/*
