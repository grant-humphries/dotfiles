# dotfiles

Configuration files for Linux applications an shell tooling.

## Installation

- Run the script `./scripts/install-dotfiles` in a Bash shell
- Copy `.gitconfig.local` file to home directory (this file can't be kept under
  version control due to sensitive contents)
- If not already installed, via package manager add:
  - `bash-completion`
  - `pidof`

## Updating Git completion

This repo contains Git completion and prompt scripts that are installed as part
of the installation step. They should be updated periodically to keep them in
sync with the installed version of Git.

To update them, run:

```bash
./scripts/update-git-scripts.sh
```

Then commit and push the update files

## Resources

- https://github.com/johnzimm/dotfiles
- https://dotfiles.github.io/
