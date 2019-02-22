set -e

# see the comments in the files that this scripts downloads for
# information on what they do; further info about this approach:
# https://stackoverflow.com/a/50919451/2167004

dotfiles_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )"; dirname "$( pwd -P )" )"
git_version=$(git --version | grep -Po '[0-9]+(\.[0-9]+)*')
git_repo="https://raw.githubusercontent.com/git/git/v${git_version}/contrib/completion"
completion='git-completion.bash'
prompt='git-prompt.sh'

wget -O "${dotfiles_dir}/.${completion}" "${git_repo}/${completion}"
wget -O "${dotfiles_dir}/.${prompt}" "${git_repo}/${prompt}"
