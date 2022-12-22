backup() {
    date_string="$(date +'%Y-%m-%d.%H.%M.%S')"
    if [[ -d "$1" ]]; then
        local -r no_slash="${1%/}"
        cp -r "${no_slash}" "${no_slash}.${date_string}.bak"
    elif [[ -f "$1" ]]; then
        cp "$1" "${1}.${date_string}.bak"
    else
        echo "Only files and directories supported"
    fi
}
 