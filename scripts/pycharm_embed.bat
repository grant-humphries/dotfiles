@echo off
setlocal enableDelayedExpansion

:: note that I don't use the default install dir for babun
set install_dir=C:

:: cygwin's /etc/profile listens for the CHERE_INVOKING environment
:: variable and will *not* cd in the home directory if it is set
:: info here: http://conemu.github.io/en/CygwinStartDir.html
set CHERE_INVOKING=1

:: pycharm launches bash as a login shell by default so adding --login
:: will load config files twice, this has the effect of nullifying the
:: CHERE_INVOKING variable
set babun_bash=!install_dir!\.babun\cygwin\bin\bash
!babun_bash! -i
