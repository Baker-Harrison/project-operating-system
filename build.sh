#!/usr/bin/env bash
set -euo pipefail

KERNEL_VERSION=7.3.3
KERNEL_SERIES="v${KERNEL_VERSION%%.*}.x"
ROOT="$(cd "$(dirname "$0")" && pwd)"
WORK="${WORK:-$HOME/project-operating-system}"
SRC="$WORK/kernel/linux-$KERNEL_VERSION"
OUT="$WORK/build"

mkdir -p "$WORK/kernel" "$OUT/kernel"

if [ ! -f "$SRC/Makefile" ]; then
    cd "$WORK/kernel"
    curl -sSfLO "https://cdn.kernel.org/pub/linux/kernel/$KERNEL_SERIES/linux-$KERNEL_VERSION.tar.xz"
    curl -sSfL "https://cdn.kernel.org/pub/linux/kernel/$KERNEL_SERIES/sha256sums.asc" \
        | grep " linux-$KERNEL_VERSION.tar.xz\$" | sha256sum -c -
    tar -xf "linux-$KERNEL_VERSION.tar.xz"
    rm "linux-$KERNEL_VERSION.tar.xz"
fi

[ -f "$OUT/kernel/.config" ] || make -C "$SRC" O="$OUT/kernel" x86_64_defconfig
make -C "$SRC" O="$OUT/kernel" -j"$(nproc)" bzImage
cp "$OUT/kernel/arch/x86/boot/bzImage" "$OUT/bzImage"

rm -rf "$OUT/rootfs"
mkdir -p "$OUT/rootfs/proc" "$OUT/rootfs/sys" "$OUT/rootfs/dev"
gcc -static -Os -s -o "$OUT/rootfs/init" "$ROOT/system/init.c"
(cd "$OUT/rootfs" && find . | cpio -o -H newc --quiet | gzip -9) > "$OUT/initramfs.cpio.gz"
