#!/usr/bin/env bash
set -e

# TODO: change name of script

install_config() {
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
    
    local start_up_scripts=()
    local -A config_mapping

    # add Windows specific configs if on that platform
    if [[ "$OSTYPE" == 'cygwin' ]]; then
        dotfiles+=(
            '.gitconfig.windows'
            '.minttyrc'
        )
    fi

    # WSL specific files
    if [ -n "$WSL_DISTRO_NAME" ]; then
        start_up_scripts+=(
            'map_network_drives.sh'
        )

        config_mapping['wsl.conf']='/etc'
    fi

    for df in "${dotfiles[@]}"; do
        config_mapping[$df]="$HOME"
    done

    for ss in "${start_up_scripts[@]}"; do
        config_mapping["scripts/${ss}"]='/etc/profile.d'
    done

    local dotfiles_repo=$( cd "$(dirname "${0}")"; dirname "$(pwd -P)" )
    local default_config_dir='/tmp/default_config_files'

    mkdir -p "${default_config_dir}"

    for repo_path in "${!config_mapping[@]}"; do
        local file_name="$(basename "$repo_path")"
        local source="${dotfiles_repo}/${repo_path}"
        local link="${config_mapping[$repo_path]}/${file_name}"

        # check if file or symlink already exists in link location
        if [[ -e "$link" ]]; then
            echo "$file_name already exists at the target location on the file system, moving that file to $default_config_dir"

            mv "$link" "${default_config_dir}/"
        fi

        # valid files are moved above, but the `f` flag causes broken
        # symlinks to be overwritten
        ln -sf "$source" "$link"
    done
}

install_config
