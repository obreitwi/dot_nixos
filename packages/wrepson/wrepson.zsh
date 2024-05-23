#!/bin/env zsh

FILENAME="$0"

usage() {
cat <<EOF
Usage:
    ${FILENAME} [OPTIONS] (--create | --edit | [--folder=$PWD] [--name=<filename>] | -p <full path> | --path=<full path>)

Description:
    Wrap epsonscan2 on the command line for a sane experience.

Options:
    -c --config=<config>    Which config file to operate on.
    -D --no-duplex          Disable duplex.
    -x                      Run with debug output enabled.
    --create                Create config.
    --dpi                   Overwrite DPI settings.
    --edit                  Edit config.
    --remove                Remove file prior to scanning.
EOF
}

zmodload zsh/zutil
zparseopts -D -E - h=arg_help -help=arg_help \
    -config:=arg_config \
    -create=arg_create \
    -dpi:=arg_dpi \
    -edit=arg_edit \
    -folder:=arg_folder \
    -name:=arg_name \
    -no-duplex=arg_no_duplex \
    -path:=arg_path \
    -remove=arg_remove \
    D=arg_no_duplex \
    c:=arg_config \
    p:=arg_path \
    x=arg_test

if [ -n "${arg_test}" ]; then
    set -x
fi

alias clear_color='sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"'

if (( $# )); then
    end_opts=$@[(i)(--|-)]
    if [[ -n ${invalid_opt::=${(M)@[0,end_opts-1]#-}} ]]; then
        echo >&2 "Invalid options: $invalid_opt"
        exit 1
    fi
    set -- "${@[0,end_opts-1]}" "${@[end_opts+1,-1]}"
fi

set -euo pipefail

if [ -n "${arg_help}" ]; then
    usage
    exit 0
fi

if ! which jq>/dev/null; then
    echo "ERROR: jq not found!" >&2
    exit 1
fi

if (( ${#arg_config} > 1 )); then
    config="${arg_config[-1]}"
    config="${config%.SF2}.SF2"
    if ! [ -f "${config}" ]; then
        config="${HOME}/.config/epsonscan2/${config}"
    fi
else
    config="$HOME/.config/epsonscan2/DefaultSettings.SF2"
fi

if [ -n "${arg_create}" ]; then
    tmpdir="${TMPDIR:-/tmp}"
    (cd "${tmpdir}" && epsonscan2 -c) || exit 1
    mv "${tmpdir}/DefaultSettings.SF2" "${config}"
    echo "Created: ${config}" >&2
    exit 0
fi

if [ -n "${arg_edit}" ]; then
    epsonscan2 --edit "${config}"
    exit 0
fi

if (( ( ${#arg_name} > 1 || ${#arg_folder} > 1 ) && ${#arg_path} > 1 )) \
    || (( ( ${#arg_name} <= 1 || ${#arg_folder} <= 1 ) && ${#arg_path} <= 1 )); then
    echo "ERROR: Please specify either --folder/--name OR --path." >&2
    exit 1
fi

if (( ${#arg_folder} > 1 )); then
    folder="$(readlink -m "${arg_folder[-1]}")"
else
    folder="$(pwd -P)"
fi

if (( ${#arg_name} > 1 )); then
    filename="${arg_name[-1]}"
else
    filename="scan"
fi

if (( ${#arg_path} > 1 )); then
    filename="$(basename "${arg_path[-1]}")"
    folder="$(dirname "$(readlink -m "${arg_path[-1]}")")"
fi

filename="${filename:r}.pdf"

if [ -n "${arg_no_duplex}" ]; then
    duplex=0
else
    duplex=1
fi

if [ -n "${arg_remove}" ]; then
    remove=1
else
    remove=0
fi

filename_full="${folder}/${filename}"

if [ -f "${filename_full}" ]; then
    if (( remove > 0 )); then
        rm -v "${filename_full}"
    else
        echo "ERROR: ${filename_full} already exists, opening…" >&2
        xdg-open "${filename_full}"
        exit 1
    fi
fi


file_jq_filter=$(mktemp jq-filter-XXXXXXXX.jq)
file_epsonscan_cfg=$(mktemp epsonscan2-XXXXXXXX.SF2)
echo -n ".">"${file_jq_filter}"

TRAPEXIT() {
    rm "${file_jq_filter}" "${file_epsonscan_cfg}"
}

append_filter() {
    echo -n " | $* " >> "${file_jq_filter}"
}
# Usage: filter_set_value <name> <type> <value>
filter_set_value() {
    append_filter ".[\"Preset\"][0][\"0\"][0][\"${1}\"][\"${2}\"] = \"${3}\""
}

filter_set_value UserDefinePath string "${folder}"
filter_set_value FileNamePrefix string "${filename:r}"
filter_set_value DuplexType int "${duplex}"

if (( ${#arg_dpi} > 1 )); then
    filter_set_value Resolution int "${arg_dpi[-1]}"
fi

jq -f "${file_jq_filter}" <"${config}" >"${file_epsonscan_cfg}"

if ! [ -e "${folder}" ]; then
    mkdir -p "${folder}"
fi

epsonscan2 -s "${file_epsonscan_cfg}"

echo "Opening: ${filename_full}" >&2
xdg-open "${filename_full}"
