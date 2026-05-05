@if not exist "app" cd ..
@app\yt.bat ^
--batch-file "download.txt" ^
--output "downloaded\%%(title)s.%%(ext)s" ^
--ignore-errors ^
--no-check-certificates ^ 
--no-playlist ^
--format "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" ^
