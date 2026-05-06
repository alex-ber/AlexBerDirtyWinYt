yt-dlp on Linux
https://ubuntushell.com/download-youtube-video/
https://github.com/yt-dlp/yt-dlp/wiki/Installation
https://github.com/yt-dlp/yt-dlp#release-files

***
https://chunkaudio.com/app.html for chunking
***
The fastest path depends on whether you’re willing to install anything. If you want minimal setup, use a browser-based Whisper tool. If you want maximum control and privacy, run it locally.

Start with the simplest option: online Whisper.

Open a web app such as Whisper Web or Hugging Face Whisper Demo. Upload your `.wav` file, select English (or auto-detect), and run transcription. When it finishes, download the `.txt` or `.srt`. This usually takes a few minutes and requires no installation. The tradeoff is file size limits and less control over formatting.

If you want a cleaner, more reliable transcript—especially for longer audio—run Whisper locally.

Install Python (3.9+), then install FFmpeg because Whisper depends on it. After that, install OpenAI Whisper via pip:

`pip install openai-whisper`

Place your audio file in a working folder. Then run:

`whisper "What Came Before part01.wav" --model medium --language en`

Use `medium` as a good balance between speed and accuracy. If your machine is strong (GPU), use `large` for best quality. If it’s slower, use `small`.

Whisper will output multiple files:

* `.txt` (plain transcript)
* `.srt` (subtitles with timestamps)
* `.vtt` (web captions)
* `.json` (structured data)

For a “clean transcript,” take the `.txt` and optionally post-process it:

* Remove filler words
* Fix punctuation
* Split into paragraphs

If you want higher accuracy:

* Convert audio to mono, 16kHz first using FFmpeg:
  `ffmpeg -i input.wav -ac 1 -ar 16000 output.wav`
* Then transcribe the cleaned file
* Use `--initial_prompt` if you have domain-specific vocabulary

If you want, upload the audio again after you run Whisper and I can refine the transcript into a polished, readable version (speaker labels, paragraphs, etc.).


***

Yes—your screenshot shows a valid FFmpeg installation. You have the key executables (`ffmpeg.exe`, `ffprobe.exe`), so you’re ready to proceed.

Now here’s the fastest clean workflow using OpenAI Whisper locally on Windows.

First, make sure Python is installed. If not, install Python (3.9+), and during setup check “Add to PATH”.

Next, install Whisper:
Open Command Prompt in any folder and run:

```
pip install openai-whisper
```

Now ensure FFmpeg is accessible system-wide (this matters):

* Put your FFmpeg folder (the one with `ffmpeg.exe`) somewhere permanent (e.g., `C:\ffmpeg`)
* Add that folder to your system PATH:

  * Search “Environment Variables”
  * Edit PATH → Add `C:\ffmpeg` (or wherever your `.exe` files are)

Test it:

```
ffmpeg -version
```

If it prints version info, you're set.

Now transcribe your file.

Put your `.wav` file in an easy location (e.g., Desktop), then run:

```
whisper "What Came Before part01.wav" --model medium --language en
```

Key points:

* `medium` = good balance of speed/accuracy
* Use `large` if you want maximum accuracy and your PC can handle it
* Add `--task translate` if the audio is non-English and you want English output

Optional (but improves quality slightly):
Preprocess audio:

```
ffmpeg -i "What Came Before part01.wav" -ac 1 -ar 16000 cleaned.wav
```

Then run Whisper on `cleaned.wav`.

When it finishes, you’ll get:

* `.txt` → full transcript (what you want)
* `.srt` → timestamped subtitles
* `.vtt` → web captions

If the transcript comes out messy (run-on text, no structure), paste it here and I’ll normalize it into a clean, readable transcript with paragraphs and speaker flow.

***


import whisper

# Load model (options: tiny, base, small, medium, large)
model = whisper.load_model("medium")

# Transcribe file
result = model.transcribe("What Came Before part01.wav", language="en")

# Print full transcript
print(result["text"])

# Save to file
with open("transcript.txt", "w", encoding="utf-8") as f:
    f.write(result["text"])
	
***

ffmpeg -i input.wav -ac 1 -ar 16000 output.wav

If you tell me your CPU/RAM, I can estimate expected runtime more precisely.

***

Are you sure about fp16=False? Why are you sure I do not get GPU?

I’m not “sure” you don’t have a GPU—I’m inferring based on typical setups and the behavior you described. Most Windows Python environments default to CPU unless CUDA-enabled PyTorch is explicitly installed and configured.

The `fp16=False` recommendation is a **defensive default**, not a requirement. Here’s the precise logic:

