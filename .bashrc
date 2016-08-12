# environment variables that effect where files are put by default, where '~'
# maps to, and the starting directory on launch
export HOMEDRIVE='/c'
export HOMEPATH='/Users/humphrig'

# these aliases are in place to counter the interactive python bug that exists
# in msys2, detailed here: http://stackoverflow.com/questions/32597209
#alias python='winpty python'
#alias pip='winpty pip'

# alias ArcGIS's version of python and supporting executables
arcpy='/c/Python27/ArcGIS10.4'
alias arcpython="${arcpy}/python"
alias arcbuildout="${arcpy}/Scripts/buildout"
alias arcpip="${arcpy}/Scripts/pip"

# History Settings
# tips come from this thread: http://unix.stackexchange.com/questions/1288

# avoid duplicates and set the number of lines to loaded into memory and kept
# in the .bash_history file
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=1000
export HISTFILESIZE=2000

# when shell exists, append history instead of overwriting it
shopt -s histappend

# save and reload history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; ${PROMPT_COMMAND}"

