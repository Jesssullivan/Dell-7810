# Honey Boot Device Map - 2026-04-26

Source capture: private raw host capture from 2026-04-26. Raw device
identifiers are intentionally omitted from this public candidate branch.

Captured from `honey` on 2026-04-26 at 20:13:53 -04:00 while running
`6.19.5-7.xr.el10`.

## Short answer

`honey` has a split boot stack:

- firmware, the active EFI system partition, GRUB/shim, and `/boot` are on the
  Micron SATA SSD exposed as `/dev/sda`
- the running root filesystem `/` is LVM `rl00-root` on the Crucial NVMe SSD
  exposed as `/dev/nvme0n1`

For operator shorthand:

- if "boot drive" means firmware/EFI/GRUB/kernel files, the answer is
  `/dev/sda`, the Micron M550 512GB SATA SSD
- if "boot drive" means the root OS filesystem, the answer is
  `/dev/nvme0n1`, the Crucial CT2000P310SSD8 NVMe SSD

Do not remove, repartition, or repurpose `/dev/sda` just because root lives on
NVMe. It carries both the mounted ESP and `/boot`.

## Device map

| Role | Live path | Backing device | Public identity policy |
| --- | --- | --- | --- |
| Active EFI system partition | `/boot/efi` -> `/dev/sda1` | Micron M550 512GB SATA | Stable IDs retained only in private raw capture |
| Kernel/initramfs filesystem | `/boot` -> `/dev/sda2` | Micron M550 512GB SATA | Stable IDs retained only in private raw capture |
| Root filesystem | `/` -> `/dev/mapper/rl00-root` | Crucial CT2000P310SSD8 NVMe, first namespace path | LVM and partition IDs retained only in private raw capture |
| Runner/data volumes | repo-local runner and data mount set | Crucial CT2000P310SSD8 NVMe, second namespace path | Not part of the active boot path; mount identities retained only in private raw capture |
| Archive disk | `/archive` -> `/dev/mapper/hdd-archive` | Seagate ST4000DM000 4TB SATA | Separate archive LVM stack, not the mounted ESP or root path |

## Firmware view

`bootctl status` reports the active ESP at `/boot/efi` on the SATA SSD.

The EFI variable list contains:

- `Rocky Linux` on the active SATA ESP, file `/EFI/rocky/shimx64.efi`
- a secondary Seagate archive-disk EFI-looking entry, file
  `EFI/boot/bootx64.efi`

The Seagate entry is present as an EFI boot variable, but it is not the mounted
ESP for the running system. Treat it as a secondary/fallback-looking entry until
proven otherwise from firmware setup or `efibootmgr`.

`efibootmgr` was not available in the live capture.

## Kernel command line

The running kernel reports:

```text
BOOT_IMAGE=(hd2,gpt2)/vmlinuz-6.19.5-7.xr.el10 root=/dev/mapper/rl00-root
```

From Linux's mounted view, the kernel file is under `/boot` on `/dev/sda2` and
the root filesystem is `/dev/mapper/rl00-root` on `/dev/nvme0n1p1`.

## Operational notes

- Any bootloader repair, ESP backup, or firmware-entry work must include the
  Micron SATA SSD `/dev/sda`.
- Any root filesystem, package, kernel-lane runtime, or container-root work must
  account for the `rl00` LVM stack on `/dev/nvme0n1`.
- Disk labels such as `/dev/sda` and `/dev/nvme0n1` can change across hardware
  changes. For destructive operations, use the private raw capture or a fresh
  live capture to resolve serials, UUIDs, PARTUUIDs, and `/dev/disk/by-id/*`
  paths before acting.
