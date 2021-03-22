ARG ARCH=
FROM ${ARCH}fedora:34
MAINTAINER Peter Jones <pjones@redhat.com>

RUN dnf --nodocs -y --best --allowerasing --disablerepo='*' --enablerepo=fedora --enablerepo=updates install dnf-plugins-core
RUN dnf config-manager --set-disabled '*'
RUN dnf config-manager --set-enabled fedora updates
RUN dnf --nodocs -y --best --allowerasing install @buildsys-build ccache git make popt-devel nss-devel nspr-devel gettext elfutils-libelf-devel make gcc binutils clang-analyzer binutils-aarch64-linux-gnu binutils-arm-linux-gnu binutils-x86_64-linux-gnu gcc-aarch64-linux-gnu gcc-arm-linux-gnu gcc-x86_64-linux-gnu mingw32-binutils mingw32-gcc mingw64-binutils mingw64-gcc
RUN dnf --nodocs -y --best --allowerasing builddep efivar pesign 'shim-unsigned*'
RUN dnf --nodocs -y --best --allowerasing install qemu-user-static docker ccache vim-enhanced
# increment this to force an update
RUN echo 1
RUN dnf --nodocs -y --best --allowerasing update
RUN rpm -qa 'gnu-efi*' --qf '%{name}\n' | xargs -r rpm -e
RUN dnf -y clean all

RUN rm -rf /usr/share/doc/* /usr/share/man/*
