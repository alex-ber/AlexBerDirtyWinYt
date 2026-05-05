@if not exist "app" cd ..
@app\yt.bat ^
--batch-file "download.txt" ^
--output "downloaded\%%(title)s.%%(ext)s" ^
--ignore-errors ^
--no-playlist ^
--no-check-certificates  ^
--extract-audio ^
--audio-format "mp3" ^
--audio-quality 0 ^
