@echo off
setlocal enabledelayedexpansion

echo =====================================================================
echo  DDR3 SpinalHDL Tang Primer 20K - 100%% Self-Contained Windows Setup
echo =====================================================================
echo.

set "SCRIPT_DIR=%~dp0"
set "TOOLS_DIR=%SCRIPT_DIR%tools"
set "MILL_BAT=%SCRIPT_DIR%mill.bat"
set "OSS_DIR=%TOOLS_DIR%\oss-cad-suite"
set "W64_DIR=%TOOLS_DIR%\w64devkit"

:: 1. Java environment status check
echo [1/4] Checking Java environment...
where.exe java.exe >nul 2>&1
if errorlevel 1 (
    echo [INFO] No system Java found in PATH.
    echo        Mill will automatically download and manage a JDK via Coursier.
) else (
    echo [OK] System Java detected.
)
echo.

:: 2. Verify mill.bat presence
echo [2/4] Checking Mill build tool...
if exist "%MILL_BAT%" (
    echo [OK] mill.bat is present in repository root.
) else (
    echo [INFO] mill.bat not found, downloading version 1.1.8...
    curl.exe -fLo "%MILL_BAT%" "https://repo1.maven.org/maven2/com/lihaoyi/mill-dist/1.1.8/mill-dist-1.1.8-mill.bat"
    if errorlevel 1 goto :error_mill
    echo [OK] mill.bat downloaded successfully.
)
echo.

:: 3. Setup oss-cad-suite
echo [3/4] Setting up oss-cad-suite - Icarus Verilog and Verilator...
if not exist "%TOOLS_DIR%" mkdir "%TOOLS_DIR%"

if exist "%OSS_DIR%\bin\iverilog.exe" (
    echo [OK] oss-cad-suite is already installed in tools\oss-cad-suite.
    goto :check_dlls
)

set "OSS_TGZ=%TOOLS_DIR%\oss-cad-suite-windows-x64.tgz"
echo Downloading oss-cad-suite Windows x64 package...
echo This download may take a few minutes depending on your network speed.
curl.exe -fLo "%OSS_TGZ%" "https://github.com/YosysHQ/oss-cad-suite-build/releases/download/2026-09-06/oss-cad-suite-windows-x64-20260906.tgz"
if errorlevel 1 goto :error_download

echo Unpacking oss-cad-suite into tools folder...
tar.exe -xzf "%OSS_TGZ%" -C "%TOOLS_DIR%"
if errorlevel 1 goto :error_unpack

echo Cleaning up temporary archive file...
del /f /q "%OSS_TGZ%"
echo [OK] oss-cad-suite installed successfully.

:: 4. Setup w64devkit (sh/make/gcc for Verilator C++ builds in unit tests)
echo [4/4] Setting up w64devkit - sh, make and gcc for Verilator...
if exist "%W64_DIR%\bin\sh.exe" (
    echo [OK] w64devkit is already installed in tools\w64devkit.
    goto :check_dlls
)

set "W64_SFX=%TOOLS_DIR%\w64devkit-x64-2.9.1.7z.exe"
echo Downloading w64devkit Windows x64 package...
curl.exe -fLo "%W64_SFX%" "https://github.com/skeeto/w64devkit/releases/download/v2.9.1/w64devkit-x64-2.9.1.7z.exe"
if errorlevel 1 goto :error_w64

echo Unpacking w64devkit into tools folder (silent)...
"%W64_SFX%" -o"%W64_DIR%" -y >nul
if errorlevel 1 goto :error_w64_unpack
:: The SFX nests everything one level deep (w64devkit\w64devkit): move it up.
if exist "%W64_DIR%\w64devkit\bin\sh.exe" (
    robocopy "%W64_DIR%\w64devkit" "%W64_DIR%" /E /MOVE /NFL /NDL /NJH /NJS >nul
    rmdir "%W64_DIR%\w64devkit" 2>nul
)

echo Cleaning up temporary archive file...
del /f /q "%W64_SFX%"
if not exist "%W64_DIR%\bin\sh.exe" goto :error_w64_unpack
echo [OK] w64devkit installed successfully.

:check_dlls
:: 5. Resolve Windows DLL dependencies for vvp.exe
if exist "%OSS_DIR%\lib\libreadline8.dll" (
    if not exist "%OSS_DIR%\bin\libreadline8.dll" (
        copy /y "%OSS_DIR%\lib\libreadline8.dll" "%OSS_DIR%\bin\" >nul
        echo [FIX] Copied libreadline8.dll to bin folder.
    )
)
if exist "%OSS_DIR%\lib\libtermcap-0.dll" (
    if not exist "%OSS_DIR%\bin\libtermcap-0.dll" (
        copy /y "%OSS_DIR%\lib\libtermcap-0.dll" "%OSS_DIR%\bin\" >nul
        echo [FIX] Copied libtermcap-0.dll to bin folder.
    )
)
echo [OK] Toolchain DLLs configured.
echo.

echo =====================================================================
echo  SETUP COMPLETED SUCCESSFULLY!
echo =====================================================================
echo.
echo Available commands from PowerShell or CMD:
echo   - Generate Verilog from SpinalHDL:
echo       .\mill.bat -i ddr3.runMain ddr3.Ddr3Gen
echo.
echo   - Run SpinalHDL unit tests:
echo       .\mill.bat -i ddr3.test
echo.
echo   - Run iverilog simulation for baseline nand2mario:
echo       python simulation/sim_ddr.py --baseline --run
echo.
echo   - Run iverilog simulation for SpinalHDL controller:
echo       python simulation/sim_ddr.py --spinal --run
echo.
echo   - Generate Gowin bitstream:
echo       python eda-flow.py --preset ddr3
echo.
exit /b 0

:error_mill
echo.
echo [ERROR] Failed to download mill.bat.
exit /b 1

:error_download
echo.
echo [ERROR] Failed to download oss-cad-suite archive.
exit /b 1

:error_unpack
echo.
echo [ERROR] Failed to unpack oss-cad-suite archive.
exit /b 1

:error_w64
echo.
echo [ERROR] Failed to download w64devkit archive.
exit /b 1

:error_w64_unpack
echo.
echo [ERROR] Failed to unpack w64devkit archive.
exit /b 1
