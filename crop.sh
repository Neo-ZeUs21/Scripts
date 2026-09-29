#!/bin/sh
outdir="output"
portdir="portrait"
logfile="convert.log"

mkdir -p "$outdir" "$portdir"
: > "$logfile"

ok=0
fail=0
warn=0
portrait=0

for img in *.jpg *.JPG *.jpeg *.JPEG; do
    [ -f "$img" ] || continue

    geo=$(identify -format '%[fx:w] %[fx:h]' -auto-orient "$img" 2>/dev/null)
    if [ -z "$geo" ]; then
        geo=$(convert "$img" -auto-orient -format '%w %h' info: 2>/dev/null)
    fi
    w=$(echo "$geo" | awk '{print $1}')
    h=$(echo "$geo" | awk '{print $2}')

    if [ -z "$w" ] || [ -z "$h" ]; then
        fail=$((fail + 1))
        msg="FAIL  $img  could not read size"
        printf '%s\n' "$msg"
        printf '%s\n' "$msg" >> "$logfile"
        continue
    fi

    if [ "$h" -gt "$w" ]; then
        # original file only — no ImageMagick write
        if cp -p -- "$img" "$portdir/$img"; then
            portrait=$((portrait + 1))
            ok=$((ok + 1))
            printf 'COPY  PORTRAIT  %s  %sx%s\n' "$img" "$w" "$h"
        else
            fail=$((fail + 1))
            msg="FAIL  $img  copy to $portdir failed"
            printf '%s\n' "$msg"
            printf '%s\n' "$msg" >> "$logfile"
        fi
        continue
    fi

    err=$(convert "$img" \
        -auto-orient \
        -resize '1024x600^' \
        -gravity center \
        -crop 1024x600+0+0 \
        +repage \
        "$outdir/$img" 2>&1)
    status=$?

    if [ "$status" -ne 0 ]; then
        fail=$((fail + 1))
        msg="FAIL  $img  ${w}x${h}  (exit $status)  $err"
        printf '%s\n' "$msg"
        printf '%s\n' "$msg" >> "$logfile"
        rm -f "$outdir/$img"
    elif [ -n "$err" ]; then
        warn=$((warn + 1))
        printf 'WARN  LANDSCAPE  %s  %sx%s  (see log)\n' "$img" "$w" "$h"
        printf 'WARN  LANDSCAPE  %s  %sx%s\n%s\n' "$img" "$w" "$h" "$err" >> "$logfile"
        ok=$((ok + 1))
    else
        ok=$((ok + 1))
        printf 'OK    LANDSCAPE  %s  %sx%s\n' "$img" "$w" "$h"
    fi
done

summary="Done. ok=$ok  portrait_copied=$portrait  warn=$warn  fail=$fail  log=$logfile"
printf '\n%s\n' "$summary"
printf '%s\n' "$summary" >> "$logfile"
