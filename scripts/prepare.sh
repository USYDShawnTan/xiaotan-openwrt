#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck disable=SC1091
source "$ROOT_DIR/versions.env"

WORKDIR="${1:-$ROOT_DIR/work}"
OPENWRT_DIR="$WORKDIR/openwrt"

mkdir -p "$WORKDIR"

# A cache step or an interrupted local run may leave a non-git directory here.
# Remove it before cloning so "git clone" never fails with "directory not empty".
if [[ -e "$OPENWRT_DIR" && ! -d "$OPENWRT_DIR/.git" ]]; then
  echo "Removing stale non-git OpenWrt directory: $OPENWRT_DIR"
  rm -rf "$OPENWRT_DIR"
fi

if [[ ! -d "$OPENWRT_DIR/.git" ]]; then
  git clone --filter=blob:none https://github.com/openwrt/openwrt.git "$OPENWRT_DIR"
fi

git -C "$OPENWRT_DIR" fetch --tags --force origin
git -C "$OPENWRT_DIR" checkout --force "$OPENWRT_REF"
git -C "$OPENWRT_DIR" clean -fdx package/luci-theme-argon files || true

cd "$OPENWRT_DIR"
./scripts/feeds update -a
./scripts/feeds install -a

rm -rf package/luci-theme-argon
git clone --depth 1 --branch "$ARGON_REF" \
  https://github.com/jerrykuku/luci-theme-argon.git \
  package/luci-theme-argon

cp "$ROOT_DIR/config/xiaotan.config" .config
rm -rf files
mkdir -p files
cp -a "$ROOT_DIR/files/." files/

make defconfig

echo "Prepared OpenWrt source: $OPENWRT_DIR"
echo "OpenWrt ref: $OPENWRT_REF"
echo "Argon ref:   $ARGON_REF"
echo "ccache:      $(grep -q '^CONFIG_CCACHE=y$' .config && echo enabled || echo disabled)"
