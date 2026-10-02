#!/system/bin/sh

until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 2
done

sleep 8
cmd wifi force-country-code enabled US

sleep 3
cmd wifi set-wifi-enabled disabled
sleep 2
cmd wifi set-wifi-enabled enabled
