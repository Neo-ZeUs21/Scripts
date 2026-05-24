#!/bin/bash
# Convert .MOV to Speed up Timelapse .mp4

# Speed-up factor
SPEED=15

for f in *.MOV *.mov; do
    [ -e "$f" ] || continue

    base="${f%.*}"
    out="${base}_${SPEED}x_timelapse.mp4"

    # Skip if output already exists
    if [ -f "$out" ]; then
        echo "Skipping (already exists): $out"
        continue
    fi

    echo "Processing: $f -> $out"

    ffmpeg -hide_banner -loglevel info \
        -i "$f" \
        -vf "setpts=PTS/${SPEED}" \
        -an \
        -c:v libx264 \
        -preset slow \
        -crf 15 \
        -pix_fmt yuv420p \
        "$out"

    # Check if ffmpeg succeeded
    if [ $? -eq 0 ]; then
        echo "Finished: $out"
    else
        echo "ERROR processing: $f"
    fi

done

echo "All done."
