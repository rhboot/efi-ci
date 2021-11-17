ARG ARCH=
FROM centos:stream10
MAINTAINER Peter Jones <pjones@redhat.com>

RUN echo 0
COPY epel.repo local.repo /etc/yum.repos.d/
COPY RPM-GPG-KEY-EPEL-10 /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-10
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-10
RUN dnf --nodocs -y --best --allowerasing install dnf-plugins-core
RUN dnf config-manager --set-enabled appstream
RUN dnf config-manager --set-enabled crb
RUN dnf config-manager --set-enabled epel
RUN dnf --nodocs -y --best --allowerasing install epel-release epel-rpm-macros
RUN dnf --nodocs -y --best --allowerasing install binutils clang-analyzer elfutils-libelf-devel gcc gettext git make popt-devel nspr-devel nss-devel rpm-build
# builddep on shim-unsigned-* doesn't work and I want this to be arch-agnostic, so manually add them by name
RUN dnf --nodocs -y --best --allowerasing install elfutils-libelf-devel git gnu-efi gnu-efi-devel openssl openssl-devel pesign
RUN dnf --nodocs -y --best --allowerasing builddep efivar gnu-efi pesign
RUN dnf --nodocs -y --best --allowerasing install vim-enhanced mandoc grub2-tools-minimal
RUN dnf --nodocs -y --best --allowerasing install glibc-devel.i686 efivar-devel.i686 || :
RUN dnf --nodocs -y --best --allowerasing install openssl-devel
RUN dnf --nodocs -y --best --allowerasing install gpg
RUN rpm -qa 'gnu-efi*' --qf '%{name}\n' | xargs -r rpm -e
# RUN rm -r /root/repo/ /etc/yum.repos.d/local.repo
RUN dnf -y clean all

RUN rm -rf /usr/share/doc/* /usr/share/man/*
