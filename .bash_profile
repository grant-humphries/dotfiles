# Load .bashrc in interactive shells if it exists
[[ -n "$PS1" && -r "${HOME}/.bashrc" ]]; then
    source "${HOME}/.bashrc"
 fi
