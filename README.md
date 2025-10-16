# peas-hunter
This script processes the output of LinPEAS or WinPEAS scans, looking for sensitive keywords like `password`, `token`, `aws`, `.pem`, `id_rsa`, etc. It extracts likely file paths, saves matches, and optionally downloads the files from a remote base URL (e.g., an HTTP server on the target).
