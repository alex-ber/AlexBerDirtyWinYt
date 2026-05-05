@echo off

cd /D "%~dp0..\"

for /f "delims=" %%i in ('app\yt-dlp.exe --version') do set version=%%i
echo yt-dlp version %version%
echo yt-dlp may be updating (this can take a while)
for /f "delims=" %%i in ('app\yt-dlp.exe --update --no-check-certificate') do set status=%%i
echo %status%
echo.

app\yt-dlp.exe %*
echo.

echo Finished (you can now close this window)
pause >nul
