#!/usr/bin/env bash

# ** Installs cx_Oracle on macOS **
# this thread is a great guide and people are keeping things up to date
# in the comments: https://gist.github.com/thom-nic/6011715
# this was also very helpful, just had to adapt it slightly:
# https://gist.github.com/mcescalante/50f1663825fea582953c187f83c8b92d

set -e

usage() {
    echo "Usage: $0 [-c cx_Oracle version] [-v <oracle client version>]"
    echo '  (-v requires the five number client version)'
    exit 1
}

while getopts ':c:v:' opt; do
    case "${opt}" in
        c)
            cx_version="==${OPTARG}"
            ;;
        v)
            client_version="${OPTARG}"
            ;;
        *)
            usage
            ;;
    esac
done

# prompt user to download instead client
echo 'cx_Oracle requires that some components of the oracle client be'
echo 'installed, to proceed with this script download the parts:'
echo '"instant-client-basiclite-macos.x64" and "instant-client-sdk-macos.x64"'
echo $'from the following url and save it to the "/tmp" directory\n'
echo $'http://www.oracle.com/technetwork/topics/intel-macsoft-096467.html\n'

read -p $'Are you ready to proceed?\n'

if [ -z "${client_version}" ]; then
    read -p 'Enter the 5 number Oracle client version: ' client_version
fi

# these environment variables must also be in your path when importing
# cx_Oracle or python will throw an error
export ORACLE_HOME='/usr/local/lib/oracle/client'
export LD_LIBRARY_PATH="${ORACLE_HOME}"
export DYLD_LIBRARY_PATH="${ORACLE_HOME}"

rm -rf "${ORACLE_HOME}"
mkdir -p "${ORACLE_HOME}"

# split client version number at dots and write to array
IFS='.' read -a version_array <<< "${client_version}"
v_major="${version_array[0]}"
v_minor="${version_array[1]}"

# unpack the instant client and move it into ORACLE_HOME, the file is
# not unzipped there directly because it comes wrapped in a subdir that
# has the version number and ORACLE_HOME should be generic
client_basiclite="instantclient-basiclite-macos.x64-${client_version}.zip"
client_sdk="instantclient-sdk-macos.x64-${client_version}.zip"
client_dir="instantclient_${v_major}_${v_minor}"

cd '/tmp'
unzip -o "${client_basiclite}"
unzip -o "${client_sdk}"

cd "${client_dir}"
mv ./* "${ORACLE_HOME}"

# link specific version of lib to generic names
cd "${ORACLE_HOME}"
ln -s "libclntsh.dylib.${v_major}.${v_minor}" 'libclntsh.dylib'
ln -s "libocci.dylib.${v_major}.${v_minor}" 'libocci.dylib'

pip install "cx_Oracle${cx_version}"
