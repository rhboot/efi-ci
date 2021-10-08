ARG ARCH=
FROM ${ARCH}fedora:35
MAINTAINER Peter Jones <pjones@redhat.com>

RUN dnf --nodocs -y --best --allowerasing --disablerepo='*' --enablerepo=fedora --enablerepo=updates install dnf-plugins-core
RUN dnf config-manager --set-disabled '*'
RUN dnf config-manager --set-enabled fedora
RUN dnf config-manager --set-enabled updates
# increment this to force an update
RUN echo 1
RUN dnf --nodocs -y --best --allowerasing update
RUN dnf --nodocs -y --best --allowerasing install @buildsys-build ccache git make popt-devel nss-devel nspr-devel gettext elfutils-libelf-devel make gcc binutils clang-analyzer 'binutils-*-linux-gnu' 'gcc-*-linux-gnu' 'mingw*-binutils' 'mingw*-gcc'
RUN dnf --nodocs -y --best --allowerasing builddep efivar pesign 'shim-unsigned*'
RUN dnf --nodocs -y --best --allowerasing install qemu-user-static docker vim-enhanced efivar-devel
RUN dnf --nodocs -y --best --allowerasing install glibc-devel.i686 efivar-devel.i686 || :
RUN rpm -qa 'gnu-efi*' --qf '%{name}\n' | xargs -r rpm -e
RUN dnf -y clean all

RUN rm -rf /usr/share/doc/* /usr/share/man/*
