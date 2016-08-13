# ALIASES

# these aliases are in place to counter the interactive python bug that exists
# in msys2, detailed here: http://stackoverflow.com/questions/32597209
#alias python='winpty python'
#alias pip='winpty pip'

# alias ArcGIS's version of python and supporting executables
arcpy_dir='/c/Python27/ArcGIS10.4'
alias arcpython="${arcpy_dir}/python"
alias arcbuildout="${arcpy_dir}/Scripts/buildout"
alias arcpip="${arcpy_dir}/Scripts/pip"

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

# GLOBBING

# make globbing case insensitive
shopt -s nocaseglob

# FUNCTIONS

# usage: 'cdn .' moves up one directory, 'cdn ...' moves up three, etc.
cdn() {
    dots=''
    levels="${#1}"
    for (( i=0; i < "${levels}"; i++ )); do
        dots="${dots}../"
    done

    cd "${dots}"
}
