# dotfiles
Config files for unix applications

## Installation
* Run the script `./scripts/install_dotfiles` in a bash shell
* Via package manager install:
  * `bash-completion`
  * `pidof` (available in `procps-ng` package on `cygwin`)
* Copy `.gitconfig.local` file to home directory (this file can't be kept under
  version control due to sensitive contents)
* For cygwin only:
  * Run script `./scripts/install_cygwin_symlinks.sh`

## Resources
* https://github.com/johnzimm/dotfiles
* https://dotfiles.github.io/
