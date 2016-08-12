@echo off
setlocal enableDelayedExpansion

:: This script launches babun's bash in the directory that it is called
:: from then loads the .bashrc file in the home directory, not that
:: bash is not called as a login shell so it doesn't look for some 
:: config files

set CUR_PWD=!cd!
set BABUN_HOME=C:\.babun\cygwin
set USER_HOME=!BABUN_HOME!\home\humphrig

set etc_profile=!BABUN_HOME!\etc\profile
set bashrc=!USER_HOME!\.bashrc
set bash_login=!USER_HOME!\.bash_login
set profile=!USER_HOME!\.profile
set temp_bashrc=!TEMP!\.temp_bashrc
set bash=!BABUN_HOME!\bin\bash

:: create temp bashrc that changes the directory then takes the actions
:: that --login provides when lauching bash
:: https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html
:: the file is written this way to avoid line endings: cmd can only
:: write dos line endings and cygwin can't read those
echo | set /p=cd '!CUR_PWD!'; ^
    if [ -f !etc_profile! ]; then ^
        source !etc_profile!; ^
    fi; ^
    if [ -f !bashrc! ]; then ^
        source !bashrc!; ^
    elif [ -f !bash_login! ]; then ^
        source !bash_login!; ^
    elif [ -f !profile! ]; then ^
        source !profile!; ^
    fi > !temp_bashrc!

!bash! --rcfile !temp_bashrc! -i
