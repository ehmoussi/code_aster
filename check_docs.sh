#!/bin/bash

_usage()
{
    echo "Check that the documentation can be built."
    echo
    echo "'waf install' or 'waf install_debug' must have been run just before."
    echo
    echo "Usage: $(basename $0) [options]"
    echo
    echo "Options:"
    echo
    echo "  --help (-h)            Print this help information and exit."
    echo
    echo "  --waf script           Define the script to be used (default: ./waf_std)."
    echo
    echo "  --builddir DIR         Define the build directory (default: build/std)."
    echo
    echo "  --use-debug            Use the debug build (Use 'release' by default)."
    echo
    echo "  --verbose (-v)         Show commands output."
    echo
    exit "${1:-1}"
}

check_docs_main()
{
    local waf=./waf_std
    local builddir=build/std
    local variant="release"
    local verbose=0

    OPTS=$(getopt -o hv --long help,verbose,use-debug,waf:,builddir: -n $(basename $0) -- "$@")
    if [ $? != 0 ] ; then
        _usage >&2
    fi
    eval set -- "$OPTS"
    while true; do
        case "$1" in
            -h | --help ) _usage ;;
            -v | --verbose ) verbose=1 ;;
            --use-debug ) variant="debug" ;;
            --waf ) waf="$2" ; shift ;;
            --builddir ) builddir="$2" ; shift ;;
            -- ) shift; break ;;
            * ) break ;;
        esac
        shift
    done

    local suffix=""
    if [ ${variant} = "debug" ]; then
        suffix="_debug"
    fi
    local log=$(mktemp)

    echo -n "Checking docs... "

    (
        printf "Check installation... "
        if [ ! -f ${builddir}/${variant}/bibc/libaster.so ] \
        || [ ! -f ${builddir}/${variant}/data/profile.sh ]
        then
            echo "Installation not found in '${builddir}/${variant}'"
            return 1
        fi
        echo "ok"

        (
            printf "\nSource environment...\n"
            . ${builddir}/${variant}/data/profile.sh
            printf "\nGenerate objects documentation...\n"
            python3 doc/generate_rst.py --objects
            return $?
        )
        iret=$?
        [ ${iret} -ne 0 ] && return 1

        if [ `hg status -ardm | wc -l` != 0 ]; then
            printf "\nChanges must be committed:\n"
            hg status
            return 1
        fi

        (
            printf "\nSource environment...\n"
            . ${builddir}/${variant}/data/profile.sh
            printf "\nGenerate html documentation...\n"
            ${waf} doc${suffix}
            return $?
        )
        return $?

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

check_docs_main "$@"
exit $?
