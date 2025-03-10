vterm_printf() {
    if [ -n "$TMUX" ] \
        && { [ "${TERM%%-*}" = "tmux" ] \
            || [ "${TERM%%-*}" = "screen" ]; }; then
        # Tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}

vterm_cmd() {
    local vterm_elisp
    vterm_elisp=""
    while [ $# -gt 0 ]; do
        vterm_elisp="$vterm_elisp""$(printf '"%s" ' "$(printf "%s" "$1" | sed -e 's|\\|\\\\|g' -e 's|"|\\"|g')")"
        shift
    done
    vterm_printf "51;E$vterm_elisp"
}

find_file() {
    local localpath tramp_prefix host
    localpath=$(realpath "${@:-.}")
    if [ -n "$SSH_CONNECTION" ]; then
        # We're on a remote shell: use uname to get the remote hostname
        host=$(hostname -s)
        tramp_prefix="/ssh:${USER}@${host}:"
        vterm_cmd find-file "${tramp_prefix}${localpath}"
    else
        vterm_cmd find-file "$localpath"
    fi
}

say() {
    vterm_cmd message "%s" "$*"
}
