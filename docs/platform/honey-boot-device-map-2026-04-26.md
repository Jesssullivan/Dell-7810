# Honey Boot Device Map - 2026-04-26

Live capture:
[`data/captures/honey/boot-device-map-2026-04-26.txt`](../../data/captures/honey/boot-device-map-2026-04-26.txt)

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

| Role | Live path | Backing device | Stable identity |
| --- | --- | --- | --- |
| Active EFI system partition | `/boot/efi` -> `/dev/sda1` | Micron M550 512GB SATA, serial `14260C704E12` | PARTUUID `8a29f58b-b50d-4a91-9b26-a0458a37144e`, UUID `C7D0-7769` |
| Kernel/initramfs filesystem | `/boot` -> `/dev/sda2` | Micron M550 512GB SATA, serial `14260C704E12` | PARTUUID `56b8081d-34ba-4ada-bc4b-5ff0c01788e7`, UUID `a82f9c0e-cc5a-4b8d-9227-c76078cef62b` |
| Root filesystem | `/` -> `/dev/mapper/rl00-root` | Crucial CT2000P310SSD8 NVMe, serial `254253B476AD`, partition `/dev/nvme0n1p1` | root UUID `a0fbfd79-13cf-4e84-9029-0ed99b9298f8`, PV UUID `yneqTQ-sn7g-go0C-9tFb-dvfz-qZ47-ORFmH2`, PARTUUID `5fe8fde7-0e8c-4f90-b1da-7fa375490599` |
| Runner/data volumes | `/home/jess/actions-runner`, `/home/github-runner`, `/srv/data-home`, `/var/lib/rancher`, `/data` | Crucial CT2000P310SSD8 NVMe, serial `254253B476E3`, partition `/dev/nvme1n1p1` | data LVM stack, not part of the active boot path |
| Archive disk | `/archive` -> `/dev/mapper/hdd-archive` | Seagate ST4000DM000 4TB SATA, serial `S300ARPH`, partition `/dev/sdb3` | separate archive LVM stack, not the mounted ESP or root path |

## Firmware view

`bootctl status` reports the active ESP at:

```text
/boot/efi (/dev/disk/by-partuuid/8a29f58b-b50d-4a91-9b26-a0458a37144e)
```

The EFI variable list contains:

- `Rocky Linux` on PARTUUID `8a29f58b-b50d-4a91-9b26-a0458a37144e`, file
  `/EFI/rocky/shimx64.efi`
- `UEFI: ST4000DM000-1F2168` on PARTUUID
  `f9e9d127-68e0-4ffd-9fff-07ba61088f36`, file
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
  changes. Use the stable serials, UUIDs, PARTUUIDs, and `/dev/disk/by-id/*`
  paths from the capture for destructive operations.
