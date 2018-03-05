#!/bin/bash

_usage()
{
    echo "Check that the documentation can be be built."
    echo
    echo "'waf install' or 'waf install_debug' must have been run just before."
    echo
    echo "Usage: $(basename $0) [options]"
    echo
    echo "Options:"
    echo
    echo "  --help (-h)            Print this help information and exit."
    echo
    echo "  --use-debug            Use the debug build (Use 'release' by default)."
    echo
    echo "  --verbose (-v)         Show commands output."
    echo
    exit "${1:-1}"
}

check_docs_main()
{
    local variant="release"
    local verbose=0
    local option
    while getopts ":-:hv" option $@
    do
        if [ "${option}" = "-" ]
        then
            case ${OPTARG} in
                help ) _usage ;;
                use-debug ) variant="debug" ;;
                verbose ) verbose=1 ;;
                * ) echo "Wrong option: --${OPTARG}" ; _usage 2 ;;
            esac
        else
            case ${option} in
                h ) _usage ;;
                v ) verbose=1 ;;
                ? ) echo "Wrong option" ; _usage 2 ;;
        esac
        fi
    done
    shift $((OPTIND - 1))

    local suffix=""
    if [ ${variant} = "debug" ]; then
        suffix="_debug"
    fi
    local log=$(mktemp)

    echo -n "Checking docs... "

    (
        printf "Check installation... "
        if [ ! -f build/${variant}/bibc/libaster.so ] \
        || [ ! -f build/${variant}/data/profile.sh ]
        then
            echo "Installation not found in 'build/${variant}'"
            return 1
        fi
        echo "ok"

        printf "\nSource environment...\n"
        . build/${variant}/data/profile.sh

        printf "\nGenerate objects documentation...\n"
        python doc/generate_rst.py --objects
        test $? -eq 0 || return 1

        if [ `hg status -ardm | wc -l` != 0 ]
        then
            printf "\nChanges must be committed:\n"
            hg status
            return 1
        fi

        printf "\nGenerate html documentation...\n"
        ./waf doc${suffix}
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
