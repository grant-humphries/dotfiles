#----------------------------------------------------------------------
# Aliases
#----------------------------------------------------------------------

# -h returns human readable file sizes
alias la='ls -a'
alias ll='ls -hl'
alias lal='ls -ahl'

# encourage good javascript habits
alias node='node --use_strict'

if [[ "${OSTYPE}" == 'cygwin' || "${OSTYPE}" == 'msys' ]]; then
    # windows specific - these aliases are in place to counter the
    # interactive python bug that exists in msys2, detailed here:
    # http://stackoverflow.com/questions/32597209
    alias node='winpty node --use_strict'
    alias python='winpty python'
    alias pip='winpty pip'
    alias sencha='winpty sencha'

    # alias ArcGIS's version of python and supporting executables
    arcpy_dir='/c/Python27/ArcGIS10.4'
    alias arcpython="winpty ${arcpy_dir}/python"
    alias arcbuildout="${arcpy_dir}/Scripts/buildout"
    alias arcpip="winpty ${arcpy_dir}/Scripts/pip"
elif [[ "${OSTYPE}" == 'linux-gnu' ]]; then
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias egrep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'
fi

#----------------------------------------------------------------------
# Colors
#----------------------------------------------------------------------

# quality guide of setting PSI colors
# https://www.digitalocean.com/community/tutorials/how-to-customize-your-bash-prompt-on-a-linux-vps
reset='\[\e[0m\]'

black='\[\e[0;30m\]'
red='\[\e[0;31m\]'
green='\[\e[0;32m\]'
yellow='\[\e[0;33m\]'
blue='\[\e[0;34m\]'
magenta='\[\e[0;35m\]'
cyan='\[\e[0;36m\]'
white='\[\e[0;37m\]'

# bright colors
black_brt='\[\e[1;30m\]'
red_brt='\[\e[1;31m\]'
green_brt='\[\e[1;32m\]'
yellow_brt='\[\e[1;33m\]'
blue_brt='\[\e[1;34m\]'
magenta_brt='\[\e[1;35m\]'
cyan_brt='\[\e[1;36m\]'
white_brt='\[\e[1;37m\]'

# mac os specific
if [[ "${OSTYPE}" =~ 'darwin' ]]; then
    # enable colors in terminal and set 'ls' colors
    export CLICOLOR=1
    export LSCOLORS=ExFxBxDxCxegedabagacad
fi

#----------------------------------------------------------------------
# Prompt
#----------------------------------------------------------------------

# enable git autocompletion and access to the __git_ps1 function
source "${HOME}/.git-completion.bash"
source "${HOME}/.git-prompt.sh"

# see .git-prompt.sh in this repo for explanation of these
export GIT_PS1_SHOWDIRTYSTATE='true'
export GIT_PS1_SHOWSTASHSTATE='true'

lighting_bolt='⚡'
export PS1="${cyan_brt}\u${reset}@${blue}\h${reset}:\n${cyan}\w${magenta} \$(__git_ps1 '(%s)') ${red_brt}~> ${reset}"
export BABUN_PS1="${blue}{ ${blue_brt}\W ${blue}} ${green_brt}\$(__git_ps1 '(%s)') ${red_brt}» ${reset}"

#----------------------------------------------------------------------
# Environment Variables
#----------------------------------------------------------------------

#
if [[ "${OSTYPE}" == 'cygwin' ]]; then
    # by default this variable is set to a
    # directory that doesn't have adequate permissions, it is a
    # temporary directory where setuptools unzips eggs
    export PYTHON_EGG_CACHE='/tmp/python_eggs'
    mkdir -p "${PYTHON_EGG_CACHE}"
elif [[ "${OSTYPE}" =~ 'darwin' ]]; then
    # these variables aren't set by default in mac os x
    export TMP='/tmp'
    export TEMP='/tmp'
elif [[ "${OSTYPE}" == 'linux-gnu' ]]; then
    # environment variables that will help python packages find the
    # c/c++ libraries that they rely upon
    # http://gis.stackexchange.com/questions/28966/
    export C_INCLUDE_PATH='/usr/include/gdal'
    export CPLUS_INCLUDE_PATH='/usr/include/gdal'
    export PROJ_DIR='/usr/share/proj'
fi

#----------------------------------------------------------------------
# Functions
#----------------------------------------------------------------------

# usage: extends functionality of cd to go up additional directory
# levels when further '.' characters are provided so 'cd ...' moves up
# two levels, etc.
cd() {
    # TODO: figure out how to make 3+ dots work with autocomplete

    args="${@:1:${#}-1}"
    path="${@: -1}"

    if [[ "${path}" =~ ^\.{3,} ]]; then
        dots="${BASH_REMATCH}"
        tail="${path##*...}"
        levels="${#dots}"

        # loop starts at two because the first set of dots is assigned
        # cmd when it is initialized
        path='..'
        for (( i = 2; i < "${levels}"; i++ )); do
            path="${path}/.."
        done

        path="${path}${tail}"
    fi

    builtin cd ${args} "${path}"
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
