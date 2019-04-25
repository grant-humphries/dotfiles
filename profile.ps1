# Installation
# Default PowerShell:
# cmd /c mklink $profile <absolute-path-to-this-file>
# Cmder:
# cmd /c mklink $env:CMDER_ROOT/config/user_profile.ps1 <absolute-path-to-this-file>


# Environment Variables
$env:HOME = (Resolve-Path ~)
$env:PATH += ";$env:ProgramFiles\git\cmd"

# Module Imports

$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}

Import-Module PSReadline
Import-Module posh-git


# Functions

# wrapper for cmd's `mklink` executable
function mklink {
    cmd /c mklink $args
}

# create symlinks with PowerShell syntax
function Make-Link ($target, $source) {
    New-Item -Path $source -ItemType SymbolicLink -Value $target
}

# enable bash style completion
Set-PSReadlineKeyHandler -Key Tab -Function Complete

# start ssh-agent: https://stackoverflow.com/a/34640053/2167004
Set-Alias ssh-agent "$env:ProgramFiles\git\usr\bin\ssh-agent.exe"
Set-Alias ssh-add "$env:ProgramFiles\git\usr\bin\ssh-add.exe"
Start-SshAgent -Quiet

# start in home directory
cd ~
