#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Usage: $0 input_video.mp4 start_time_in_min end_time_in_min"
    exit 1
fi

input_file="$1"
start_time_min="$2"
end_time_min="$3"

start_time=$(printf "%02d:%02d:%02d" $((start_time_min/60)) $((start_time_min%60)) 0)
end_time=$(printf "%02d:%02d:%02d" $((end_time_min/60)) $((end_time_min%60)) 0)

output_file="${input_file%.mp4}-CUT.mp4"

ffmpeg -i "$input_file" -ss "$start_time" -to "$end_time" -c:v copy -c:a copy "$output_file"

Now you can use the script like this:

bash

./cutvideo.sh originalvideo.mp4 0 45

