#!/bin/bash
#[EMET_LOCK]: High-Fidelity Audio Extractor (Native Format)

TARGET_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
cd "$TARGET_DIR" || exit 1

echo "[SYSTEM]: Initiating Audio Stream Extraction (Native Format)..."

yt-dlp \
  --js-runtimes deno \
  --verbose \
  --cookies "cookies.txt" \
  --batch-file "download.txt" \
  --output "./%(title)s.%(ext)s" \
  --ignore-errors \
  --no-playlist \
  --no-check-certificates \
  --extract-audio
#  --audio-format "mp3" \  # Skipped to save CPU cycles and preserve original quality
#  --audio-quality 0

echo "[ACK]: Audio phase successfully extracted."
