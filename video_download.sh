#!/bin/bash
#[EMET_LOCK]: High-Fidelity Video Fetcher

TARGET_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
cd "$TARGET_DIR" || exit 1

echo "[SYSTEM]: Initiating Video Stream Capture..."


yt-dlp \
  --js-runtimes deno \
  --verbose \
  --cookies "cookies.txt" \
  --batch-file "./download.txt" \
  --output "%(title)s.%(ext)s" \
  --ignore-errors \
  --no-check-certificates \
  --no-playlist \
  --format "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"

echo "[ACK]: Video stream successfully materialized."
