#!/usr/bin/env bash

VPN_CLI="/opt/cisco/secureclient/bin/vpn"
VPN_GUI="/opt/cisco/secureclient/bin/vpnui"
INTERFACE="cscotun0"
WAYBAR_SIGNAL=8
MAX_POLL_SECONDS=30 # Safety timeout

is_connected() {
    [ -d "/sys/class/net/$INTERFACE" ]
}

is_connecting() {
    pgrep -f "vpnui" >/dev/null 2>&1
}

status() {
    if is_connected; then
        printf '{"text":"󰛶 UiB","alt":"connected","tooltip":"UiB VPN: Connected","class":"connected"}\n'
    elif is_connecting; then
        printf '{"text":"󰳘 UiB","alt":"connecting","tooltip":"UiB VPN: Connecting...","class":"connecting"}\n'
    else
        printf '{"text":"󰲛 UiB","alt":"disconnected","tooltip":"UiB VPN: Disconnected","class":"disconnected"}\n'
    fi
}

connect_worker() {
    # 1. Spawn the GUI process in background
    "$VPN_GUI" >/dev/null 2>&1 &
    local gui_pid=$!

    # 2. Tell Waybar we are now in 'connecting' state
    pkill -RTMIN+"$WAYBAR_SIGNAL" waybar 2>/dev/null

    # 3. Poll every 250ms until connection interface appears or timeout occurs
    local count=0
    local max_iterations=$((MAX_POLL_SECONDS * 4))

    while [ "$count" -lt "$max_iterations" ]; do
        if is_connected; then
            # Connected! Kill GUI subprocess immediately
            kill "$gui_pid" 2>/dev/null || pkill -f vpnui 2>/dev/null
            pkill -RTMIN+"$WAYBAR_SIGNAL" waybar 2>/dev/null
            exit 0
        fi
        sleep 0.25
        count=$((count + 1))
    done

    # Timeout safety: Kill GUI if connection failed/cancelled
    kill "$gui_pid" 2>/dev/null || pkill -f vpnui 2>/dev/null
    pkill -RTMIN+"$WAYBAR_SIGNAL" waybar 2>/dev/null
}

connect_vpn() {
    # Fork the polling worker so Waybar remains non-blocking
    connect_worker &
}

disconnect_vpn() {
    "$VPN_CLI" disconnect >/dev/null 2>&1
    pkill -f vpnui 2>/dev/null
    pkill -RTMIN+"$WAYBAR_SIGNAL" waybar 2>/dev/null
}

toggle() {
    if is_connected; then
        disconnect_vpn
    elif is_connecting; then
        # If clicked while connecting, abort/cancel
        pkill -f vpnui 2>/dev/null
        pkill -RTMIN+"$WAYBAR_SIGNAL" waybar 2>/dev/null
    else
        connect_vpn
    fi
}

case "$1" in
    status) status ;;
    connect) connect_vpn ;;
    disconnect) disconnect_vpn ;;
    toggle) toggle ;;
    *) status ;;
esac
