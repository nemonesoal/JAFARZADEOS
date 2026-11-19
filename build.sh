#!/bin/bash
set -euo pipefail
if [[ "$(dpkg --print-architecture)" != "amd64" ]]; then
  echo "This build targets 64-bit x86 PCs (amd64)." >&2
  exit 1
fi
if [[ $EUID -ne 0 ]]; then
  echo "Run with: sudo ./build.sh" >&2
  exit 1
fi
apt-get update
apt-get install -y live-build debootstrap squashfs-tools xorriso
lb clean --purge || true
lb config \
  --mode debian \
  --distribution bookworm \
  --architectures amd64 \
  --binary-images iso-hybrid \
  --archive-areas "main contrib non-free non-free-firmware" \
  --bootappend-live "boot=live components persistence quiet splash"
lb build
echo
echo "JAFARZADEOS 1.1 build finished."
find . -maxdepth 1 -type f -name '*.iso' -printf '%f\n'
