@echo off
setlocal enableDelayedExpansion

:: note that I don't use the default install dir for babun, this
:: should be the only variable that needs to be modified for others to
:: use this script
set install_dir=C:

:: cygwin's /etc/profile listens for the CHERE_INVOKING environment
:: variable and will *not* cd in the home directory if it is set
:: info here: http://conemu.github.io/en/CygwinStartDir.html
:: ***until babun stops sourcing /etc/profile for non login shells this
:: won't work: https://github.com/babun/babun/issues/166***
set CHERE_INVOKING=1

:: this provides the directory that the shell should start within
:: pycharm as well as a hook for any other pycharm specific
:: configuration that needs to be done
set PYCHARM_DIR=!cd!

:: pycharm launches bash as a login shell by default so adding --login
:: will load config files twice, this has the effect of nullifying the
:: CHERE_INVOKING variable
set babun_bash=!install_dir!\.babun\cygwin\bin\bash
!babun_bash! -il
