#!/usr/bin/env bash
set -euo pipefail

OUT="${WORK:-$HOME/project-operating-system}/build"

ACCEL=tcg
[ -w /dev/kvm ] && ACCEL=kvm

if [ "${1:-}" = "--window" ]; then
    DISPLAY_ARGS=(-display gtk)
    CONSOLE=tty0
else
    DISPLAY_ARGS=(-nographic)
    CONSOLE=ttyS0
fi

exec qemu-system-x86_64 \
    -accel "$ACCEL" \
    -m 1G \
    -kernel "$OUT/bzImage" \
    -initrd "$OUT/initramfs.cpio.gz" \
    -append "console=$CONSOLE quiet" \
    "${DISPLAY_ARGS[@]}"
