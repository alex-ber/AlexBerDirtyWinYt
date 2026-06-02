# /// script
# # STRICT LOCK: Capped at 3.12. Python 3.13+ (PEP 667) breaks Whisper's setup.py read_version() via locals() KeyError.
# requires-python = ">=3.11, <=3.12"
# dependencies = [
#     "openai-whisper==20240930",
#     "torch==2.12.0",
# # Whisper doesn't actually need torchaudio, because torchaudio==2.12.0 wasn't released, we're just dropping it out.
# ]
#
# [tool.uv.sources]
# # HARDWARE BRIDGE: Routes the engine downloads to the CUDA 13.0 binaries (Blackwell sm_120 support)
# torch = { index = "pytorch-cu130" }
#
# [[tool.uv.index]]
# name = "pytorch-cu130"
# url = "https://download.pytorch.org/whl/cu130"
# explicit = true
#
# [tool.uv.extra-build-dependencies]
# # STRICT LOCK: OpenAI's setup.py still relies on pkg_resources, requiring legacy setuptools to build
# openai-whisper = ["setuptools<81"]
# ///

import whisper
import glob
import os
import re
import torch


# -------- CONFIG & HARDWARE --------
MODEL_NAME = "medium"   # "small" = faster, "medium" = more accurate
LANGUAGE = "ru" #"en"

# --- HYBRID PATH DISCOVERY ---
def get_data_dir():
    # Priority 1: 'data' (Docker volume mount)
    # Priority 2: '.' (Native: User is running from inside the neural_extractor_node folder)
    # Priority 3: 'src/neural_extractor_node' (Native: User is running from the project root)
    for candidate in ["data", ".", "src/neural_extractor_node"]:
        if glob.glob(os.path.join(candidate, "*part*.wav")):
            return candidate
    return "." # Fallback if nothing is found

BASE_DIR = get_data_dir()

PATTERN = os.path.join(BASE_DIR, "*part*.wav")
OUTPUT_FILE = os.path.join(BASE_DIR, "full_transcript.txt")
# -----------------------------------


# Global Hardware Detection
DEVICE = "cuda" if torch.cuda.is_available() else "cpu"
# -----------------------------------

def extract_part_number(filename):
    match = re.search(r'part(\d+)', filename)
    return int(match.group(1)) if match else 0

def main():
    print(f"\n[SYSTEM] Target Hardware: {DEVICE.upper()}")

    if DEVICE == "cuda":
        gpu_name = torch.cuda.get_device_name(0)
        print(f"[SYSTEM] GPU Detected: {gpu_name}")

        # Hardware optimization for RTX 30/40 series (Ampere/Ada architectures)
        # Allows PyTorch to use TensorFloat32 for massive matrix math speedups
        torch.backends.cuda.matmul.allow_tf32 = True

    print(f"\nLoading '{MODEL_NAME}' model into VRAM...")
    # Explicitly map model into GPU memory
    model = whisper.load_model(MODEL_NAME, device=DEVICE)

    files = glob.glob(PATTERN)
    files = sorted(files, key=extract_part_number)

    print("\nMatched files:")
    for f in files:
        print(f)

    if not files:
        print("\nNo files found. Check filename pattern.")
        return

    print(f"\nFound {len(files)} files\n")

    with open(OUTPUT_FILE, "w", encoding="utf-8") as out:
        for i, file in enumerate(files, 1):
            print(f"\n[{i}/{len(files)}] Processing: {file}")

            try:
                # --- INFERENCE EXECUTION ---
                result = model.transcribe(
                    file,
                    language=LANGUAGE,
                    # Dynamic fp16 toggling:
                    # fp16=True (CUDA) drastically speeds up inference & cuts VRAM usage by 50%
                    # fp16=False (CPU) prevents float16 warnings/crashes when running on base CPU
                    fp16=(DEVICE == "cuda"),
                    verbose=True
                )

                # Always build from segments
                text = " ".join(seg["text"].strip() for seg in result["segments"])

                print(f"Finished: {file} | chars: {len(text)}")

                out.write(f"\n--- {os.path.basename(file)} ---\n")
                out.write(text + "\n")
                out.flush()

            except Exception as e:
                print(f"Error processing {file}: {e}")
                out.write(f"\n--- ERROR in {file} ---\n{e}\n")
                out.flush()

    print(f"\nDone. Transcript saved to: {OUTPUT_FILE}")

if __name__ == "__main__":
    main()

# --- EXECUTION INSTRUCTIONS ---

# Native Bare Metal Ubuntu (Ensure NVIDIA Proprietary Drivers + CUDA Toolkit are installed)
# sudo apt update && sudo apt install -y ffmpeg
# curl -LsSf https://astral.sh/uv/install.sh | sh
# uv run python "$(pwd)/src/neural_extractor_node/transcribe.py"
# or inside "src/neural_extractor_node"
# uv run python "transcribe.py"

# Docker Execution (If running this inside the container built previously):
# MUST pass the GPU flag to Docker to expose the hardware bridge:
# docker run -it --gpus all -v "$(pwd)/src/neural_extractor_node:/app/data" neural-extractor-node-i
