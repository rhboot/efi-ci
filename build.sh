#!/bin/bash
#
# build.sh
# Copyright (C) 2018 Peter Jones <pjones@redhat.com>
#
# Distributed under terms of the GPLv3 license.
#

set -eu
set -x

usage() {
    echo usage: $1 --branch '<origin_branch>' --repo '<origin_repo>' --remote '<remote_repo>' --pr-sha '<commit_id>' --test-subject '<test_subject>'
    exit $2
}

declare origin_branch=""
declare origin_repo=""
declare remote_repo=""
declare pr_sha=""
declare test_subject=""

let n=0 || :

if [[ $# -le 1 ]] ; then
    usage $0 1
fi

while [[ $# > 0 ]] ; do
    case " $1 " in
        " --help "|" -h "|" -? ")
            usage $0 0
            ;;
        " --branch ")
            origin_branch="$2"
            shift
            ;;
        " --repo ")
            origin_repo="$2"
            shift
            ;;
        " --remote ")
            remote_repo="$2"
            shift
            ;;
        " --pr-sha ")
            commit_id="$2"
            shift
            ;;
        " --test-subject ")
            test_subject="$2"
            shift
            ;;
        *)
            usage $0 1
            ;;
    esac
    shift
done

if [[ -z "${test_subject}" ]] ; then
    echo "No test_subject specified" 1>&2
    exit 1
fi

do_test() {
    local subject="${1}" && shift
    local install="${1}" && shift
    local do_fetch="${1}" && shift

    cd "${subject}"
    if [[ "${do_fetch}" = yes ]] ; then
        git fetch origin
        git reset --hard origin/master
    fi
    make clean all
    if [[ "${install}" = yes ]] ; then
        make install
    fi
    cd ..
}

case "${test_subject}" in
efivar|pesign)
    ;;
shim)
    do_test pesign yes yes
    do_test gnu-efi yes yes
    ;;
fwupdate)
    do_test efivar yes yes
    do_test pesign yes yes
    do_test gnu-efi yes yes
    ;;
dbxtool|efibootmgr)
    do_test efivar yes yes
    ;;
*)
    echo "Unknown test subject" 1>&2
    exit 1
    ;;
esac

cd /root/"${test_subject}"
if [[ -n "${remote_repo}" ]] ; then
    git remote add remote https://github.com/${remote_repo}
    git fetch remote
    git checkout -f ${commit_id}
fi
cd ..
do_test "${test_subject}" no no
