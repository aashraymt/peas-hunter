# PEAS Hunter - Bash Script

## 🔍 Purpose

This script processes the output of LinPEAS or WinPEAS scans, looking for sensitive keywords like `password`, `token`, `aws`, `.pem`, `id_rsa`, etc. It extracts likely file paths, saves matches, and optionally downloads the files from a remote base URL (e.g., an HTTP server on the target).

Made it especially for my Bash Project for Scripting Languages Class.

## ✅ Features

- Keyword-based regex scanning
- Parses likely sensitive file paths
- Supports optional `wget` download from a specified base URL
- Easy output management
- Works well with CTFs, red teaming, or local privilege escalation assessments

## 🛠️ Usage

```bash
./peas-hunter.sh -d loot -u http://10.10.10.10 linpeas.out

## 📄 Executable Permissions

Make sure the script is executable:

chmod +x peas-hunter.sh

## 📂 Sample Output

After scanning `linpeas.out`:

downloads/
├── matches.txt
├── found_paths.txt
├── id_rsa
├── secret.env
└── success.log

## For wget 

if ! command -v wget >/dev/null 2>&1; then
    echo "[-] wget not found. Please install wget or modify the script to use curl."
    exit 1
fi

### 🔗 References

- [LinPEAS GitHub](https://github.com/carlospolop/PEASS-ng/tree/master/linPEAS)
- [WinPEAS GitHub](https://github.com/carlospolop/PEASS-ng/tree/master/winPEAS)
- [Bash Regex Guide](https://tldp.org/LDP/abs/html/x17837.html)

