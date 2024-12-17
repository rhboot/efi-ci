ARG ARCH=
FROM ${ARCH}fedora:41
MAINTAINER Peter Jones <pjones@redhat.com>

RUN echo 1
RUN dnf --releasever=41 --nodocs -y --best --disablerepo='*' --enablerepo=fedora --enablerepo=updates install python3-dnf
RUN dnf-3 --releasever=41 --nodocs -y --best --allowerasing --disablerepo='*' --enablerepo=fedora --enablerepo=updates install dnf-plugins-core glib2
RUN dnf-3 --releasever=41 config-manager --set-disabled '*'
RUN dnf-3 --releasever=41 config-manager --set-enabled fedora
RUN dnf-3 --releasever=41 config-manager --set-enabled updates
# increment this to force an update
RUN echo 3
RUN dnf-3 --releasever=41 --nodocs -y --best --allowerasing update
RUN dnf-3 --releasever=41 --nodocs -y --best --allowerasing install @buildsys-build ccache git make popt-devel nss-devel nspr-devel gettext elfutils-libelf-devel make gcc binutils clang-analyzer 'binutils-*-linux-gnu' 'gcc-*-linux-gnu' 'mingw*-binutils' 'mingw*-gcc'
RUN dnf-3 --releasever=41 --nodocs -y --best --allowerasing builddep efivar pesign 'shim-unsigned*'
RUN dnf-3 --releasever=41 --nodocs -y --best --allowerasing install qemu-user-static docker vim-enhanced efivar-devel mandoc
RUN dnf-3 --releasever=41 --nodocs -y --best --allowerasing install glibc-devel.i686 efivar-devel.i686 || :
RUN dnf-3 --releasever=41 --nodocs -y --best --allowerasing install glibc32 || :
RUN dnf-3 --releasever=41 --nodocs -y --best --allowerasing install grub2-tools-minimal
RUN dnf-3 --releasever=41 --nodocs -y --best --allowerasing install meson ninja-build
RUN dnf-3 --releasever=41 --nodocs -y --best --allowerasing install bear
RUN rpm -qa 'gnu-efi*' --qf '%{name}\n' | xargs -r rpm -e
RUN dnf-3 --releasever=41 -y clean all

RUN rm -rf /usr/share/doc/* /usr/share/man/*
