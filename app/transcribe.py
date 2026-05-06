import whisper
import glob
import os
import re


# -------- CONFIG --------
MODEL_NAME = "small"   # "small" = faster, "medium" = more accurate
PATTERN = "*part*.wav"
OUTPUT_FILE = "full_transcript.txt"
LANGUAGE = "en" #"ru"
# ------------------------

#with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
#    f.write("TEST\n")
#    f.flush()
#
#print(os.getcwd())
#print(os.path.abspath(OUTPUT_FILE))
#
#import sys
#sys.exit(0)


def extract_part_number(filename):
    match = re.search(r'part(\d+)', filename)
    return int(match.group(1)) if match else 0


def main():
    print("Loading model...")
    model = whisper.load_model(MODEL_NAME)

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
                result = model.transcribe(
                    file,
                    language=LANGUAGE,
                    fp16=False,      # correct for CPU
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