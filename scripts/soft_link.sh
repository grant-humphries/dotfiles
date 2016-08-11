#!/usr/bin/env bash

dot_files=( '.bash_profile' '.bashrc' '.gitconfig' '.vimrc' )

dotfiles_repo="$(dirname $(dirname $(pwd)/${0}))"
old_dotfiles="${HOME}/old_dotfiles"
mkdir -p "${old_dotfiles}"

for df in "${dot_files[@]}"; do
    mv "${HOME}/${df}" "${old_dotfiles}/"
    ln -s "${dotfiles_repo}/${df}" "${HOME}/${df}"
done
