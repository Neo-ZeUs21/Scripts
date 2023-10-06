#!/bin/bash

# Get the script's directory as the video directory
video_dir="$(dirname "$(readlink -f "$0")")"

# Create a list of unique names within square brackets
names=($(find "$video_dir" -type f -name '*\[*\]*' | sed 's/.*\[\(.*\)\].*/\1/' | sort -u))

# Create folders for each unique name
for name in "${names[@]}"; do
  mkdir -p "$video_dir/$name"
done

# Move video files to their respective folders
for file in "$video_dir"/*; do
  if [[ -f "$file" ]]; then
    name=$(echo "$file" | sed 's/.*\[\(.*\)\].*/\1/')
    if [[ -n "$name" ]]; then
      mv "$file" "$video_dir/$name"
    fi
  fi
done
