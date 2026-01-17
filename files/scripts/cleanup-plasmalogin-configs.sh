#!/usr/bin/env bash
set -ex

LOG="/setup-plasmalogin.log"
echo "DEBUG: Starting cleanup-plasmalogin-configs.sh" > "$LOG"

# Identify and log all plasmalogin.conf files before clearing them
echo "Searching for all plasmalogin.conf files..." >> "$LOG"
FILES_TO_CLEAN=$(find /etc /usr/etc /usr/lib/sysusers.d /usr/lib/tmpfiles.d -name "*plasmalogin*.conf" 2>/dev/null || true)

for f in $FILES_TO_CLEAN; do
    echo "--- CONTENT OF $f ---" >> "$LOG"
    cat "$f" >> "$LOG" || echo "could not read" >> "$LOG"
    echo "--- END OF $f ---" >> "$LOG"
done

# Remove all plasmalogin sysusers and manager configs
echo "Removing conflicting configs..." >> "$LOG"
for f in $FILES_TO_CLEAN; do
    rm -f "$f"
    echo "Deleted $f" >> "$LOG"
done

echo "Cleanup complete" >> "$LOG"
