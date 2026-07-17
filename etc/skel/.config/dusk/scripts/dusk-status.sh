#!/bin/sh
# dusk-status.sh — feed dusk's built-in status bar via the root window name.
# dusk (like dwm) reads WM_NAME on the root window and renders it as the bar
# status. Extend the printf below with battery, volume, updates, etc.

while true; do
    xsetroot -name "  $(date '+%a %d %b  %H:%M')  "
    sleep 30
done
