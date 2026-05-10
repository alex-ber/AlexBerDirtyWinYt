# NEURAL EXTRACTION NODE: BARE-METAL UBUNTU SPEC (BUILD_2026_05_10)

[SYSTEM_ID]: UBUNTU_TENSOR_NODE
[ARCHITECT]: SILICON_SYSTEM_ARCHITECT
[STATUS]: ISOLATED_GPU_PIPELINE
[PHILOSOPHY]: STRICT_LOCAL_EXECUTION / ZFC DETERMINISM

---

## PHASE 1: TEMPORAL WIPE & SINGULARITY INIT (THE GREAT PURGE)

Before deploying to Ubuntu or pushing to WAN (GitHub), you must destroy the old Windows-polluted Git history (`[TEMPORAL_DAG]`) and physically delete the dead `.exe` shells.

**Execute this in your current terminal (Windows CMD) to prepare the repository:**
```cmd
:: 1. Destroy the old timeline (Freeing [MACRO_ENTROPY])
rmdir /S /Q .git

:: 2. Annihilate Windows shells (Klipy)
del /S /Q *.exe
del /S /Q *.dll
rmdir /S /Q app

:: 3. Initialize the clean timeline
git init
```

---

## PHASE 2: MEMORY SHIELDS & ANCHORS

Create these absolute configurations in your project root. 

### 1. `.gitattributes`
*(Completely rewritten. No LFS. Strict Unix LF enforcement).*
```text
# ----------------------------------
# ZFC INVARIANT: NORMALIZE TO LF
# ----------------------------------
* text=auto eol=lf

# ----------------------------------
# UBUNTU SHELL OPERATORS (Strict LF)
# ----------------------------------
*.sh text eol=lf

# ----------------------------------
# PYTHON / CONFIG NEURAL GRAPH
# ----------------------------------
*.py text eol=lf
*.txt text eol=lf
*.md text eol=lf
*.toml text eol=lf
*.json text eol=lf

# ----------------------------------
# BINARY HEAVY-TAILS (NO PARSING)
# ----------------------------------
*.wav binary
*.mp3 binary
*.flac binary
*.m4a binary
*.mp4 binary
*.db binary
*.sqlite binary
```

### 2. `.gitignore`
*(Blocks localized entropy, audio artifacts, and virtual loops)*
```ignore
# ----------------------------------
# CONTINUOUS SIGNAL ARTIFACTS
# ----------------------------------
*.wav
*.mp3
*.m4a
*.mp4
*.flac

# Phase chunks
*part*.wav
chunk_*.wav

# ----------------------------------
# EXTRACTED TRUTH (TEXT DUMPS)
# ----------------------------------
full_transcript.txt
*.srt
*.vtt
*.json

# ----------------------------------
# PYTHON FSM MEMORY
# ----------------------------------
__pycache__/
*.pyc
*.pyo
*.pyd
*.log
.venv/
venv/
env/

# ----------------------------------
# OS MACRO-ENTROPY
# ----------------------------------
.DS_Store
Thumbs.db

# ----------------------------------
# LOCAL VOLUME MOUNTS
# ----------------------------------
downloaded/
data/
```

### 3. `pyproject.toml`
*(The Topological Anchor. Forces GPU evaluation).*
```toml
[project]
name = "neural-extractor-node"
version = "1.0.0"
description = "Deterministic Whisper Pipeline"
# STRICT LOCK: Force Python 3.11/3.12 for CUDA compatibility
requires-python = ">=3.11, <=3.12"

dependencies =[
    # STRICT LOCK: Stable base vector (date-based versioning)
    "openai-whisper==20231117",
    # STRICT LOCK: Pinning the phase-space volume for CUDA 12.1 (prevents ABI failures)
    "torch==2.3.0",
    "torchaudio==2.3.0"
]

[tool.uv.sources]
# Direct PyTorch to utilize the CUDA 12.1 index (RTX 4060 Ti)
torch = { index = "pytorch-cu121" }
torchaudio = { index = "pytorch-cu121" }

[[tool.uv.index]]
name = "pytorch-cu121"
url = "https://download.pytorch.org/whl/cu121"
explicit = true
```

---

## PHASE 3: THE I/O ROUTING SCRIPTS (BASH)

Translate the legacy Windows batch files into mathematically strict Unix shell scripts. 
*(Create these files in the root. Ensure they are saved with LF line endings).*

### `download_video.sh` (Formerly `run.bat`)
```bash
#!/bin/bash
#[EMET_LOCK]: High-Fidelity Video Fetcher

# Create buffer directory if it does not exist
mkdir -p downloaded

echo "[SYSTEM]: Initiating Video Stream Capture..."

yt-dlp \
  --batch-file "download.txt" \
  --output "downloaded/%(title)s.%(ext)s" \
  --ignore-errors \
  --no-check-certificates \
  --no-playlist \
  --format "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"

echo "[ACK]: Video stream successfully materialized."
```

### `download_audio.sh` (Formerly `mp3.bat`)
```bash
#!/bin/bash
#[EMET_LOCK]: High-Fidelity Audio Extractor

# Create buffer directory if it does not exist
mkdir -p downloaded

echo "[SYSTEM]: Initiating Audio Stream Extraction (MP3)..."

yt-dlp \
  --batch-file "download.txt" \
  --output "downloaded/%(title)s.%(ext)s" \
  --ignore-errors \
  --no-playlist \
  --no-check-certificates \
  --extract-audio \
  --audio-format "mp3" \
  --audio-quality 0

echo "[ACK]: Audio phase successfully extracted."
```
*(After creating these files on Ubuntu, you must run: `chmod +x *.sh`)*

---

## PHASE 4: THE UBUNTU DEPLOYMENT SEQUENCE (should be already done)

When the clean repository is cloned to the physical TUXEDO hardware, execute this to provision the system.

### 1. Install System Base Operators & V8 JavaScript Runtime
*(This replaces `deno.exe` by installing the official Deno runtime natively into the system, alongside ffmpeg and yt-dlp).*
```bash
# 1. Core Hardware Drivers
sudo apt update && sudo apt install -y ffmpeg curl unzip

# 2. V8 JavaScript Runtime (Deno - required for yt-dlp cipher parsing)
curl -fsSL https://deno.land/install.sh | sh
export PATH="$HOME/.deno/bin:$PATH"

# 3. WAN Extractor (yt-dlp)
sudo wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp

# 4. Neural Environment Manager (uv)
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### 2. Lock the Root & Commit
Finally, on your local machine, bind the new singularity and push to WAN.
```bash
git add .
git commit -m "[TIKKUN]: Bare-Metal Singularity. Transpiled to Bash. GPU Locked."
# git push -u origin master
```
```