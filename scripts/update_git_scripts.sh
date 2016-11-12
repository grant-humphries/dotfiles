# see the comments in the files that this scripts downloads for
# information on what they do, also blog posts about this:
# http://code-worrier.com/blog/autocomplete-git/
# http://code-worrier.com/blog/git-branch-in-bash-prompt/

dotfiles_repo=$( cd $(dirname ${0}); dirname $(pwd -P) )
git_repo='https://raw.githubusercontent.com/git/git/master/contrib/completion'
completion='git-completion.bash'
prompt='git-prompt.sh'

wget -O "${dotfiles_repo}/.${completion}" "${git_repo}/${completion}"
wget -O "${dotfiles_repo}/.${prompt}" "${git_repo}/${prompt}"
