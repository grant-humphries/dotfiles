#!/usr/bin/env bash
set -e

install_dotfiles() {
    local -A dotfiles=(
        ['.bashrc']=''
        ['.bash_logout']=''
        ['.bash_profile']=''
        ['.inputrc']=''
        ['.gitconfig']=''
        ['.git-completion.bash']=''
        ['.git-prompt.sh']=''
        ['.git-templates']=''
        ['.vim']=''
        ['.vimrc']=''
    )

    # files for WSL only
    if [ -n "$WSL_INTEROP" ]; then
      dotfiles+=(
        ['.trimet_bash_profile']=''
        ['.gitconfig.trimet']=''
        ['settings.json']="${HOME}/.vscode-server/data/Machine"
      )
    fi

    local dotfiles_repo=$( cd "$(dirname "${0}")"; dirname "$(pwd -P)" )
    local default_dotfiles='/tmp/default_dotfiles'
    local mv_flag=

    mkdir -p "${default_dotfiles}"

    for dotfile_name in "${!dotfiles[@]}"; do
        local source="${dotfiles_repo}/${dotfile_name}"
        local link="${dotfiles[$dotfile_name]:-${HOME}}/${dotfile_name}"

        # check if file or symlink already exists in link location
        if [[ -e "${link}" ]]; then
            mv "${link}" "${default_dotfiles}/"
            mv_flag=1
        fi

        # valid files are moved above, but the `f` flag causes broken
        # symlinks to be overwritten
        ln -sf "${source}" "${link}"
    done

    if [[ -n "${mv_flag}" ]]; then
        echo 'some dotfiles already existed in your home directory, they have '
        echo "been moved to the following directory: ${default_dotfiles}"
    fi
}

install_dotfiles
