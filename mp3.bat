@echo off
:: [EMET_LOCK]: High-Fidelity Audio Extractor (Native Format)

REM Set the working directory to the script's location
cd /d "%~dp0" || exit /b 1

echo [SYSTEM]: Initiating Audio Stream Extraction (Native Format)...

REM NOTE: Running a .bat from another .bat without CALL transfers control permanently.
REM To make the script return and print the final message,
REM we need to run the command using call.

call app\yt.bat ^
  --js-runtimes deno ^
  --verbose ^
  --cookies "cookies.txt" ^
  --batch-file "download.txt" ^
  --output "./%%(title)s.%%(ext)s" ^
  --ignore-errors ^
  --no-playlist ^
  --no-check-certificates ^
  --extract-audio
:: --audio-format "mp3" ^      :: Skipped to save CPU cycles and preserve original quality
:: --audio-quality 0

echo [ACK]: Audio phase successfully extracted.
