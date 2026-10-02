#!/system/bin/sh
MODDIR=${0%/*}
# Apply the same module policy at boot, including on Magisk variants
# that do not automatically consume a manually staged sepolicy.rule.
magiskpolicy --live --apply "$MODDIR/sepolicy.rule" > "$MODDIR/policy-boot.log" 2>&1
rc=$?
echo "policy_apply_rc=$rc uptime=$(cat /proc/uptime)" >> "$MODDIR/policy-boot.log"
exit "$rc"
