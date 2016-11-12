#!/usr/bin/env bash

# install winpty to clean install of babun/cygwin
# winpty project: https://github.com/rprichard/winpty

set -e

winpty_github='https://github.com/rprichard/winpty.git'
winpty_dir=$(basename "${winpty_github}" '.git' )
install_dir="${HOME}/.local"

dependencies() {
    # install dependencies with babun's pact, note that gcc-g++ and
    # gcc-core must be at the same version, this should take care of
    # that
    pact install mingw64-i686-gcc-g++
    pact install gcc-g++
    pact update gcc-core
}

clone() {
    if [ ! -d "${TMP}/${winpty_dir}" ]; then
        # clone the winpty repo
        cd "${TMP}"
        git clone "${winpty_github}"
    fi
}

compile() {
    cd "${TMP}/${winpty_dir}"
    ./configure
    make
    make install PREFIX="${install_dir}"
}

dependencies
clone
compile
