#!/usr/bin/env bash

set -e

install_dotfiles() {
  local -A dotfiles=(
    ['.bashrc']=""
    ['.bash_logout']=""
    ['.bash_profile']=""
    ['.inputrc']=""
    ['.gitconfig']=""
    ['.git-completion.bash']=""
    ['.git-prompt.sh']=""
    ['.git-templates']=""
    ['.prettierrc']=""
    ['.vim']=""
    ['.vimrc']=""
  )

  # WSL-specific dotfiles
  if [ -n "$WSL_INTEROP" ]; then
    dotfiles+=(
      ['.bashrc.trimet']=""
      ['.gitconfig.trimet']=""
      ['settings.json']="${HOME}/.vscode-server/data/Machine"
    )
  fi

  # macOS-specific dotfiles
  if [[ "${OSTYPE}" =~ darwin ]]; then
    dotfiles+=(
      ['settings.json']="${HOME}/Library/Application Support/Code/User"
    )
  fi

  local dotfiles_repo=$(
    cd "$(dirname "${0}")"
    dirname "$(pwd -P)"
  )
  local backup_dotfiles="/tmp/backup_dotfiles/$(date +%Y%m%d-%H%M%S)"
  local mv_flag=

  mkdir -p "${backup_dotfiles}"

  for dotfile_name in "${!dotfiles[@]}"; do
    local source="${dotfiles_repo}/${dotfile_name}"
    local link="${dotfiles[$dotfile_name]:-${HOME}}/${dotfile_name}"

    # check if file or symlink already exists in link location
    if [[ -e "${link}" || -L "${link}" ]]; then
      mv "${link}" "${backup_dotfiles}/"
      mv_flag=1
    fi

    # valid files are moved above, but the `f` flag causes broken
    # symlinks to be overwritten
    ln -sf "${source}" "${link}"
  done

  if [[ -n "${mv_flag}" ]]; then
    echo 'some dotfiles already existed in your home directory, they have '
    echo "been moved to the following directory: ${backup_dotfiles}"
  fi
}

install_dotfiles

# Setup vim plug-ins (install plugin manager and plug-ins)

if [ ! -f ~/.vim/autoload/plug.vim ]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

vim +PlugInstall +qall
