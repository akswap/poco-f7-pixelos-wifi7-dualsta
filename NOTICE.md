# Notice

The Xiaomi/Infinity-X X2 hostapd package contains device-specific vendor binaries and associated NDK libraries. They are included only to reproduce the tested POCO F7 interoperability setup. Their original licenses and ownership remain with their respective vendors and projects.

The PixelOS exact Dual-STA framework package is built from the matching device's PixelOS `service-wifi.jar` and is ROM-build specific.

The published patched `init_boot` is based on the matching official PixelOS onyx `20260920_1714` image. It contains Magisk components and a Dual-STA preload carrying `qca_cld3_wcn7750-dualsta.ko`. The module reports `license=Dual BSD/GPL`, author `Qualcomm Atheros, Inc.`, and kernel vermagic `6.6.142-4k-gd0881fd79058`. Magisk and the module remain subject to their upstream licenses and ownership. The unmodified official stock `init_boot` is included only as the exact rollback image for this build.
