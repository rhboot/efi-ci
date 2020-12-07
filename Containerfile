FROM fedora:32
MAINTAINER Peter Jones <pjones@redhat.com>

RUN dnf --nodocs -y --best --allowerasing install @buildsys-build dnf-plugins-core git make popt-devel nss-devel nspr-devel gettext elfutils-libelf-devel make gcc binutils
RUN dnf --nodocs -y --best --allowerasing builddep efivar gnu-efi pesign 'shim-unsigned*'
RUN dnf -y clean all

RUN rm -rf /usr/share/doc/* /usr/share/man/*
