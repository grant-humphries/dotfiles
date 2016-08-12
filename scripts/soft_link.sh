#!/usr/bin/env bash

# exit script on any error
set -e

dot_files=( 
    '.bash_profile' 
    '.bashrc' 
    '.gitconfig' 
    '.minttyrc'
    '.vimrc'
)

old_dotfiles="${HOME}/old_dotfiles"
mkdir -p "${old_dotfiles}"
dotfiles_repo="$(dirname $(dirname $(pwd)${0#.}))"

for df in "${dot_files[@]}"; do
    existing_df="${HOME}/${df}"
    if [ -f "${existing_df}" ]; then
        mv "${existing_df}" "${old_dotfiles}/"
    
    fi
    
    ln -sf "${dotfiles_repo}/${df}" "${HOME}/${df}"
done
