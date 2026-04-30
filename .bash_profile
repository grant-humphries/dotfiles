# Load .bashrc in interactive shells if it exists
if [[ -n "$PS1" && -r "${HOME}/.bashrc" ]]; then
  source "${HOME}/.bashrc"
fi
