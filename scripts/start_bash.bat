@echo off

:: CHERE_INVOKING variable prevents the startup scripts from cd'ing
:: into $HOME
set CHERE_INVOKING=1 & "C:\cygwin64\bin\bash.exe" -il
