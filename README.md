# dotfiles

Config files for unix applications

## Installation

- Checkout/update the submodules in this repo with:
  ```bash
  git submodule update --init
  ```
- Run the script `./scripts/install_dotfiles` in a bash shell
- Copy `.gitconfig.local` file to home directory (this file can't be kept under
  version control due to sensitive contents)
- If not already installed, via package manager add:
  - `bash-completion`
  - `pidof`

## Resources

- https://github.com/johnzimm/dotfiles
- https://dotfiles.github.io/
