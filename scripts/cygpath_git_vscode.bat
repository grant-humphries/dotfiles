@echo off

REM this script comes from the below gist:
REM https://gist.github.com/nickbudi/4b489f50086db805ea0f3864aa93a9f8

REM wrapper to convert linux paths to windows so vscode git integration
REM will work with cygwin "git.path"="C:\\this\\file.bat" in settings.json

setlocal
set PATH=C:\cygwin\bin;%PATH%

if "%1" equ "rev-parse" goto rev_parse
git %*
goto :eof
:rev_parse
for /f %%1 in ('git %*') do cygpath -w %%1
