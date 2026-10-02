# POCO F7 (onyx) PixelOS Wi-Fi 7 hotspot and exact Dual-STA

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
| 2.4 GHz | 5 GHz, 160 MHz | Stable |
| 5 GHz | 2.4 GHz | Stable |
| 5 GHz | 5 GHz, 160 MHz | Stable |
| 5 GHz | 6 GHz, 160 MHz | Stable |
| 5+6 GHz MLO | 2.4 GHz | Stable fallback |

Framework logs confirmed the pre-scan secondary interface, exact scan match, pre-created CMM reuse and primary-fallback rejection paths. See [runtime verification](docs/runtime-verification.md).

### 6 GHz hotspot

`hostapd` runs and `iw dev` shows a real `wlan1` interface of type `AP` on 6775 MHz. The generated hostapd configuration and driver path support Wi-Fi 7/EHT.

The fixed-frequency hotspot was observed at 20 MHz on this PixelOS test. Other ROM tests reached up to 160 MHz fallback. A 320 MHz SoftAP link is **not confirmed**, so this repository does not claim it as working.

## Requirements

- POCO F7 (`onyx`).
- Matching PixelOS build and APEX layout.
- Magisk/root access.
- A kernel/init_boot with the required Qualcomm dual-STA capability enabled. A device-specific init_boot image is intentionally not published here.
- A complete boot/init_boot backup before installation.

Do not install these packages on another device or an unrelated PixelOS build.

## Which files are for each feature?

### STA+STA / Exact Dual-STA

| File | Purpose | Required |
|---|---|---|
| `POCO-F7-PixelOS-Exact-Dual-STA-Framework-v1.0.zip` | Mounts the rebuilt PixelOS-native `service-wifi.jar` containing the working Infinity-X exact-request flow. | Yes |
| `POCO-F7-PixelOS-Exact-Dual-STA-v1.5-public.zip` | Provides the Wi-Fi overlay, exact-profile helper and update-safe profile storage for `wlan1`. | Yes |
| `Dual-STA-Profile-Manager-v1.3-configurable.apk` | Adds, saves and connects the exact secondary SSID/BSSID/frequency profiles. | Recommended for control |
| Patched device-specific `init_boot` | Enables the required kernel-side Qualcomm STA+STA capability. | Yes, but not published |

Install the Framework ZIP and Exact Dual-STA ZIP together, then install the Manager APK. The public files contain no private SSIDs, BSSIDs or passwords.

### 6 GHz Wi-Fi 7 hotspot

| File | Purpose | Required |
|---|---|---|
| `POCO-F7-PixelOS-6GHz-US-v1.0.zip` | Supplies the tested 6 GHz regulatory configuration. | Yes |
| `POCO-F7-PixelOS-Xiaomi-X2-Hostapd-v0.1-test.zip` | Preserves the Xiaomi/Infinity-X X2 hostapd binaries, libraries, SELinux rules and RUNPATH layout. | Yes |

These two ZIPs produced a real 6 GHz Wi-Fi 7/EHT hotspot with `wlan1` in `type AP` mode on 6775 MHz. **There is currently no separate confirmed 320 MHz working file.** The fixed-frequency PixelOS test linked at 20 MHz, while tests on other ROMs fell back to at most 160 MHz. Do not describe the hotspot as 320 MHz working until the client link or driver runtime proves a 320 MHz channel width.

## Downloads

Files are stored in [`releases/`](releases/):

- `POCO-F7-PixelOS-6GHz-US-v1.0.zip`
- `POCO-F7-PixelOS-Xiaomi-X2-Hostapd-v0.1-test.zip`
- `POCO-F7-PixelOS-Exact-Dual-STA-Framework-v1.0.zip`
- `POCO-F7-PixelOS-Exact-Dual-STA-v1.5-public.zip`
- `Dual-STA-Profile-Manager-v1.3-configurable.apk`
- `SHA256SUMS.txt`

The public Dual-STA ZIP contains no SSIDs, BSSIDs or passwords. Add profiles with the manager app after installation.

Version 1.5 keeps the manager profile database in `/data/adb/aks-dualsta` and exposes it at the manager-compatible module path. Saved profiles therefore survive later module ZIP updates.

## Installation

1. Disable older generic PixelOS Dual-STA modules, including `onyx_pixelos_dualsta_overlay`.
2. For 6 GHz hotspot support, install the 6 GHz US and Xiaomi X2 hostapd ZIPs.
3. For exact STA+STA, install the framework ZIP and the exact Dual-STA ZIP.
4. Install the profile manager APK.
5. Reboot.
6. Add the secondary networks in the manager app, then use **Save & Connect**.

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

Disable or remove the installed modules and reboot. Re-enable the previous module only if returning to the earlier generic band-selection implementation. Restore the saved init_boot image if the kernel-side Dual-STA patch also needs to be removed.

## Notes

- The Xiaomi X2 hostapd package contains device vendor binaries. See [NOTICE](NOTICE.md).
- Country-code and 6 GHz operation must comply with local regulations.
- This is a device-specific test project, not a universal Wi-Fi modification.
