# load .bashrc; functions invoked below are defined there
[[ -r "${HOME}/.bashrc" ]] && source "${HOME}/.bashrc"

#----------------------------------------------------------------------
# Environment Variables and Path Adjustments
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
# macOS
elif [[ "${OSTYPE}" =~ 'darwin' ]]; then
    # add homebrew to PATH
    export PATH="/opt/homebrew/bin:${PATH}"

    # load bash completion
    bash_completion="/opt/homebrew/etc/profile.d/bash_completion.sh"
    [[ -r "${bash_completion}" ]] && . "${bash_completion}"

    # setup nvm
    export NVM_DIR="${HOME}/.nvm"
    nvm="/opt/homebrew/opt/nvm/nvm.sh"
    nvm_completion="/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

    [ -s "${nvm}" ] && . "${nvm}"
    [ -s "${nvm_completion}" ] && . "${nvm_completion}"

    # these are required to connect with cx_Oracle
    export TNS_ADMIN="/usr/local/lib/oracle"
    export ORACLE_HOME="${TNS_ADMIN}/client"
    export LD_LIBRARY_PATH="${ORACLE_HOME}:${LD_LIBRARY_PATH}"
    export DYLD_LIBRARY_PATH="${ORACLE_HOME}:${DYLD_LIBRARY_PATH}"
# Ubuntu
elif [[ "${OSTYPE}" == 'linux-gnu' ]]; then
    export NVM_DIR="$HOME/.nvm"

    # load nvm and its bash completion
    [ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"
    [ -s "${NVM_DIR}/bash_completion" ] && \. "${NVM_DIR}/bash_completion"

    # setup connection to Oracle database
    ORACLE_BASE="${HOME}/opt/oracle"
    if [ -d "${ORACLE_BASE}" ]; then
        # the active version of instant client, which has the version number
        # in its folder name, should be symlinked to $ORACLE_HOME
        export ORACLE_HOME="${ORACLE_BASE}/instant_client"
        export LD_LIBRARY_PATH="${ORACLE_HOME}:${LD_LIBRARY_PATH}"
        export TNS_ADMIN="${ORACLE_BASE}/oracle_client_config"
        add_to_path "${ORACLE_HOME}"
    fi
fi

PYENV_ROOT="$HOME/.pyenv"
if [ -d "${PYENV_ROOT}" ]; then
    export PYENV_ROOT
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

# Sencha Cmd
add_to_path "${HOME}/bin/Sencha/Cmd"

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
