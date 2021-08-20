# load .bashrc; functions invoked below are defined there
[[ -r "${HOME}/.bashrc" ]] && source "${HOME}/.bashrc"

#----------------------------------------------------------------------
# Environment Variables
#----------------------------------------------------------------------
# any environment variables declared here should not be bash specific,
# put bash specific variables in .bashrc

if [[ -z "${TMP}" && -d '/tmp' ]]; then
    export TMP='/tmp'
fi

if [[ -z "${TEMP}" && -d '/tmp' ]]; then
    export TEMP='/tmp'
fi

if [[ "${OSTYPE}" == 'cygwin' ]]; then
    # export setting made to this environment variable in .bashrc
    export SHELLOPTS

    # by default this variable is set to a
    # directory that doesn't have adequate permissions, it is a
    # temporary directory where setuptools unzips eggs
    export PYTHON_EGG_CACHE='/tmp/python_eggs'
    mkdir -p "${PYTHON_EGG_CACHE}"

    # cygwin sets the `TZ` environment variable by default, but Windows
    # Python doesn't know how to read the value in the format cygwin
    # provides which causes the timezone to be UTC instead of local
    unset TZ
elif [[ "${OSTYPE}" =~ 'darwin' ]]; then
    # these are required for connect with cx_Oracle
    export TNS_ADMIN="/usr/local/lib/oracle"
    export ORACLE_HOME="${TNS_ADMIN}/client"
    export LD_LIBRARY_PATH="${ORACLE_HOME}:${LD_LIBRARY_PATH}"
    export DYLD_LIBRARY_PATH="${ORACLE_HOME}:${DYLD_LIBRARY_PATH}"

    # nvm config for homebrew install
    export NVM_DIR="$HOME/.nvm"

    # This loads nvm
    [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
    [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] \
        && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"
fi

#----------------------------------------------------------------------
# Path Adjustments
#----------------------------------------------------------------------

# Ruby version manager
add_to_path "${HOME}/.rvm/bin"

#----------------------------------------------------------------------
# SSH Config
#----------------------------------------------------------------------

launch_ssh_agent

#----------------------------------------------------------------------
# Script Sourcing
#----------------------------------------------------------------------

# Load RVM into a shell session *as a function*
[[ -s "${HOME}/.rvm/scripts/rvm" ]] \
    && source "${HOME}/.rvm/scripts/rvm"

[[ -r '/usr/local/etc/profile.d/bash_completion.sh' ]] \
    && source '/usr/local/etc/profile.d/bash_completion.sh'
