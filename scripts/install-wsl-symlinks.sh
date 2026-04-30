#!/usr/bin/env bash
set -e

install_symlinks() {
  local WINDOWS_C_DRIVE='/mnt/c'
  local WINDOWS_HOME="${WINDOWS_C_DRIVE}/Users/${USER}"
  local WINDOWS_DIR_WSL="${HOME}/windows"

  local -A path_map=(
    ["${WINDOWS_HOME}/AppData"]=""
    ["${WINDOWS_HOME}/Desktop"]=""
    ["${WINDOWS_HOME}/Documents"]=""
    ["${WINDOWS_HOME}/Downloads"]=""
    ["${WINDOWS_HOME}/Pictures"]=""
    ["${WINDOWS_C_DRIVE}/Program Files (x86)"]='ProgramFiles32'
    ["${WINDOWS_C_DRIVE}/Program Files"]='ProgramFiles64'
  )

  mkdir -p "${WINDOWS_DIR_WSL}"

  for source in "${!path_map[@]}"; do
    local link_name="${path_map[$source]}"

    # fallback to basename of source if empty
    if [[ -z "$link_name" ]]; then
      link_name="$(basename "$source")"
    fi

    local target="${WINDOWS_DIR_WSL}/${link_name}"

    ln -sfn "$source" "$target"
    echo "Linked: $source ->  $target"
  done
}

install_symlinks
