#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKDIR="${1:-$ROOT_DIR/work}"
OPENWRT_DIR="$WORKDIR/openwrt"
JOBS="${JOBS:-$(nproc)}"

"$ROOT_DIR/scripts/prepare.sh" "$WORKDIR"

cd "$OPENWRT_DIR"
make download -j"$JOBS"
make -j"$JOBS"

echo
echo "Firmware output:"
ls -lh bin/targets/x86/64/*combined-efi.img.gz bin/targets/x86/64/sha256sums
