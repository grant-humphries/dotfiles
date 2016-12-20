# if bash profile has already been run don't run it again
[[ -z "${BASH_PROFILE_RUN}" ]] && BASH_PROFILE_RUN=1 || return

# load .bashrc, all functions used here come form there
[[ -r "${HOME}/.bashrc" ]] && source "${HOME}/.bashrc"

#----------------------------------------------------------------------
# Path Adjustments
#----------------------------------------------------------------------

# local compilations
add_to_path "${HOME}/bin"

# Ruby version manager
add_to_path "${HOME}/.rvm/bin"

# on windows miniconda python needs to be in front of cygwin python
[[ "${OSTYPE}" == 'cygwin' ]] && move_in_path 'Miniconda2'

# NOTE: in babun changes are also made to the path by the file
# /usr/local/etc/babun/source/babun-core/plugins/core/src/babun.rc
# these can be overridden in .babunrc

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
    # by default this variable is set to a
    # directory that doesn't have adequate permissions, it is a
    # temporary directory where setuptools unzips eggs
    export PYTHON_EGG_CACHE='/tmp/python_eggs'
    mkdir -p "${PYTHON_EGG_CACHE}"
elif [[ "${OSTYPE}" == 'linux-gnu' ]]; then
    # environment variables that will help python packages find the
    # c/c++ libraries that they rely upon
    # http://gis.stackexchange.com/questions/28966/
    export C_INCLUDE_PATH='/usr/include/gdal'
    export CPLUS_INCLUDE_PATH='/usr/include/gdal'

    # https://github.com/jswhit/pyproj/issues/97
    export PROJ_DIR='/usr'
fi

#----------------------------------------------------------------------
# SSH Config
#----------------------------------------------------------------------

# launch ssh agent if not ssh'ed into a remote host
if [ -z "${SSH_TTY}" ]; then
    launch_ssh_agent
fi

#----------------------------------------------------------------------
# RVM (Ruby Version Manager)
#----------------------------------------------------------------------

# Load RVM into a shell session *as a function*
[[ -s "${HOME}/.rvm/scripts/rvm" ]] && source "${HOME}/.rvm/scripts/rvm"
