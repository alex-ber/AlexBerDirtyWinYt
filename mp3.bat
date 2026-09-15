@echo off
REM [EMET_LOCK]: High-Fidelity Audio Extractor

REM Create buffer directory if it does not exist
if not exist "downloaded" mkdir "downloaded"

echo [SYSTEM]: Initiating Audio Stream Extraction (MP3)...

@if not exist "app" cd ..

REM NOTE: Running a .bat from another .bat without CALL transfers control permanently.
REM To make the script return and print the final message,
REM we need to run the command using call.

call app\yt.bat ^
  --js-runtimes deno ^
  --verbose ^
  --cookies "cookies.txt" ^
  --batch-file "download.txt" ^
  --output "downloaded\%%(title)s.%%(ext)s" ^
  --ignore-errors ^
  --no-playlist ^
  --no-check-certificates ^
  --extract-audio ^
  --audio-format "mp3" ^
  --audio-quality 0

echo [ACK]: Audio phase successfully extracted.
