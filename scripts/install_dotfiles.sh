#!/usr/bin/env bash
set -e

install_dotfiles() {
    local dotfiles=(
        '.bashrc'
        '.bash_logout'
        '.bash_profile'
        '.inputrc'
        '.gitconfig'
        '.git-completion.bash'
        '.git-prompt.sh'
        '.git-templates'
        '.vim'
        '.vimrc'
    )

    # files for WSL only
    if [ -n "$WSL_INTEROP" ]; then
      dotfiles+=(
        '.trimet_bash_profile'
        '.gitconfig.trimet'
      )
    fi

    # add Windows specific configs if on that platform
    if [[ "${OSTYPE}" == 'cygwin' ]]; then
        dotfiles+=(
            '.gitconfig.windows'
            '.minttyrc'
        )
    fi

    local dotfiles_repo=$( cd "$(dirname "${0}")"; dirname "$(pwd -P)" )
    local default_dotfiles='/tmp/default_dotfiles'

    mkdir -p "${default_dotfiles}"

    for df in "${dotfiles[@]}"; do
        local source="${dotfiles_repo}/${df}"
        local link="${HOME}/${df}"

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
