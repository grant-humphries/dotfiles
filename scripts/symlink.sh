#!/usr/bin/env bash

# exit script on any error
set -e

dot_files=( 
    '.bash_profile' 
    '.bashrc' 
    '.inputrc'
    '.gitconfig'
    '.minttyrc'
    '.vimrc'
)

old_dotfiles="${HOME}/old_dotfiles"
mkdir -p "${old_dotfiles}"
dotfiles_repo=$( cd  $(dirname ${0}); dirname $(pwd -P) )

for df in "${dot_files[@]}"; do
    # .minttyrc is only used on windows
    if [[ "${OSTYPE}" != 'cygwin' && "${df}" == '.minttyrc' ]]; then
        continue
    fi

    existing_df="${HOME}/${df}"
    if [ -f "${existing_df}" ]; then
        mv "${existing_df}" "${old_dotfiles}/"
    fi
    
    ln -sf "${dotfiles_repo}/${df}" "${HOME}/${df}"
done
