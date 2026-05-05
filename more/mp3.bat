@if not exist "app" cd ..
@app\yt.bat ^
--batch-file "download.txt" ^
--output "downloaded\%%(title)s.%%(ext)s" ^
--ignore-errors ^
--no-playlist ^
--extract-audio ^
--audio-format "mp3" ^
--audio-quality 0 ^
