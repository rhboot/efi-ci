ARG ARCH=
FROM ${ARCH}centos:centos7
MAINTAINER Peter Jones <pjones@redhat.com>

COPY local.repo epel.repo /etc/yum.repos.d/
COPY RPM-GPG-KEY-EPEL-7 /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
RUN yum install -y install @buildsys-build ccache git make popt-devel nss-devel nspr-devel gettext elfutils-libelf-devel make gcc binutils clang-analyzer 'binutils-*-linux-gnu' 'gcc-*-linux-gnu' 'mingw*-binutils' 'mingw*-gcc'
RUN yum install -y vim-enhanced
RUN yum-builddep -y efivar pesign 'shim'
# increment this to force an update
RUN echo 1
RUN yum update -y
RUN rpm -qa 'gnu-efi*' --qf '%{name}\n' | xargs -r rpm -e
RUN yum clean all
RUN rm -rf /usr/share/doc/* /usr/share/man/* /etc/yum.repos.d/local.repo
