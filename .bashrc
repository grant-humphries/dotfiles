#----------------------------------------------------------------------
# Aliases
#----------------------------------------------------------------------

alias la='ls -a'
alias ll='ls -l'
alias lal='ls -al'

# encourage good javascript habits
alias node='node --use_strict'

# windows/cygwin specific
if [[ "${OSTYPE}" == 'cygwin' || "${OSTYPE}" == 'msys' ]]; then
    # these aliases are in place to counter the interactive python bug
    # that exists in msys2, detailed here:
    # http://stackoverflow.com/questions/32597209
    alias python='winpty python'
    alias pip='winpty pip'
    alias node='winpty node --use_strict'

    # alias ArcGIS's version of python and supporting executables
    arcpy_dir='/c/Python27/ArcGIS10.4'
    alias arcpython="winpty ${arcpy_dir}/python"
    alias arcbuildout="${arcpy_dir}/Scripts/buildout"
    alias arcpip="winpty ${arcpy_dir}/Scripts/pip"
fi

#----------------------------------------------------------------------
# Colors
#----------------------------------------------------------------------

# mac os x specific
if [[ "${OSTYPE}" =~ 'darwin' ]]; then
    # enable colors in terminal and set 'ls' colors
    export CLICOLOR=1
    export LSCOLORS=ExFxBxDxCxegedabagacad

    # this determines format of the prompt and title in the shell
    export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
fi

#BABUN_PS1="\[\033[00;34m\]{ \[\033[01;34m\]\W \[\033[00;34m\]}\[\033[01;32m\] \$( git rev-parse --abbrev-ref HEAD 2> /dev/null || echo "" ) \[\033[01;31m\]» \[\033[00m\]"

#----------------------------------------------------------------------
# Environment Variables
#----------------------------------------------------------------------

# windows/cygwin specific
if [[ "${OSTYPE}" == 'cygwin' ]]; then
    # by default this variable is set to a directory that doesn't have
    # adequate permissions, it is a temporary directory where setuptools
    # unzips eggs
    export PYTHON_EGG_CACHE='/tmp/python_eggs'
    mkdir -p "${PYTHON_EGG_CACHE}"
fi

if [[ "${OSTYPE}" =~ 'darwin' ]]; then
    # these variables aren't set by default in mac os x
    export TMP='/tmp'
    export TEMP='/tmp'
fi

#----------------------------------------------------------------------
# Functions
#----------------------------------------------------------------------

# usage: extends functionality of cd to go up additional directory
# levels when further '.' characters are provided so 'cd ...' moves up
# two levels, etc.
cd() {
    cmd="${@}"

    if [[ "${@}" =~ ^\.{3,}$ ]]; then
        cmd=''
        levels="${#1}"

        for (( i=1; i < "${levels}"; i++ )); do
            cmd="${cmd}../"
        done
    fi

    builtin cd "${cmd}"
}

# print each file path in the PATH environment variable on separate line
path() {
    echo "${PATH//:/$'\n'}"
}

#----------------------------------------------------------------------
# Path Adjustments
#----------------------------------------------------------------------

# local compilations
if [ -d "${HOME}/bin" ]; then
    PATH="${HOME}/bin:${PATH}"
fi

# Ruby version manager
if [ -d "${HOME}/.rvm/bin" ]; then
    PATH="${PATH}:${HOME}/.rvm/bin"
fi

#----------------------------------------------------------------------
# Settings
#----------------------------------------------------------------------

# History (tips via: http://unix.stackexchange.com/questions/1288)
# eliminate duplicates
export HISTCONTROL=ignoredups:erasedups

# number of lines to loaded in memory and kept in the .bash_history
# file, respectively
export HISTSIZE=1000
export HISTFILESIZE=5000

# when shell exists, append history instead of overwriting it
shopt -s histappend

# make globbing case insensitive
shopt -s nocaseglob
