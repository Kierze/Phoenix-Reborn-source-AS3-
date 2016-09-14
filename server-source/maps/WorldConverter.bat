@echo off
cls
color 0D

:start
echo -----------------------------------
echo - Option 1 - Compile JM File      -
echo -----------------------------------
echo - Option 9 - Exit Program         -
echo -----------------------------------
set /p choice=Your Option: 

:compile
echo Type "quit command" (without quotation) to stop compiling files
set /p jm="Enter map name: "
if '%jm%'=='quit command' goto exit

echo.
..\bin\Debug\Json2Wmap %jm%.jm %jm%.wmap
echo Compiled map!
move %jm%.wmap wmaps >NUL
echo Moved Map to wmaps Folder!
echo.
goto check

:check
if '%choice%'=='1' goto compile
if '%choice%'=='9' goto exit

:exit
exit