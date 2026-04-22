#!/usr/bin/env bash
# t7810-low-latency tuned profile script

. /usr/lib/tuned/functions

start() {
    echo "t7810-low-latency: checking platform posture..."

    BIOS_VER=$(cat /sys/class/dmi/id/bios_version 2>/dev/null)
    if [ "$BIOS_VER" = "A02" ]; then
        echo "t7810-low-latency: WARNING: BIOS $BIOS_VER detected -- A34 is preferred"
    else
        echo "t7810-low-latency: BIOS version: $BIOS_VER"
    fi

    if grep -q PREEMPT_RT /boot/config-$(uname -r) 2>/dev/null; then
        echo "t7810-low-latency: PREEMPT_RT kernel detected"
    elif zcat /proc/config.gz 2>/dev/null | grep -q PREEMPT_RT; then
        echo "t7810-low-latency: PREEMPT_RT kernel detected"
    else
        echo "t7810-low-latency: WARNING: non-RT kernel"
    fi

    for cpu in /sys/devices/system/cpu/cpu*/watchdog; do
        [ -f "$cpu" ] && echo 0 > "$cpu" 2>/dev/null
    done

    for gov in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
        [ -f "$gov" ] && echo performance > "$gov" 2>/dev/null
    done

    echo "t7810-low-latency: clocksource: $(cat /sys/devices/system/clocksource/clocksource0/current_clocksource)"
    return 0
}

stop() {
    return 0
}

process "$@"
