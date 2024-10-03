#!/bin/bash

# Get the script's directory as the video directory
video_dir="$(dirname "$(readlink -f "$0")")"

# Create a list of unique names within square brackets
names=($(find "$video_dir" -type f -name '*\[*\]*' | sed 's/.*\[\(.*\)\].*/\1/' | sort -u))

# Create folders for each unique name and copy the file and create 'done' directory
for name in "${names[@]}"; do
  dir_path="$video_dir/$name"
  if [ ! -d "$dir_path" ]; then
    mkdir -p "$dir_path"
    cp "$video_dir/dir_con_sheet10.sh" "$dir_path/"
    mkdir "$dir_path/done"
    # Copy the 'half_size_v.sh' file into the 'done' folder
    cp "$video_dir/half_size_v.sh" "$dir_path/done/"
  fi
done

# Move video files with .mp4 extension to their respective folders and open Dolphin tabs
for file in "$video_dir"/*.mp4; do
  if [[ -f "$file" ]]; then
    name=$(echo "$file" | sed 's/.*\[\(.*\)\].*/\1/')
    if [[ -n "$name" ]]; then
      mv "$file" "$video_dir/$name"
    fi
  fi
done

