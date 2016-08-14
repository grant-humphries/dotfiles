#----------------------------------------------------------------------
# Aliases
#----------------------------------------------------------------------

alias la='ls -a'
alias ll='ls -a'
alias lal='ls -al'

# Windows specific

# these aliases are in place to counter the interactive python bug that exists
# in msys2, detailed here: http://stackoverflow.com/questions/32597209
#alias python='winpty python'
#alias pip='winpty pip'

# alias ArcGIS's version of python and supporting executables
arcpy_dir='/c/Python27/ArcGIS10.4'
alias arcpython="${arcpy_dir}/python"
alias arcbuildout="${arcpy_dir}/Scripts/buildout"
alias arcpip="${arcpy_dir}/Scripts/pip"

#----------------------------------------------------------------------
# Settings
#----------------------------------------------------------------------

# HISTORY
# tips via: http://unix.stackexchange.com/questions/1288

# avoid duplicates and set the number of lines to loaded into memory and kept
# in the .bash_history file
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=1000
export HISTFILESIZE=2000

# when shell exists, append history instead of overwriting it
shopt -s histappend

# save and reload history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; ${PROMPT_COMMAND}"


# make globbing case insensitive
shopt -s nocaseglob

#----------------------------------------------------------------------
# Functions
#----------------------------------------------------------------------

# usage: extends functionality of cd to go up additional directory levels
# when additional '.' are provided so 'cd ...' moves up two levels, etc.
cd() {
    if [[ "${1}" =~ \.{3,} ]]; then
        dots=''
        levels="${#1}"

        for (( i=1; i < "${levels}"; i++ )); do
            dots="${dots}../"
        done

        builtin cd "${dots}"
    else
        builtin cd "${@}"
    fi
}

