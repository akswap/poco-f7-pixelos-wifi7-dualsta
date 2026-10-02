# POCO F7 (onyx) PixelOS Wi-Fi 7 hotspot and exact Dual-STA

![Android](https://img.shields.io/badge/Android-17-3DDC84?logo=android&logoColor=white)
![ROM](https://img.shields.io/badge/ROM-PixelOS-4285F4)
![Build](https://img.shields.io/badge/Build-20260920__1714-555555)
![Root](https://img.shields.io/badge/Root-Required-E53935)
![Device](https://img.shields.io/badge/Device-POCO%20F7-76B900)
![Dual-STA](https://img.shields.io/badge/STA%2BSTA-Tested-43A047)
![6 GHz](https://img.shields.io/badge/6%20GHz-Tested-43A047)
![Wi-Fi 7](https://img.shields.io/badge/Wi--Fi%207-802.11be-00A0D2)
![320 MHz](https://img.shields.io/badge/320%20MHz-Negotiated-43A047)

Device-specific Magisk modules and test evidence for the POCO F7 (`onyx`) on PixelOS build `CP2A.260605.016`.

This repository covers two separate features:

- A real 6 GHz SoftAP using the Xiaomi/Infinity-X X2 hostapd stack.
- App-controlled STA+STA where `wlan1` connects to the exact SSID, BSSID and preferred frequency selected by the user.

## Current results

### Exact Dual-STA

The PixelOS-native `service-wifi.jar` was patched with the working Infinity-X request flow. The donor Infinity-X jar is not copied over PixelOS.

Verified combinations:

| `wlan0` primary | `wlan1` secondary | Result |
|---|---|---|
| 2.4 GHz | 2.4 GHz | Stable |
| 2.4 GHz | 5 GHz, 160 MHz | Stable |
| 2.4 GHz | 6 GHz | Failed: 6 GHz becomes primary |
| 5 GHz | 2.4 GHz | Stable |
| 5 GHz | 5 GHz, 160 MHz | Stable |
| 5 GHz | 6 GHz, 160 MHz | Stable |
| 6 GHz | 5 GHz, 160 MHz | Stable |
| 6 GHz | 2.4 GHz | Stable |
| 5+6 GHz MLO | 2.4 GHz | Stable |
| 5+6 GHz MLO | 5 GHz | Stable |

Framework logs confirmed the pre-scan secondary interface, exact scan match, pre-created CMM reuse and primary-fallback rejection paths. See [runtime verification](docs/runtime-verification.md).

The verified matrix includes `6 GHz primary + 5 GHz secondary`, `6 GHz primary + 2.4 GHz secondary`, and `2.4 GHz primary + 2.4 GHz secondary`. The requested `2.4 GHz primary + 6 GHz secondary` case fails because the framework promotes 6 GHz to primary. A standalone 6 GHz primary with another 6 GHz secondary has not been tested.

### 6 GHz hotspot

`hostapd` runs and the phone creates a real AP interface (`wlan1` or `wlan2`, depending on the active concurrency mode). The generated hostapd configuration and driver path enable Wi-Fi 7/EHT.

The current PixelOS test confirmed a 6 GHz Wi-Fi 7 link on channel 133 (6615 MHz). The Qualcomm driver started the AP with `bw 13` and entered `vdev_start_cmd_fill_11be` with EHT operations. A Windows client with an Intel BE200 then connected to `MobSoftAP_Router` as `802.11be` and reported an aggregated receive/transmit link speed of **3843/3980 Mbps**, confirming the negotiated 320 MHz link. Earlier 20 MHz and 160 MHz results were fallback test runs, not the final working result.

## Requirements

- POCO F7 (`onyx`).
- Matching PixelOS build and APEX layout.
- Magisk/root access.
- The exact PixelOS onyx build dated `20260920_1714`; the published patched and stock `init_boot` images are build-specific.
- A complete boot/init_boot backup before installation.

Do not install these packages on another device or an unrelated PixelOS build.

## Which files are for each feature?

### STA+STA / Exact Dual-STA

| File | Purpose | Required |
|---|---|---|
| `POCO-F7-PixelOS-Exact-Dual-STA-Framework-v1.0.zip` | Mounts the rebuilt PixelOS-native `service-wifi.jar` containing the working Infinity-X exact-request flow. | Yes |
| `POCO-F7-PixelOS-Exact-Dual-STA-v1.5-public.zip` | Provides the Wi-Fi overlay, exact-profile helper and update-safe profile storage for `wlan1`. | Yes |
| `Dual-STA-Profile-Manager-v1.3-configurable.apk` | Adds, saves and connects the exact secondary SSID/BSSID/frequency profiles. | Recommended for control |
| `init_boot-onyx_20260920_1714-DualSTA-Magisk-PATCHED.img` | Magisk-patched `init_boot` with the tested Dual-STA preload and `qca_cld3_wcn7750-dualsta.ko` payload. | Yes |
| `init_boot-onyx_20260920_1714.img` | Official matching stock image for rollback. | Keep available before flashing |

Install the Framework ZIP and Exact Dual-STA ZIP together, then install the Manager APK. The public files contain no private SSIDs, BSSIDs or passwords.

### 6 GHz Wi-Fi 7 hotspot

| File | Purpose | Required |
|---|---|---|
| `POCO-F7-PixelOS-6GHz-US-v1.0.zip` | Supplies the tested 6 GHz regulatory configuration. | Yes |
| `POCO-F7-PixelOS-Xiaomi-X2-Hostapd-v0.1-test.zip` | Preserves the Xiaomi/Infinity-X X2 hostapd binaries, libraries, SELinux rules and RUNPATH layout. | Yes |

These two ZIPs produced the confirmed 6 GHz Wi-Fi 7/EHT hotspot. In the successful 320 MHz run, the AP interface was `wlan2` on channel 133 (6615 MHz); the interface number can change with Wi-Fi concurrency state. Both hotspot ZIPs are required—the 320 MHz result is the combined configuration, not a separate third package.

## Downloads

Module ZIPs, the APK and checksum file are stored in [`releases/`](releases/). The two `init_boot` images are attached to the tagged GitHub Release so large boot images are not committed to the Git history.

- `POCO-F7-PixelOS-6GHz-US-v1.0.zip`
- `POCO-F7-PixelOS-Xiaomi-X2-Hostapd-v0.1-test.zip`
- `POCO-F7-PixelOS-Exact-Dual-STA-Framework-v1.0.zip`
- `POCO-F7-PixelOS-Exact-Dual-STA-v1.5-public.zip`
- `Dual-STA-Profile-Manager-v1.3-configurable.apk`
- `init_boot-onyx_20260920_1714-DualSTA-Magisk-PATCHED.img`
- `init_boot-onyx_20260920_1714.img`
- `SHA256SUMS.txt`

The public Dual-STA ZIP contains no SSIDs, BSSIDs or passwords. Add profiles with the manager app after installation.

Version 1.5 keeps the manager profile database in `/data/adb/aks-dualsta` and exposes it at the manager-compatible module path. Saved profiles therefore survive later module ZIP updates.

## Installation

1. Verify that the phone is POCO F7 (`onyx`) on PixelOS build `20260920_1714`, unlock the bootloader and keep the published stock image available.
2. Reboot to bootloader and flash `init_boot-onyx_20260920_1714-DualSTA-Magisk-PATCHED.img` to the current `init_boot` slot.
3. Disable older generic PixelOS Dual-STA modules, including `onyx_pixelos_dualsta_overlay`.
4. For 6 GHz hotspot support, install the 6 GHz US and Xiaomi X2 hostapd ZIPs.
5. For exact STA+STA, install the framework ZIP and the exact Dual-STA ZIP.
6. Install the profile manager APK and reboot.
7. Add the secondary networks in the manager app, then use **Save & Connect**.

```text
fastboot getvar current-slot
fastboot flash init_boot init_boot-onyx_20260920_1714-DualSTA-Magisk-PATCHED.img
fastboot reboot
```

The framework package bind-mounts the rebuilt PixelOS jar. It does not overwrite the APEX file on disk.

## Verification

```text
iw dev
iw dev wlan0 link
iw dev wlan1 link
pidof hostapd
```

For Dual-STA, `wlan0` and `wlan1` must both show `type managed`, with `wlan1` on the selected SSID/BSSID. For hotspot mode, `wlan1` must show `type AP` and `hostapd` must have a live PID.

## Rollback

Disable or remove the installed modules, then flash the published matching stock image to the current slot:

```text
fastboot flash init_boot init_boot-onyx_20260920_1714.img
fastboot reboot
```

To restore both slots intentionally, use `fastboot --slot=all flash init_boot init_boot-onyx_20260920_1714.img`. Do not use `init_boot_ab` as a partition name; it is not standard fastboot A/B syntax.

## Notes

- The Xiaomi X2 hostapd package contains device vendor binaries. See [NOTICE](NOTICE.md).
- Country-code and 6 GHz operation must comply with local regulations.
- This is a device-specific test project, not a universal Wi-Fi modification.
