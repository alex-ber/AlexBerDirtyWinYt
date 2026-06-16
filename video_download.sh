#!/bin/bash
#[EMET_LOCK]: High-Fidelity Video Fetcher

# Create buffer directory if it does not exist
mkdir -p downloaded

echo "[SYSTEM]: Initiating Video Stream Capture..."

yt-dlp \
  --js-runtimes node \
  --batch-file "download.txt" \
  --output "downloaded/%(title)s.%(ext)s" \
  --ignore-errors \
  --no-check-certificates \
  --no-playlist \
  --format "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"

echo "[ACK]: Video stream successfully materialized."
