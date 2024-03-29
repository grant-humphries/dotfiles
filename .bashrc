#----------------------------------------------------------------------
# Aliases
#----------------------------------------------------------------------

# -h returns human readable file sizes
alias la='ls -a'
alias lal='ls -ahl'
alias ll='ls -hl'
alias lsd='ls -d */'  # list directories only

# encourage good javascript habits
alias node='node --use_strict'

if [[ "${OSTYPE}" == 'cygwin' ]]; then
    # create aliases that allows access to cygwin python tools as
    # miniconda is used as primary python
    alias cyg-python='/usr/bin/python3.9'
    alias cyg-pip='/usr/bin/pip3.9'

    # launch new, child cygwin terminal
    alias cyg-term='cygstart mintty bash -il'
fi

if [[ "${OSTYPE}" == 'cygwin' || "${OSTYPE}" == 'msys' ]]; then
    # some interactive Windows executables don't function properly in
    # cygwin terminals like MinTTY, running them with `winpty` resolves
    # this problem and they are aliased here to always run in that manner

    # more info:
    # https://stackoverflow.com/questions/3250749
    # https://github.com/rprichard/winpty/blob/master/README.md

    declare -a winpty_programs=(
        'node'
        'pip'
        'python'
        'sencha'
    )

    for name in "${winpty_programs[@]}"; do
        alias ${name}="winpty ${name}.exe"
    done

    # add tab completion for executables with `winpty`
    complete -c winpty
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
    export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
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
# Completion
#----------------------------------------------------------------------

# Resources for writing a completion script:
# https://debian-administration.org/article/317/An_introduction_to_bash_completion_part_2
# https://unix.stackexchange.com/a/36563/192229

_cd_dot_expansion() {
    # Extends completion functionality of cd to expand three or more consecutive
    # dots to notation that moves up multiple directories; for instance typing
    # `.../<TAB>` will be completed to `../../` and list all of the directories
    # two levels up

    local path="${COMP_WORDS[COMP_CWORD]}"

    if [[ "${path}" =~ ^\.{3,} ]]; then
        local dots="${BASH_REMATCH}"
        local levels="${#dots}"
        local tail="${path##*...}"
        local expanded_dots='..'

        # the loop starts at two because the first set of dots is
        # assigned to `expanded_dots` when it is initialized
        for (( i = 2; i < "${levels}"; i++ )); do
            expanded_dots+='/..'
        done

        path="${expanded_dots}${tail}"
        COMPREPLY=( $( compgen -A file "${path}" ) )

        return
    fi

    _cd
}

complete -o nospace -F _cd_dot_expansion cd

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

clear_buildout() {
    # delete all buildout generated files within a project

    local target_dir="${1:-.}"

    if [ ! -f "${target_dir}/buildout.cfg" ]; then
        echo "buildout.cfg not found, this file must exist in the target directory"
        return 1
    fi

    local buildout_items=(
        '*.egg-info'
        '.installed.cfg'
        '.mr.developer.cfg'
        'bin/'
        'eggs/'
        'develop-eggs/'
        'parts/'
        'src-develop-eggs/'
    )

    for i in "${buildout_items[@]}"; do
        # the `i` variable must *not* be quoted for wildcards to work with rm
        rm -rf "${target_dir}"/${i}
    done
}

find_permitted() {
    # filter out `find` results for files that that can't be accessed
    # https://unix.stackexchange.com/a/42842/192229

    find "${@}" 2>&1 | grep -v 'Permission denied'
}

flat_dos2unix() {
    # run dos2unix on the files in the pwd only
    recursive_dos2unix ./ -maxdepth 1
}

launch_ssh_agent() {
    # start ssh agent so passphrase doesn't have to be repeatedly
    # entered, the condition here keeps additional instances of the
    # ssh-agent from being created when child login shell are launched

    local sock_link="${HOME}/.ssh/ssh_auth_sock"
    local agent_pid=$( pidof ssh-agent )

    if [[ ! -S "${sock_link}" || -z "${agent_pid}" ]]; then
        # get rid of old ssh-agent files
        rm -rf /tmp/ssh-*

        eval $( ssh-agent -s )
        ln -fs "${SSH_AUTH_SOCK}" "${sock_link}"
    elif [ -z "${SSH_AGENT_PID}" ]; then
        export SSH_AGENT_PID="${agent_pid}"
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


path() {
    # print each file path in the PATH environment variable on separate line
    echo "${PATH//:/$'\n'}"
}

recursive_dos2unix() {
    # derived from https://stackoverflow.com/a/7068241/2167004
    find "${@:-./}" -type f -exec dos2unix {} \;
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

# append in memory history to .bash_history after each command
PROMPT_COMMAND="history -a; ${PROMPT_COMMAND}"

# when shell exits, append history instead of overwriting it
shopt -s histappend

# make globbing case insensitive
shopt -s nocaseglob

# check the window size after each command  and adustments for wrapping
shopt -s checkwinsize

if [[ "${OSTYPE}" == 'cygwin' ]]; then
    # ignore carriage returns in line endings
    set -o igncr
fi
