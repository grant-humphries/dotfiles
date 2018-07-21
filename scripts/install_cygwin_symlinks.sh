#!/usr/bin/env bash
set -e

WINDOWS_HOME="/c/Users/${USER}"
WINDOWS_DIR="${HOME}/windows"

declare -A path_map
path_map["${WINDOWS_HOME}/libraries"]="${HOME}/libraries"
path_map["${WINDOWS_HOME}/projects"]="${HOME}/projects"
path_map["${WINDOWS_HOME}/AppData"]="${WINDOWS_DIR}/AppData"
path_map["${WINDOWS_HOME}/Desktop"]="${WINDOWS_DIR}/Desktop"
path_map["${WINDOWS_HOME}/Documents"]="${WINDOWS_DIR}/Documents"
path_map["${WINDOWS_HOME}/Downloads"]="${WINDOWS_DIR}/Downloads"
path_map["${WINDOWS_HOME}/Pictures"]="${WINDOWS_DIR}/Pictures"
path_map['/c/Program Files (x86)']="${WINDOWS_DIR}/ProgramFiles32"
path_map['/c/Program Files']="${WINDOWS_DIR}/ProgramFiles64"

# create links for all drives so that can be accessed as /c, etc
ln -sfn '/cygdrive/*' '/'

# create custom links into default windows file structure
mkdir -p "${WINDOWS_DIR}"
for target_path in "${!path_map[@]}"; do
    ln -sfn "${target_path}" "${path_map[$target_path]}"
done
