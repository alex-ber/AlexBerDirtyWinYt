@echo off

cd /D "%~dp0" || exit /b 1
set "TARGET_DIR=%CD%"

set "TEMP_DIR=%TARGET_DIR%\.tmp_pot_build"
set "POT_PROVIDER_HOME=%USERPROFILE%\bgutil-ytdlp-pot-provider"
set "PLUGIN_DIR=%TARGET_DIR%\app\yt-dlp-plugins"

:: 1. Fetch the latest release tag name from GitHub API
for /f "delims=" %%i in ('powershell -NoProfile -Command "(Invoke-RestMethod -Uri 'https://api.github.com/repos/Brainicism/bgutil-ytdlp-pot-provider/releases/latest').tag_name"') do set "LATEST_TAG=%%i"
if "%LATEST_TAG%"=="" exit /b 1

echo [INFO] Installing/updating bgutil-ytdlp-pot-provider to version: %LATEST_TAG%

:: 2. Prepare temporary build directory
if exist "%TEMP_DIR%" rmdir /s /q "%TEMP_DIR%"
mkdir "%TEMP_DIR%" || exit /b 1

:: 3. Clone the FULL repository
git clone --single-branch --branch "%LATEST_TAG%" https://github.com/Brainicism/bgutil-ytdlp-pot-provider.git "%TEMP_DIR%\bgutil-ytdlp-pot-provider" || exit /b 1

:: 4. Enter the server directory and install dependencies using app\deno.exe
cd /D "%TEMP_DIR%\bgutil-ytdlp-pot-provider\server" || exit /b 1
"%TARGET_DIR%\app\deno.exe" install --allow-scripts=npm:canvas --frozen || exit /b 1

:: 5. Return to TARGET_DIR before moving or deleting anything
cd /D "%TARGET_DIR%" || exit /b 1

:: 6. Move the full repo to USERPROFILE and clean up TEMP_DIR
if exist "%POT_PROVIDER_HOME%" rmdir /s /q "%POT_PROVIDER_HOME%"
robocopy "%TEMP_DIR%\bgutil-ytdlp-pot-provider" "%POT_PROVIDER_HOME%" /E /MOVE /NFL /NDL /NJH /NJS >nul
if exist "%TEMP_DIR%" rmdir /s /q "%TEMP_DIR%"

:: 7. Copy the plugin into app\yt-dlp-plugins\
if not exist "%PLUGIN_DIR%" mkdir "%PLUGIN_DIR%"
if exist "%PLUGIN_DIR%\bgutil-ytdlp-pot-provider" rmdir /s /q "%PLUGIN_DIR%\bgutil-ytdlp-pot-provider"
xcopy "%POT_PROVIDER_HOME%\plugin" "%PLUGIN_DIR%\bgutil-ytdlp-pot-provider\" /E /I /Q /Y >nul

echo [SUCCESS] Setup complete!