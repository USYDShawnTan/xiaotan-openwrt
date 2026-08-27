# xiaotan OpenWrt

Personal reproducible OpenWrt x86/64 firmware build.

## Current build

- OpenWrt: `v25.12.5`
- Target: `x86/64`
- Image: `squashfs-combined-efi.img.gz`
- LuCI: HTTPS + Simplified Chinese
- Theme: Argon
- Default LAN IP: `192.168.12.128/24`
- Gateway / DNS: `192.168.12.1`
- LAN DHCP / DHCPv6 / RA: disabled
- Compiler cache: OpenWrt `ccache` enabled

## GitHub Actions

A push to `main` builds the complete firmware. The workflow caches:

- `work/openwrt/dl` — downloaded source archives
- `work/openwrt/.ccache` — compiler cache

The first build is still a full clean build. Later builds remain complete firmware builds, but source downloads and many compiler results can be reused from cache.

The downloadable Actions artifact is a ZIP containing **only**:

```text
openwrt-x86-64-generic-squashfs-combined-efi.img.gz
```

Artifacts are retained for 7 days. Tagged builds additionally publish the same `.img.gz` as the sole GitHub Release asset.

## Build locally

```bash
./scripts/build.sh
```

Or specify another work directory:

```bash
./scripts/build.sh /path/to/work
```

## Version update

Edit `versions.env`:

```bash
OPENWRT_REF=v25.12.5
ARGON_REF=v2.4.6
```

## Release

```bash
git tag v25.12.5-xiaotan.1
git push origin v25.12.5-xiaotan.1
```
