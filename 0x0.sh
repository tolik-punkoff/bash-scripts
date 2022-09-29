#!/bin/bash
# 0x0 - client for 0x0.st
#
# Copyright 2016-2018 Kylie McClain <kylie@somas.is>
# Distributed under the terms of the 0BSD license

me=${0##*/}
host=https://0x0.st

if [[ ! -t 1 ]];then
    quiet=true
fi

help() {
    cat >&2 <<EOF
Usage: ${me} [-f <file>] [-s <url>] [-u <url>] [file]

Client for interacting with 0x0.st.

If no file is given, upload stdin.

    -f <file>       - upload <file>
    -s <url>        - shorten <url>
    -u <url>        - upload content of <url>

EOF
}

clip() {
    if command -v xclip >/dev/null 2>&1;then
        printf '%s' "$@" | xclip
    fi
}

file_upload() {
    local curl_opts="-s" file="$1" type
    [[ "${progress_quiet}" ]] || curl_opts="-#"
    [[ "${quiet}" ]] || printf "uploading \"%s\"...\n" "${file}" >&2
    [[ "$#" -gt 1 ]] && printf "%s ... " "${url}"
    url=$(curl ${curl_opts} -F "file=@${file}" "${host}")
    printf '%s' "${url}"
    [ -t 1 ] && printf '\n'
    clip "${url}"
    printf "\n$(date)\n\t${file}\n\t\t${url}" >> ~/.config/0x0.history
}

shorten_url() {
    local curl_opts="-s" url="$1" shortened
    [[ "${progress_quiet}" ]] || curl_opts="-#"
    [[ "${quiet}" ]] || printf "shortening \"${url}\"...\n" >&2
    [[ "$#" -gt 1 ]] && printf "%s ... " "${url}"
    shortened=$(curl ${curl_opts} -F "shorten=${url}" "${host}")
    printf '%s' "${shortened}"
    [ -t 1 ] && printf '\n'
    clip "${shortened}"
    printf "\n$(date)\n\t${shortened}" >> ~/.config/0x0.history
}

upload_url() {
    local curl_opts="-s" url="$1" uploaded
    [[ "${progress_quiet}" ]] || curl_opts="-#"
    [[ "${quiet}" ]] || printf "uploading \"%s\"...\n" "${url}" >&2
    [[ "$#" -gt 1 ]] && printf "%s ... " "${url}"
    uploaded=$(curl ${curl_opts} -F "url=${url}" "${host}")
    printf '%s' "${uploaded}"
    [ -t 1 ] && printf '\n'
    clip "${uploaded}"
    printf "\n$(date)\n\t${uploaded}" >> ~/.config/0x0.history
}

# 1KiB = 1024 bytes
# 1MiB = 1024 KiB
# max size - 256MiB

max_size=$(( (1024*1024) * 256 ))

if [[ -f "$1" || "$#" -lt 1 ]];then
    mode="default"
else
    mode="$1"
    shift
fi

case "$mode" in
    default)
        if [[ "$#" -gt 0 ]];then
            file_upload "${@}"
        else
            cat | quiet=true file_upload "/dev/stdin"
        fi
    ;;
    -f)
        file_upload "${@}"
    ;;
    -u)
        upload_url "${@}"
    ;;
    -s)
        shorten_url "${@}"
    ;;
    -h|--help)
        help
    ;;
esac

