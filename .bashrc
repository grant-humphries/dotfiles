#----------------------------------------------------------------------
# Aliases
#----------------------------------------------------------------------

alias la='ls -a'
alias ll='ls -l'
alias lal='ls -al'

# encourage good javascript habits
alias node='node --use_strict'

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

# History (via: http://unix.stackexchange.com/questions/1288)
# eliminate duplicates and
export HISTCONTROL=ignoredups:erasedups

# number of lines to loaded in memory and kept in the .bash_history
# file, respectively
export HISTSIZE=1000
export HISTFILESIZE=5000

# when shell exists, append history instead of overwriting it
shopt -s histappend


# make globbing case insensitive
shopt -s nocaseglob

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
# Functions
#----------------------------------------------------------------------

# usage: extends functionality of cd to go up additional directory
# levels when further '.' characterss are provided so 'cd ...' moves up
# two levels, etc.
cd() {
    cmd="${@}"

    if [[ "${@}" =~ \.{3,} ]]; then
        cmd=''
        levels="${#1}"

        for (( i=1; i < "${levels}"; i++ )); do
            cmd="${cmd}../"
        done
    fi

    builtin cd "${cmd}"
}
