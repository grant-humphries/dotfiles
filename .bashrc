#----------------------------------------------------------------------
# Aliases
#----------------------------------------------------------------------

# -h returns human readable file sizes
alias la='ls -a'
alias ll='ls -hl'
alias lal='ls -ahl'

# encourage good javascript habits
alias node='node --use_strict'

if [[ "${OSTYPE}" == 'cygwin' ]]; then
    # cygwin python is alias to give access to it since miniconda is my
    # main python on windows
    alias cygpython='/usr/bin/python2.7'
    alias cygpip='/usr/bin/pip'
    alias cygeasy_install='/usr/bin/easy_install-2.7'

    # launch new, child cygwin terminal
    alias cygterm='cygstart mintty bash -il'
fi

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
    CLICOLOR=1
    LSCOLORS=ExFxBxDxCxegedabagacad
fi

#----------------------------------------------------------------------
# Prompt
#----------------------------------------------------------------------

# enable git autocompletion and access to the __git_ps1 function
source "${HOME}/.git-completion.bash"
source "${HOME}/.git-prompt.sh"

# see .git-prompt.sh in this repo for explanation of these
GIT_PS1_SHOWDIRTYSTATE='true'
GIT_PS1_SHOWSTASHSTATE='true'

lightning_bolt='⚡'
PS1="${cyan_brt}\u${reset}@${blue}\h${reset}:\n${cyan}\w${magenta} \$(__git_ps1 '(%s)') ${red_brt}~> ${reset}"
BABUN_PS1="${blue}{ ${blue_brt}\W ${blue}} ${green_brt}\$(__git_ps1 '(%s)') ${red_brt}» ${reset}"

#----------------------------------------------------------------------
# Functions
#----------------------------------------------------------------------

add_to_path() {
    # supply a second parameter to have the add the new directory to
    # the back rather than the front of the path
    local add_dir="${1}"
    local append="${2:-front}"

    # only add if directory exists and is not already in path
    if [[ -d "${add_dir}" && ! "${PATH}" =~ (^|:)${add_dir}(:|$) ]]; then
        if [ "${append}" == 'front' ]; then
            export PATH="${add_dir}:${PATH}"
        else
            export PATH="${PATH}:${add_dir}"
        fi
    fi
}

# usage: extends functionality of cd to go up additional directory
# levels when further '.' characters are provided so 'cd ...' moves up
# two levels, etc.
cd() {
    # TODO: figure out how to make 3+ dots work with autocomplete

    local args="${@:1:${#}-1}"
    local path="${@: -1}"

    if [[ "${path}" =~ ^\.{3,} ]]; then
        local dots="${BASH_REMATCH}"
        local tail="${path##*...}"
        local levels="${#dots}"

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

# start ssh agent so passphrase doesn't have to be repeatedly entered,
# the condition here keeps additional instances of the ssh-agent from
# being created when child login shell are launched
launch_ssh_agent() {
    local sock_link="${HOME}/.ssh/ssh_auth_sock"

    if [ ! -S "${sock_link}" ]; then
        eval $( ssh-agent -s )
        ln -fs "${SSH_AUTH_SOCK}" "${sock_link}"
    else
        export SSH_AGENT_PID=$( pidof ssh-agent )
    fi

    export SSH_AUTH_SOCK="${sock_link}"

    # if no identities are represented prompt the user to add one
    ssh-add -l &> '/dev/null' || ssh-add
}

move_in_path() {
    # moves any items in PATH that contain the string provided in the
    # first parameter to the front of PATH, if a second parameter is
    # supplied it moves them to them back of PATH instead

    local match_str="${1}"
    local append="${2:-front}"
    local default_IFS="${IFS}"
    local match_path=''
    local other_path=''

    # temporarily change IFS to a colon so the items in PATH can be
    # iterated over
    IFS=':'

    # note that if PATH is quoted here iteration won't work
    for p in ${PATH}; do
        if [[ "${p}" =~ "${match_str}" ]]; then
            match_path+="${p}:"
        else
            other_path+="${p}:"
        fi
    done

    if [ "${append}" == 'front' ]; then
        PATH="${match_path}${other_path%:}"
    else
        PATH="${other_path}${match_path%:}"
    fi

    IFS="${default_IFS}"
    export PATH
}

# print each file path in the PATH environment variable on separate line
path() {
    echo "${PATH//:/$'\n'}"
}

#----------------------------------------------------------------------
# Settings
#----------------------------------------------------------------------

# History (tips via: http://unix.stackexchange.com/questions/1288)
# eliminate duplicates
HISTCONTROL=ignoredups:erasedups

# number of lines to loaded in memory and kept in the .bash_history
# file, respectively
HISTSIZE=1000
HISTFILESIZE=5000

# when shell exists, append history instead of overwriting it
shopt -s histappend

# make globbing case insensitive
shopt -s nocaseglob
