@setlocal
@set TMPPRJ=imageviewer
@REM imageviewer - Uses Qt4 64-bits, but should also compile in 32-bits
@set TMPLOG=bldlog-1.txt
@set DOTINST=0
@set DOINSTALL=0
@set DOINSTREL=1
@set BLDDIR=%CD%
@set SET_BAT="%ProgramFiles(x86)%\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"
@if NOT EXIST "%SET_BAT%" goto NOBAT

@echo Doing build output to %TMPLOG%
@echo Doing build output to %TMPLOG% > %TMPLOG%
@echo Doing: 'call %SET_BAT% AMD64'
@echo Doing: 'call %SET_BAT% AMD64' >> %TMPLOG%
@call %SET_BAT% AMD64 >> %TMPLOG% 2>&1
@if ERRORLEVEL 1 goto ERR0

@call setupqt64
@cd %BLDDIR%

@set TMPDIR=F:
@set TMPRT=%TMPDIR%\Projects\Qt
@set TMPVER=1
@set TMPSRC=%TMPRT%\%TMPPRJ%
@set TMPBGN=%TIME%
@REM set TMPINS=%TMPRT%\3rdParty
@set TMPINS=C:\MDOS
@set TMPCM=%TMPSRC%\CMakeLists.txt
@set DOPAUSE=pause

@call chkmsvc %TMPPRJ% 

@if EXIST build-cmake.bat (
@call build-cmake
)

@if NOT EXIST %TMPCM% goto NOCM

@set TMPOPTS=-DCMAKE_INSTALL_PREFIX=%TMPINS% -G "Visual Studio 10 Win64"
:RPT
@if "%~1x" == "x" goto GOTCMD
@set TMPOPTS=%TMPOPTS% %1
@shift
@goto RPT
:GOTCMD

@echo Build start %DATE% %TIME% >> %TMPLOG%
@echo Doing: 'cmake %TMPSRC% %TMPOPTS%'
@echo Doing: cmake %TMPSRC% %TMPOPTS% >> %TMPLOG% 2>&1
@cmake %TMPSRC% %TMPOPTS% >> %TMPLOG% 2>&1
@if ERRORLEVEL 1 goto ERR1

@echo Doing: 'cmake --build . --config Debug' >> %TMPLOG% 2>&1
@echo Doing: 'cmake --build . --config Debug'
cmake --build . --config Debug >> %TMPLOG% 2>&1
@if ERRORLEVEL 1 goto ERR2

@echo Doing: 'cmake --build . --config Release'
@echo Doing: 'cmake --build . --config Release' >> %TMPLOG% 2>&1
cmake --build . --config Release >> %TMPLOG% 2>&1
@if ERRORLEVEL 1 goto ERR3
:DONEREL

@REM fa4 "***" %TMPLOG%
@call elapsed %TMPBGN%
@echo Appears a successful build... see %TMPLOG%

@if "%DOTINST%x" == "0x" (
@echo Skipping 'temp' install for now...
@goto DNTINST
)

@echo Building installation zips... moment...
@REM If paths given as ${CMAKE_INSTALL_PREFIX}
@call build-zipsf Debug
@call build-zipsf Release
@REM If full paths used in install
@REM call build-zipsf2 Debug
@REM call build-zipsf2 Release
@echo Done installation zips...
:DNTINST

@echo NO install of this project...
@goto END

@if %DOINSTREL% EQU 1 (
@echo Continue with install? Only Ctrl+c aborts...
@%DOPAUSE%
@goto DOINSREL
)

@if "%DOINSTALL%x" == "0x" (
@echo Skipping install for now...
@goto END
)
@echo Continue with install? Only Ctrl+c aborts...
@%DOPAUSE%

cmake --build . --config Debug  --target INSTALL >> %TMPLOG% 2>&1
@if EXIST install_manifest.txt (
@copy install_manifest.txt install_manifest_dbg.txt >nul
@echo. >> %TMPINS%\installed.txt
@echo %TMPPRJ% Debug install %DATE% %TIME% >> %TMPINS%\installed.txt
@type install_manifest.txt >> %TMPINS%\installed.txt
)

:DOINSREL

@echo Doing: 'cmake --build . --config Release  --target INSTALL'
cmake --build . --config Release  --target INSTALL >> %TMPLOG% 2>&1
@if EXIST install_manifest.txt (
@copy install_manifest.txt install_manifest_rel.txt >nul
@echo. >> %TMPINS%\installed.txt
@echo %TMPPRJ% Release install %DATE% %TIME% >> %TMPINS%\installed.txt
@type install_manifest.txt >> %TMPINS%\installed.txt
@type install_manifest.txt
)

@call elapsed %TMPBGN%
@echo All done... see %TMPLOG%

@goto END

:NOBAT
@echo Can NOT locate MSVC setup batch "%SET_BAT%"! *** FIX ME ***
@goto ISERR

:NOCM
@echo Error: Can NOT locate %TMPCM%
@goto ISERR

:ERR0
@echo Appears running MSVC setup FAILED!
@echo Check %SET_BAT%
@goto ISERR

:ERR1
@echo cmake configuration or generations ERROR
@goto ISERR

:ERR2
@echo ERROR: Cmake build Debug FAILED!
@goto ISERR

:ERR3
@fa4 "mt.exe : general error c101008d:" %TMPLOG% >nul
@if ERRORLEVEL 1 goto ERR33
:ERR34
@echo ERROR: Cmake build Release FAILED!
@goto ISERR
:ERR33
@echo Try again due to this STUPID STUPID STUPID error
@echo Try again due to this STUPID STUPID STUPID error >>%TMPLOG%
cmake --build . --config Release >> %TMPLOG% 2>&1
@if ERRORLEVEL 1 goto ERR34
@goto DONEREL

:ISERR
@echo See %TMPLOG% for details...
@endlocal
@exit /b 1

:END
@endlocal
@exit /b 0

@REM eof
