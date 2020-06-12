#!/bin/bash

MASTER=asterxx
DEST_REPO="http://aster-repo.der.edf.fr/scm/hg/codeaster-a12da/src"

_usage()
{
    echo "Check if merge with main branch is trivial. If there is no conflict "
    echo "can actually merge, commit and push the new revision."
    echo
    echo "Usage: $(basename $0) [options]"
    echo
    echo "Options:"
    echo
    echo "  --help (-h)            Print this help information and exit."
    echo
    echo "  --verbose (-v)         Show commands output."
    echo
    echo "  --commit (-c)          Do the merge step, commit and push the revision."
    echo
    exit "${1:-1}"
}

check_merge_main()
{
    local do_commit=0
    local verbose=0
    local option
    while getopts ":-:hcv" option $@
    do
        if [ "${option}" = "-" ]
        then
            case ${OPTARG} in
                help ) _usage ;;
                commit ) do_commit=1 ;;
                verbose ) verbose=1 ;;
                * ) echo "Wrong option: --${OPTARG}" ; _usage 2 ;;
            esac
        else
            case ${option} in
                h ) _usage ;;
                c ) do_commit=1 ;;
                v ) verbose=1 ;;
                ? ) echo "Wrong option" ; _usage 2 ;;
        esac
        fi
    done
    shift $((OPTIND - 1))

    local branch=$(hg branch)
    local here=$(hg parent --template '{node}\n')
    local log=$(mktemp)

    echo -n "Checking merge ${branch} to ${MASTER}... "

    (
        # ensure that there are no uncommitted changes
        if [ `hg status -ardm | wc -l` != 0 ]
        then
            echo "There are uncommitted changes:"
            hg status
            return 1
        fi

        # refresh master branch
        hg pull -r ${MASTER} ${DEST_REPO}

        # check if current rev is a descendant of the head of the master branch
        rset="descendants(last('${MASTER}')) and ancestors('${here}')"
        if [ ${do_commit} -eq 0 ] && [ `hg log --rev "${rset}" | wc -l` != 0 ]
        then
            echo "${branch} is a descendant of the head of ${MASTER}."
            return 0
        fi

        printf "\nUpdate repository to '${MASTER}'...\n"
        hg update "${MASTER}"
        local origin=$(hg parent --template '{node}\n')

        printf "\nMerge ${branch} into ${MASTER}...\n"
        hg merge --tool="internal:fail" "${here}"
        mergeok=$?

        printf "\nList of conflicts (if any):\n"
        hg resolve --list
        echo "---"

        if [ ${do_commit} -eq 1 ]
        then
            printf "\nCommit merge...\n"
            hg commit --message "merge '${branch}'" < /dev/null || return 4
            hg log --graph --limit 100
            printf "\nPush new revision...\n"
            hg push --rev . --new-branch ${DEST_REPO}
            puskok=$?
            if [ ${puskok} -ne 0 ]
            then
                # the workspace should be deleted but if it is not done
                echo "Clean just committed revision..."
                hg strip .
                return 8
            else
                if [ "x${MERCURIAL_REPOSITORY_URL}" != "x" ]; then
                    printf "\nPush to the working repository...\n"
                    hg push --rev . --new-branch ${MERCURIAL_REPOSITORY_URL}
                fi
            fi
        fi

        printf "\nRestore working directory...\n"
        hg update --clean ${here}

        return ${mergeok}
    ) >> ${log} 2>&1
    ret=$?

    test "${ret}" = "0" && ok=ok || ok=failed
    echo ${ok}

    if [ "${ok}" != "ok" ] || [ ${verbose} -eq 1 ]
    then
        printf "\nOutput+Error:\n"
        cat ${log}
    fi
    rm -f ${log}

    return ${ret}
}

check_merge_main "$@"
exit $?
