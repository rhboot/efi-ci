ARG ARCH=
FROM ${ARCH}centos:centos8
MAINTAINER Peter Jones <pjones@redhat.com>

COPY local.repo epel.repo /etc/yum.repos.d/
COPY RPM-GPG-KEY-EPEL-8 /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-8
COPY repo/ /root/repo/
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-8
RUN dnf --nodocs -y --best --allowerasing install epel-release epel-rpm-macros
RUN dnf --nodocs -y --best --allowerasing install binutils ccache clang-analyzer dnf-plugins-core elfutils-libelf-devel fedpkg-minimal gcc gettext git make popt-devel nspr-devel nss-devel rpm-build
# builddep on shim-unsigned-* doesn't work and I want this to be arch-agnostic, so manually add them by name
RUN dnf --nodocs -y --best --allowerasing install elfutils-libelf-devel git gnu-efi gnu-efi-devel openssl openssl-devel pesign
RUN dnf --nodocs -y --best --allowerasing builddep efivar gnu-efi pesign
RUN dnf --nodocs -y --best --allowerasing ccache
RUN rm -r /root/repo/ /etc/yum.repos.d/local.repo
RUN dnf -y clean all

RUN rm -rf /usr/share/doc/* /usr/share/man/*
