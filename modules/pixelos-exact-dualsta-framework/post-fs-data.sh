#!/system/bin/sh

MODDIR=${0%/*}
SRC="$MODDIR/service-wifi.jar"
DST=/apex/com.android.wifi/javalib/service-wifi.jar

chown root:root "$SRC"
chmod 0644 "$SRC"
chcon u:object_r:system_file:s0 "$SRC" 2>/dev/null
mount -o bind "$SRC" "$DST"
