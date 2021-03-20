ARG ARCH=
FROM ${ARCH}centos:centos7
MAINTAINER Peter Jones <pjones@redhat.com>

COPY local.repo epel.repo /etc/yum.repos.d/
COPY RPM-GPG-KEY-EPEL-7 /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
COPY repo/ /root/repo/
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
RUN yum install -y install @buildsys-build ccache git make popt-devel nss-devel nspr-devel gettext elfutils-libelf-devel make gcc binutils clang-analyzer binutils-aarch64-linux-gnu binutils-arm-linux-gnu binutils-x86_64-linux-gnu gcc-aarch64-linux-gnu gcc-arm-linux-gnu gcc-x86_64-linux-gnu mingw32-binutils mingw32-gcc mingw64-binutils mingw64-gcc
RUN yum install -y builddep efivar gnu-efi pesign 'shim'
RUN yum install -y vim-enhanced
RUN rm -r /root/repo/ /etc/yum.repos.d/local.repo
RUN yum clean all

RUN rm -rf /usr/share/doc/* /usr/share/man/*
