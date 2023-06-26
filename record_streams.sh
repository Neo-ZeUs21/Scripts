#!/bin/bash

declare -a streams=(
        https://
        https://
        https://
        https://
    # Add more stream URLs here
)

declare -A recorded_streams

trap 'kill $(jobs -p)' EXIT

start_recording() {
    stream=$1
    echo "Starting recording for stream: $stream"
    yt-dlp -q -f 2 "$stream"
    echo "Stream ended: $stream"
    unset "recorded_streams[$stream]"
}

while true; do
    for stream in "${streams[@]}"; do
        if [[ -z "${recorded_streams[$stream]}" ]]; then
            if ! pgrep -f "yt-dlp -q -f 2 $stream" >/dev/null; then
                recorded_streams[$stream]=1
                start_recording "$stream" &
            fi
        fi
    done

    sleep 60  # Adjust the sleep duration as needed
done
