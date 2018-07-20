@echo off
setlocal enableDelayedExpansion

:: get repo directory
for %%i in ("%~dp0..") do set "dotfiles_path=%%~fi"

:: symlink the ComEmu config file from the dotfiles repo and move the
:: original config file so it won't be read
cd "%ConEmuDir%"
mklink ".\.ConEmu.xml" "%dotfiles_path%\.ConEmu.xml"
move ".\ConEmu.xml" ".\ConEmu.xml.old"
