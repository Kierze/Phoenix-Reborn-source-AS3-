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
echo Type "quit" (without quotation) to stop compiling files
echo Destination folders: dungeons, friendly, misc, tower
set /p jm="Enter map name: "
if '%jm%'=='quit' goto exit

echo.
..\..\bin\Debug\Json2Wmap %jm%.jm %jm%.wmap
echo Compiled map!
set /p destination="Enter desination folder: "
move %jm%.wmap ..\..\wServer\realm\worlds\%destination% >NUL
echo Moved Map to %destination% Folder!
echo.
goto check

:check
if '%choice%'=='1' goto compile
if '%choice%'=='9' goto exit

:exit
exit