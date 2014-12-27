@setlocal
@set TMPEXE=imageviewer.exe
@if EXIST %TMPEXE% goto GOTEXE
@set TMPEXE=Release\imageviewer.exe
@if NOT EXIST %TMPEXE% goto NOEXE
:GOTEXE
@set TMPDIR=C:\Qt\4.8.6\bin
@if NOT EXIST %TMPDIR%\nul goto NODIR

@set TMPCMD=
:RPT
@if "%~1x" == "x" goto GOTCMD
@set TMPCMD=%1
@if NOT EXIST %TMPCMD% goto NOFIL
@shift
@if "%~1x" == "x" goto GOTCMD
@echo Already have file %TMPCMD%
@goto Only 1 file name argument allowed...
@goto END

:GOTCMD

@call setupqt64

@set PATH=%TMPDIR%;%PATH%

%TMPEXE% %TMPCMD%

@goto END

:NOEXE
@echo Can NOT file %TMPEXE%! *** FIX ME ***
@goto END

:NODIR
@echo Can NOT fine dir %TMPDIR%! ** FIX ME ***
@goto END

:END
