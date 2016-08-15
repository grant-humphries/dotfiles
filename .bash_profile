if [ -f "${HOME}/.bashrc" ]; then
    source "${HOME}/.bashrc"
fi

#----------------------------------------------------------------------
# RVM (Ruby Version Manager)
#----------------------------------------------------------------------

# Load RVM into a shell session *as a function*
[[ -s "${HOME}/.rvm/scripts/rvm" ]] && source "${HOME}/.rvm/scripts/rvm"
