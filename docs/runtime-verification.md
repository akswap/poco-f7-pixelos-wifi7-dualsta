# PixelOS exact Dual-STA port

## Installed state

- Framework module: `aks_pixelos_exact_dualsta_wifi` v1.0
- App-controlled module: `onyx_dualsta_overlay` v1.4.0-pixelos-exact
- Previous generic module: `onyx_pixelos_dualsta_overlay` disabled, retained for rollback
- Manager app: configurable build using `onyx_dualsta_overlay/profiles.conf`
- Mounted PixelOS-native `service-wifi.jar` SHA-256: `3939153E80F15B9D23124952B8559FF87FBC4447BF9C02FC14E297FB75292A7F`

The framework jar was rebuilt from the current PixelOS jar. It adds the Infinity-X exact secondary-STA flow without copying the Infinity-X donor jar.

## Verified runtime combinations

| Primary (`wlan0`) | Secondary (`wlan1`) | Result |
|---|---|---|
| 5 GHz, 5640 MHz | 2.4 GHz, exact BSSID, 2462 MHz | Stable |
| 5 GHz, 5640 MHz | 5 GHz, exact BSSID, 5200 MHz/160 MHz | Stable |
| 5 GHz, 5640 MHz | 6 GHz, exact BSSID, 6775 MHz/160 MHz | Stable |
| 2.4 GHz, 2462 MHz | 5 GHz, exact BSSID, 5200 MHz/160 MHz | Stable |
| 5+6 GHz MLO primary | 2.4 GHz, exact BSSID | Stable fallback after occupied-band request failed |

Runtime logs confirmed these ported branches:

- `AKS Dual-STA: pre-scan CMM ready`
- `AKS Dual-STA: reusing pre-scan secondary CMM for connect`
- `AKS Dual-STA: fresh approved scan match triggered connect`
- `AKS Dual-STA: ignoring primary fallback CMM; keeping pre-scan wlan1`

After the final test, `wlan0` remained on 2.4 GHz and `wlan1` remained on the requested exact 5 GHz BSSID for the observation window. The public module ships without profiles or credentials; use the manager app to add them.

## Package hashes

- `POCO-F7-PixelOS-Exact-Dual-STA-Framework-v1.0.zip`: `4D75F13E4F94D8A7EEB504832A2A414BC02A7E5203B1F1D94942056070C1D4CE`
- `POCO-F7-PixelOS-Exact-Dual-STA-v1.4-public.zip`: `050727B0C9F1CD91642BE0C4C6A10A82129C3F0DCD06A9C7916EF874B522C8AF`

## Rollback

Remove or disable `aks_pixelos_exact_dualsta_wifi` and `onyx_dualsta_overlay`, remove the `disable` marker from `onyx_pixelos_dualsta_overlay`, then reboot. The framework change is a bind mount; it does not overwrite the APEX file.
