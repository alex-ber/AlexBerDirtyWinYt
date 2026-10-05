@echo off
:: [EMET_LOCK]: High-Fidelity Video Fetcher

REM Set the working directory to the script's location
cd /d "%~dp0" || exit /b 1

echo [SYSTEM]: Initiating Video Stream Capture...

@if not exist "app" cd ..

REM NOTE: Running a .bat from another .bat without CALL transfers control permanently.
REM To make the script return and print the final message,
REM we need to run the command using call.

call app\yt.bat ^
  --js-runtimes deno ^
  --verbose ^
  --cookies "cookies.txt" ^
  --batch-file "./download.txt" ^
  --output "%%(title)s.%%(ext)s" ^
  --ignore-errors ^
  --no-check-certificates ^
  --no-playlist ^
  --format "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"

echo [ACK]: Video stream successfully materialized.
