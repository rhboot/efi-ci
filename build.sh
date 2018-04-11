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
    echo usage: $1 --event-type 'push|pull_request' --branch '<origin_branch>' --repo '<origin_repo>' --remote '<remote_repo>' --commit-range '<commit_range>' --commit '<commid_id>' --pull-request 'true|false' --pr-sha '<pr_commit_id>' --pr-branch '<pr_branch>'  --test-subject '<test_subject>'
    exit $2
}

remote_has_ref() {
    local remote="${1}" && shift
    local revision="${1}" && shift

    git show-ref -q "${remote:+${remote}/}${revision}"
}

declare event_type=""
declare origin_branch=""
declare origin_repo=""
declare commit_id=""
declare commit_range=""
declare pr="false"
declare pr_repo=""
declare pr_branch=""
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
        " --event-type ")
            event_type="$2"
            shift
            ;;
        " --branch ")
            origin_branch="$2"
            shift
            ;;
        " --repo ")
            origin_repo="$2"
            shift
            ;;
        " --commit ")
            commit_id="$2"
            shift
            ;;
        " --commit-range ")
            commit_range="$2"
            shift
            ;;
        " --pull-request "|" --pr ")
            pr="$2"
            shift
            ;;
        " --remote ")
            pr_repo="$2"
            shift
            ;;
        " --pr-sha ")
            pr_sha="$2"
            shift
            ;;
        " --pr-branch ")
            pr_branch="$2"
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
        if [[ "${event_type}" = "pull_request" ]] ; then
            git remote add remote "https://github.com/${pr_repo%%/*}/${subject}"
            if ! git fetch remote ; then
                git remote set-url remote "https://github.com/${origin_repo%%/*}/${subject}"
            fi
            if git fetch remote ; then
                if remote_has_ref remote "${pr_sha}" ; then
                    git checkout -f "remote/${pr_sha}"
                elif remote_has_ref remote "${pr_branch}" ; then
                    git checkout -f "remote/${pr_branch}"
                fi
            fi
        elif [[ "${event_type}" = "push" ]] ; then
            git fetch origin
            git reset --hard "origin/${origin_branch}"
        fi
    fi
    make clean all
    if [[ "${install}" = yes ]] ; then
        make PREFIX=/usr install
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

do_test "${test_subject}" yes yes
