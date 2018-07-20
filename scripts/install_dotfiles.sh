#!/usr/bin/env bash
set -e

dotfiles=(
    '.bashrc'
    '.bash_logout'
    '.bash_profile'
    '.inputrc'
    '.gitconfig'
    '.git-completion.bash'
    '.git-prompt.sh'
    '.git-templates'
    '.minttyrc'
    '.vim'
    '.vimrc'
)

win_unix=( 'cygwin' 'msys' )
default_dotfiles='/tmp/default_dotfiles'
dotfiles_repo=$( cd $(dirname ${0}); dirname $(pwd -P) )

mkdir -p "${default_dotfiles}"

for df in "${dotfiles[@]}"; do
    # .minttyrc is only used on windows
    if [[ ! "${win_unix[@]}" =~ "${OSTYPE}" && "${df}" == '.minttyrc' ]]; then
        continue
    fi

    target="${dotfiles_repo}/${df}"
    link="${HOME}/${df}"

    # check if file or symlink already exists in link location
    if [ -e "${link}" ]; then
        mv "${link}" "${default_dotfiles}/"
        mv_flag=1
    fi

    # if in running msys a windows symlink must be created
    if [[ "${OSTYPE}" == 'msys' ]]; then
        cmd //c mklink "$(cygpath -w ${link})" "$(cygpath -w ${target})"
    else
        ln -s "${target}" "${link}"
    fi
done

if [ -n "${mv_flag}" ]; then
    echo 'some dotfiles already existed in your home directory, they have '
    echo "been moved to the following directory: ${default_dotfiles}"
fi
