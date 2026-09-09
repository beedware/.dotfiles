These steps cover using `cfdisk` (or `fdisk` if you're brave) to create the partitions before installing Void Linux.

List disks first so you do not partition the wrong device:

```bash
lsblk
cfdisk /dev/<DEVICE_NAME>
```

If prompted, choose `gpt` unless you specifically need legacy BIOS with `dos`.

Recommended layout for a UEFI system:

1. `512M` EFI System partition `/boot/efi`
2. `4G` swap partition `[SWAP]`
3. Remaining space for root `/`

Inside `cfdisk`:

- EFI partition: `EFI System`
- Swap partition: `Linux swap`
- Root partition: `Linux filesystem`

Formatting the partitions, or via void-installer:

```bash
mkfs.vfat -F 32 /dev/[BOOT_EFI] # VFAT (EXFAT)
mkswap /dev/[SWAP]              # SWAP
mkfs.ext4 /dev/[ROOT]           # EXT4
swapon /dev/[SWAP]
```
