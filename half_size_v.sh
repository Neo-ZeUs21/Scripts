#!/bin/bash

# Loop through all video files in the current directory
for input_video in *; do
    # Check if the file is a video file (you can adjust the extensions as needed)
    if [[ "$input_video" == *.mp4 || "$input_video" == *.mkv || "$input_video" == *.avi ]]; then
        
        # Get the output filename by appending '-recoded' before the file extension
        output_video="${input_video%.*}-recoded.${input_video##*.}"

        # Get the bitrate of the input video
        bitrate=$(ffmpeg -i "$input_video" 2>&1 | grep "bitrate" | awk '{print $(NF-1)}' | sed 's/kbit//')

        # Calculate half the bitrate
        half_bitrate=$((bitrate / 2))

        # Convert the video with the specified settings
        ffmpeg -i "$input_video" -vf "fps=15" -b:v "${half_bitrate}k" -c:a copy "$output_video"

        echo "Converted: $input_video to $output_video"
    fi
done
