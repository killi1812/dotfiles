#!/usr/bin/env bash

# Paths and Config
VPN_CLI="/opt/cisco/secureclient/bin/vpn"
VPN_GUI="/opt/cisco/secureclient/bin/vpnui"
TAILSCALE_CLI="/usr/bin/tailscale"
PROTONVPN_CLI="/usr/bin/protonvpn"

INTERFACE="cscotun0"
WAYBAR_SIGNAL=8

is_uib_connected() {
    [ -d "/sys/class/net/$INTERFACE" ]
}

is_uib_connecting() {
    pgrep -x "vpnui" >/dev/null 2>&1
}

is_tailscale_connected() {
    "$TAILSCALE_CLI" status >/dev/null 2>&1
}

is_proton_connected() {
    "$PROTONVPN_CLI" status 2>&1 | grep -q "Status: Connected"
}

is_proton_connecting() {
    "$PROTONVPN_CLI" status 2>&1 | grep -q "Status: Connecting"
}

status_uib() {
    if is_uib_connecting && ! is_uib_connected; then
        printf '{"text":"󰳘 UiB","tooltip":"UiB VPN: Connecting...","class":"connecting"}\n'
    elif is_uib_connected; then
        printf '{"text":"󰛶 UiB","tooltip":"UiB Cisco VPN: Connected","class":"connected"}\n'
    else
        printf '{"text":"󰲛 UiB","tooltip":"UiB Cisco VPN: Disconnected","class":"disconnected"}\n'
    fi
}

status_ts() {
    if is_tailscale_connected; then
        printf '{"text":"󰛶 TS","tooltip":"Tailscale: Connected","class":"connected"}\n'
    else
        printf '{"text":"󰲛 TS","tooltip":"Tailscale: Disconnected","class":"disconnected"}\n'
    fi
}

status_proton() {
    if is_proton_connecting && ! is_proton_connected; then
        printf '{"text":"󰳘 Proton","tooltip":"Proton VPN: Connecting...","class":"connecting"}\n'
    elif is_proton_connected; then
        printf '{"text":"󰛶 Proton","tooltip":"Proton VPN: Connected","class":"connected"}\n'
    else
        printf '{"text":"󰲛 Proton","tooltip":"Proton VPN: Disconnected","class":"disconnected"}\n'
    fi
}

status_global() {
    local vpn_active=""
    local tooltip="VPN Status:\\n"
    
    if is_uib_connecting && ! is_uib_connected; then
        printf '{"text":"󰳘 VPN","tooltip":"UiB VPN: Connecting...","class":"connecting"}\n'
        return
    fi
    
    if is_proton_connecting && ! is_proton_connected; then
        printf '{"text":"󰳘 VPN","tooltip":"Proton VPN: Connecting...","class":"connecting"}\n'
        return
    fi
    
    if is_uib_connected; then
        vpn_active="UiB"
        tooltip+="  󰛶 UiB Cisco VPN: Connected\\n"
    else
        tooltip+="  󰲛 UiB Cisco VPN: Disconnected\\n"
    fi
    
    if is_tailscale_connected; then
        if [ -n "$vpn_active" ]; then vpn_active="Multi"; else vpn_active="TS"; fi
        tooltip+="  󰛶 Tailscale: Connected\\n"
    else
        tooltip+="  󰲛 Tailscale: Disconnected\\n"
    fi
    
    if is_proton_connected; then
        if [ -n "$vpn_active" ]; then vpn_active="Multi"; else vpn_active="Proton"; fi
        tooltip+="  󰛶 Proton VPN: Connected\\n"
    else
        tooltip+="  󰲛 Proton VPN: Disconnected\\n"
    fi
    
    if [ -z "$vpn_active" ]; then
        printf '{"text":"󰲛 VPN","alt":"disconnected","tooltip":"%s","class":"disconnected"}\n' "$tooltip"
    else
        printf '{"text":"󰛶 %s","alt":"connected","tooltip":"%s","class":"connected"}\n' "$vpn_active" "$tooltip"
    fi
}

toggle_uib() {
    if ! is_uib_connected && ! is_uib_connecting; then
        # Ensure only one connected by dropping other VPNs first in background
        "$TAILSCALE_CLI" down >/dev/null 2>&1 &
        "$PROTONVPN_CLI" disconnect >/dev/null 2>&1 &
    fi
    $HOME/.config/waybar/scripts/uib-vpn.sh toggle >/dev/null 2>&1 &
    pkill -RTMIN+"$WAYBAR_SIGNAL" waybar 2>/dev/null
}

toggle_ts() {
    if is_tailscale_connected; then
        "$TAILSCALE_CLI" down >/dev/null 2>&1 &
    else
        # Ensure only one connected by dropping other VPNs first in background
        $HOME/.config/waybar/scripts/uib-vpn.sh disconnect >/dev/null 2>&1 &
        "$PROTONVPN_CLI" disconnect >/dev/null 2>&1 &
        "$TAILSCALE_CLI" up >/dev/null 2>&1 &
    fi
    pkill -RTMIN+"$WAYBAR_SIGNAL" waybar 2>/dev/null
}

toggle_proton() {
    if is_proton_connected; then
        "$PROTONVPN_CLI" disconnect >/dev/null 2>&1 &
    else
        # Ensure only one connected by dropping other VPNs first in background
        $HOME/.config/waybar/scripts/uib-vpn.sh disconnect >/dev/null 2>&1 &
        "$TAILSCALE_CLI" down >/dev/null 2>&1 &
        "$PROTONVPN_CLI" connect >/dev/null 2>&1 &
    fi
    pkill -RTMIN+"$WAYBAR_SIGNAL" waybar 2>/dev/null
}

disconnect_all() {
    $HOME/.config/waybar/scripts/uib-vpn.sh disconnect >/dev/null 2>&1 &
    "$TAILSCALE_CLI" down >/dev/null 2>&1 &
    "$PROTONVPN_CLI" disconnect >/dev/null 2>&1 &
    pkill -RTMIN+"$WAYBAR_SIGNAL" waybar 2>/dev/null
}

case "$1" in
    status_uib) status_uib ;;
    status_ts) status_ts ;;
    status_proton) status_proton ;;
    status_global) status_global ;;
    toggle_uib) toggle_uib ;;
    toggle_ts) toggle_ts ;;
    toggle_proton) toggle_proton ;;
    disconnect) disconnect_all ;;
    *) status_global ;;
esac
