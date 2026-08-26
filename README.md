# Xiaotan OpenWrt

可复现构建的 OpenWrt x86_64 固件配置，当前固定：

- OpenWrt `v25.12.5`
- x86/64 Generic
- UEFI / GRUB EFI
- SquashFS
- GZip image
- RootFS 2048 MiB
- LuCI + HTTPS + 简体中文
- Argon theme `v2.4.6`
- 默认 LAN：`192.168.12.128/24`
- 默认网关 / DNS：`192.168.12.1`
- LAN DHCP / DHCPv6 / RA：关闭

## Repository layout

```text
.
├── .github/workflows/build-openwrt.yml
├── config/xiaotan.config
├── files/etc/uci-defaults/99-xiaotan-defaults
├── scripts/prepare.sh
├── scripts/build.sh
├── versions.env
└── README.md
```

`config/xiaotan.config` 是 OpenWrt Buildroot 配置；LAN IP、旁路由 DHCP 行为和默认 LuCI 主题属于运行时 UCI 配置，所以放在 `files/etc/uci-defaults/99-xiaotan-defaults`。

## GitHub Actions

推送到 `main` 后会自动构建，并在 Workflow 页面产生 30 天保留的 Artifact。

手工运行：

```text
GitHub → Actions → Build OpenWrt → Run workflow
```

打 tag 会额外创建 GitHub Release，并永久挂载固件：

```bash
git tag v25.12.5-xiaotan.1
git push origin v25.12.5-xiaotan.1
```

主要产物：

```text
openwrt-x86-64-generic-squashfs-combined-efi.img.gz
sha256sums
xiaotan-firmware.sha256
xiaotan.config
versions.env
```

## Local build (WSL2 / Linux)

不要用 root 用户编译 OpenWrt。

```bash
./scripts/build.sh
```

默认工作目录是仓库下的 `work/`；也可以指定：

```bash
./scripts/build.sh ~/openwrt-build-ci
```

## Upgrade OpenWrt / Argon

修改 `versions.env`：

```bash
OPENWRT_REF=v25.12.5
ARGON_REF=v2.4.6
```

例如 OpenWrt 发布 `v25.12.6` 后，只需要先改 `OPENWRT_REF`，提交并让 Actions 编译测试。

## Important

`192.168.12.128` 必须确保局域网内没有其他设备占用。这个固件按“旁路由 / 服务节点”设计，默认关闭 LAN DHCP，避免与主路由 `192.168.12.1` 抢 DHCP。
