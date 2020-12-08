FROM centos:centos7
MAINTAINER Peter Jones <pjones@redhat.com>

RUN dnf --nodocs -y --best --allowerasing install @buildsys-build dnf-plugins-core git make popt-devel nss-devel nspr-devel gettext elfutils-libelf-devel make gcc binutils clang-analyzer binutils-aarch64-linux-gnu binutils-arm-linux-gnu binutils-x86_64-linux-gnu gcc-aarch64-linux-gnu gcc-arm-linux-gnu gcc-x86_64-linux-gnu mingw32-binutils mingw32-gcc mingw64-binutils mingw64-gcc
RUN dnf --nodocs -y --best --allowerasing builddep efivar gnu-efi pesign 'shim'
RUN dnf -y clean all

RUN rm -rf /usr/share/doc/* /usr/share/man/*
