ARG ARCH=
FROM ${ARCH}fedora:34
MAINTAINER Peter Jones <pjones@redhat.com>

RUN dnf --nodocs -y --best --allowerasing install @buildsys-build ccache dnf-plugins-core git make popt-devel nss-devel nspr-devel gettext elfutils-libelf-devel make gcc binutils clang-analyzer binutils-aarch64-linux-gnu binutils-arm-linux-gnu binutils-x86_64-linux-gnu gcc-aarch64-linux-gnu gcc-arm-linux-gnu gcc-x86_64-linux-gnu mingw32-binutils mingw32-gcc mingw64-binutils mingw64-gcc
RUN dnf --nodocs -y --best --allowerasing builddep efivar gnu-efi pesign 'shim-unsigned*'
RUN dnf --nodocs -y --best --allowerasing install qemu-user-static docker ccache
RUN dnf config-manager --set-disabled rawhide fedora-modular fedora-modular-debuginfo fedora-modular-source updates-modular updates-modular-debuginfo updates-modular-source updates-testing-modular updates-testing-modular-debuginfo updates-testing-modular-source
RUN dnf config-manager --set-enabled fedora updates
RUN dnf config-manager --set-disabled '*rawhide*' '*modular*' '*cisco*'
RUN dnf --nodocs -y --best --allowerasing install vim-enhanced
RUN dnf -y clean all

RUN rm -rf /usr/share/doc/* /usr/share/man/*