* `fp16=True` (default) → uses half-precision on GPU (fast, efficient)
* On CPU → fp16 is **not supported**, so it either:

  * silently falls back to fp32, or
  * causes slowdowns / instability depending on build

So:

* If you **do have a CUDA GPU properly configured**, you should **remove `fp16=False`** (or explicitly set `fp16=True`)
* If you **don’t**, setting `fp16=False` avoids edge-case issues

---

You can check definitively in 5 seconds:

```python
import torch
print(torch.cuda.is_available())
```

Interpretation:

* `True` → you have usable GPU → **use fp16 (or omit the flag)**
* `False` → CPU only → **keep fp16=False**

---

If GPU is available, also check which device Whisper is using:

```python
import whisper
model = whisper.load_model("small")
print(model.device)
```

You want:

```
cuda:0
```

not:

```
cpu
```

---

If you *expected* GPU but got `False`, then the issue is almost always:

* You installed CPU-only PyTorch
* CUDA toolkit mismatch
* Missing NVIDIA drivers

In that case, fix your PyTorch install rather than tweaking Whisper.

---

Bottom line:

* `fp16=False` = safe default for CPU
* Not required if GPU is correctly configured
* You should verify rather than assume

If you paste the output of `torch.cuda.is_available()` and `model.device`, I can tell you exactly how your system is behaving.


***

C:\temp\youtube_downlonader\app>python
Python 3.13.3 (tags/v3.13.3:6280bb5, Apr  8 2025, 14:47:33) [MSC v.1943 64 bit (AMD64)] on win32
Type "help", "copyright", "credits" or "license" for more information.
>>> import torch
>>> print(torch.cuda.is_available())
False

That result is definitive: your current PyTorch build is **CPU-only**.

So in your case:

* `torch.cuda.is_available() == False`
* Whisper will run entirely on CPU
* `fp16=False` is **correct and appropriate**

There’s no performance upside to enabling fp16 without CUDA—it won’t activate GPU acceleration.

---

Why this happened (most likely):

You’re on Python **3.13**, which is very recent. As of now, most CUDA-enabled PyTorch builds lag behind new Python versions. So pip installed a **CPU-only wheel**.

---

What this means for your transcription:

* Your current setup will work reliably
* But performance will be:

  * ~real-time or slower on `small`
  * significantly slower on `medium`

---

If you want GPU acceleration, you need to align three things:

1. Supported Python version (typically 3.10–3.12)
2. CUDA-compatible PyTorch build
3. NVIDIA GPU + drivers

In practice, the fastest fix is:

* Install Python 3.11
* Create a fresh virtual environment
* Install CUDA-enabled PyTorch from the official selector
* Reinstall Whisper

---

However—important tradeoff:

Given you’ve already:

* chunked the audio
* stabilized the pipeline

You may not need GPU at all unless you’re doing this frequently.

---

Bottom line:

* Your current setup is technically correct
* `fp16=False` is the right choice
* The “slowness” you observed is expected CPU behavior, not a bug

If you want, I can give you a clean GPU-enabled setup path—but only if you actually have an NVIDIA GPU worth using.


***

Add to AlexBerUtils main.py?


### Solution The "Anchor File" Pattern (Absolute Determinism)

Instead of asking Python *“Where does my code physically live?”* (to which Python constantly lies), we use an approach adopted today by `pytest`, `black`, `ruff`, and even `git`. We look for an **anchor** — a physical marker of the project root.

Your Dockerfile states: `# Strict mapping of uv.lock ensures absolute determinism.` That means `uv.lock` (or `pyproject.toml`) is our single source of truth.

This code will reliably locate the project root regardless of how it’s executed (via `uv run`, `python -m`, from a nested directory, or through a bash script):

```python
import os
from pathlib import Path

def lock_cwd_to_project_root(anchor_file="uv.lock"):
    """
    Deterministic root discovery. No import magic, no __file__.
    Relies solely on OS-level behavior and the filesystem.
    """
    # Start from the current working directory set by the calling process (Docker, uv, shell)
    current_dir = Path.cwd().resolve()
    
    # Traverse upward through the directory tree searching for the anchor
    for p in [current_dir] + list(current_dir.parents):
        if (p / anchor_file).exists():
            os.chdir(p)
            # print(f"[HARDWARE_BRIDGE] CWD locked to: {p}")
            return p
            
    # If we reach the filesystem root without finding uv.lock — this is a fatal environment violation
    raise RuntimeError(f"FATAL: Anchor '{anchor_file}' not found. Macro-entropy leakage detected.")

lock_cwd_to_project_root()
```

**Why this is best:** It does not depend on the Python major version, the module loader, or how the script was passed to the interpreter. Only filesystem-level system calls.
	