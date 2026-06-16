#!/bin/bash
#[EMET_LOCK]: High-Fidelity Audio Extractor

# Create buffer directory if it does not exist
mkdir -p downloaded

echo "[SYSTEM]: Initiating Audio Stream Extraction (MP3)..."

yt-dlp \
  --js-runtimes node \
  --batch-file "download.txt" \
  --output "downloaded/%(title)s.%(ext)s" \
  --ignore-errors \
  --no-playlist \
  --no-check-certificates \
  --extract-audio \
  --audio-format "mp3" \
  --audio-quality 0

echo "[ACK]: Audio phase successfully extracted."
