#----------------------------------------------------------------------
# Aliases
#----------------------------------------------------------------------

# -h returns human readable file sizes
alias la='ls -a'
alias ll='ls -hl'
alias lal='ls -ahl'

# encourage good javascript habits
alias node='node --use_strict'

# windows/cygwin specific
if [[ "${OSTYPE}" == 'cygwin' || "${OSTYPE}" == 'msys' ]]; then
    # these aliases are in place to counter the interactive python bug
    # that exists in msys2, detailed here:
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
fi

#----------------------------------------------------------------------
# Colors
#----------------------------------------------------------------------

# nice guide of setting PSI colors
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

gray='\[\e[1;30m\]'
pink='\[\e[1;31m\]'
lt_green='\[\e[1;32m\]'
lt_yellow='\[\e[1;33m\]'
lt_blue='\[\e[1;34m\]'
lt_magenta='\[\e[1;35m\]'
lt_cyan='\[\e[1;36m\]'
lt_gray='\[\e[1;37m\]'

export PS1="${black}abc${red}abc${green}abc${yellow}abc${blue}abc${magenta}abc${cyan}abc${white}abc${gray}abc${pink}abc${lt_green}abc${lt_yellow}abc${lt_blue}abc${lt_magenta}abc${lt_cyan}abc${lt_gray}abc"

# mac os x specific
if [[ "${OSTYPE}" =~ 'darwin' ]]; then
    # enable colors in terminal and set 'ls' colors
    export CLICOLOR=1
    export LSCOLORS=ExFxBxDxCxegedabagacad

    # this determines format of the prompt and title in the shell
#    export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h: \[\033[33;1m\]{ \w } \[\033[m\] $( git rev-parse --abbrev-ref HEAD 2> /dev/null || echo )  ~> "
#    export PS1="\[\033[00;34m\]{ \[\033[01;34m\]\W \[\033[00;34m\]}\[\033[01;32m\] $( git rev-parse --abbrev-ref HEAD 2> /dev/null || echo ) \[\033[01;31m\]» \[\033[00m\]"
#function color_my_prompt {
#    local end_color='\e[m'
#
#    local user='\u'
#    local host='\[\e[1;32m\]\h'
#    local path='\[\e[1;34m\]\w'
#    local git_branch_color='\[\033[31m\]'
#    local git_branch="$(git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /)"
#    local prompt_tail="\[\033[35m\]~>"
#    export PS1="${user}@${host}: ${path} (${git_branch}) ${prompt_tail} "
#}
#color_my_prompt
#
#fi

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
