#!/bin/bash

home_folder="$HOME"
logs="$HOME/Scan/DailyReport"
day=$(date '+%Y-%m-%d')
time=$(date '+%Y-%m-%d %H:%M:%S')
file="$logs/scan-$day.log"

# folder creation
mkdir -p "$logs"

# start of the scan
echo "****************************" >> "$file" #file for writing scan logs
echo "Scan started: $time" >> "$file"
echo "Folder being scanned: $home_folder" >> "$file"

# ClamAV installation verification
if ! command -v clamscan >/dev/null 2>&1; then
    echo "ERROR: ClamAV is not installed." >> "$file"
    exit 2
fi

# Checking if the folder exists
if [ ! -d "$home_folder" ]; then
    echo "ERROR: Folder does not exist." >> "$file"
    exit 2
fi

# Running the antivirus scan
echo "Running antivirus scan..." >> "$file"

clamscan -r -i "$home_folder" >> "$file" 2>&1
result=$? #variable for status

# Record the scan result based on the scan output
case "$result" in
    0)
        echo "RESULT: No detections reported." >> "$file"
        ;;
    1)
        echo "RESULT: Malware detected. Review the scan report above." >> "$file"
        ;;
    2)
        echo "ERROR: ClamAV encountered an error during the scan." >> "$file"
        ;;
    *)
        echo "ERROR: Scan finished with an unexpected status: $result" >> "$file"
        ;;
esac

# End of the scan
time=$(date '+%Y-%m-%d %H:%M:%S')
echo "Scan completed: $time" >> "$file"
echo "****************************" >> "$file"

exit "$result"
