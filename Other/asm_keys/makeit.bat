@echo off
: -----------------------------------------
: assemble keys.asm into an OBJ file
: -----------------------------------------
\MASM32\BIN\Ml.exe /c /coff keys.asm
if errorlevel 1 goto errasm

: -----------------------
: link the main OBJ file
: -----------------------
\MASM32\BIN\Link.exe /SUBSYSTEM:CONSOLE keys.obj
if errorlevel 1 goto errlink

goto TheEnd

:errlink
: ----------------------------------------------------
: display message if there is an error during linking
: ----------------------------------------------------
echo.
echo There has been an error while linking "Keys".
echo.
goto TheEnd

:errasm
: -----------------------------------------------------
: display message if there is an error during assembly
: -----------------------------------------------------
echo.
echo There has been an error while assembling "Keys".
echo.
goto TheEnd

:TheEnd

pause
