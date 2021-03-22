ARG ARCH=
FROM ${ARCH}centos:centos8
MAINTAINER Peter Jones <pjones@redhat.com>

COPY local.repo epel.repo /etc/yum.repos.d/
COPY RPM-GPG-KEY-EPEL-8 /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-8
COPY repo/ /root/repo/
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-8
RUN dnf --nodocs -y --best --allowerasing --disablerepo='*' --enablerepo=baseos --enablerepo=appstream --enablerepo=fasttrack --enablerepo=cr --enablerepo=devel --enablerepo=extras --enablerepo=plus --enablerepo=powertools install dnf-plugins-core
RUN dnf config-manager --set-disabled '*'
RUN dnf config-manager --set-enabled baseos appstream cr devel extras fasttrack plus powertools local epel
RUN dnf --nodocs -y --best --allowerasing install epel-release epel-rpm-macros
RUN dnf --nodocs -y --best --allowerasing install binutils ccache clang-analyzer elfutils-libelf-devel fedpkg-minimal gcc gettext git make popt-devel nspr-devel nss-devel rpm-build docker vim-enhanced
# these don't seem to exist in centos8 or epel8?
# RUN dnf --nodocs -y --best --allowerasing install 'binutils-*-linux-gnu' 'gcc-*-linux-gnu' 'mingw*-binutils' 'mingw*-gcc' docker vim-enhanced
RUN dnf --nodocs -y --best --allowerasing builddep efivar pesign
# builddep on shim-unsigned-* doesn't work and I want this to be arch-agnostic, so manually add them by name
RUN dnf --nodocs -y --best --allowerasing install elfutils-libelf-devel git gnu-efi gnu-efi-devel openssl openssl-devel pesign
# increment this to force an update
RUN echo 1
RUN dnf --nodocs -y --best --allowerasing update
RUN rpm -qa 'gnu-efi*' --qf '%{name}\n' | xargs -r rpm -e
RUN rm -r /root/repo/ /etc/yum.repos.d/local.repo
RUN dnf -y clean all

RUN rm -rf /usr/share/doc/* /usr/share/man/*
