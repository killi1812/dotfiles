#!/bin/bash
# ----------------------------------------------------- 
# Tmux Session Helper for Waybar
# ----------------------------------------------------- 

command_type="$1"
arg="$2"

get_sessions() {
    # Lists sessions as "name:attached"
    tmux list-sessions -F '#S:#{session_attached}' 2>/dev/null
}

case "$command_type" in
    count)
        # Output the total count of tmux sessions
        count=$(tmux list-sessions 2>/dev/null | wc -l)
        if [ "$count" -eq 0 ]; then
            echo '{"text": "", "tooltip": "No active tmux sessions", "class": "empty"}'
        else
            echo "{\"text\": \"  $count\", \"tooltip\": \"$count active tmux session(s) (click to open new)\", \"class\": \"active\"}"
        fi
        ;;
    session)
        # Output JSON status for the session at index $arg (0-indexed)
        idx="$arg"
        session_info=$(get_sessions | sed -n "$((idx + 1))p")
        
        if [ -n "$session_info" ]; then
            name=$(echo "$session_info" | cut -d: -f1)
            attached=$(echo "$session_info" | cut -d: -f2)
            
            if [ "$attached" -eq 1 ]; then
                # Attached session
                echo "{\"text\": \"● $name\", \"tooltip\": \"Session '$name' (Attached, click to connect in new window)\", \"class\": \"attached\"}"
            else
                # Detached session
                echo "{\"text\": \"○ $name\", \"tooltip\": \"Session '$name' (Detached, click to attach)\", \"class\": \"detached\"}"
            fi
        else
            # No session at this index - output empty text/class so waybar hides it
            echo "{\"text\": \"\", \"class\": \"empty\"}"
        fi
        ;;
    attach)
        # Attach to the session at index $arg
        idx="$arg"
        session_info=$(get_sessions | sed -n "$((idx + 1))p")
        if [ -n "$session_info" ]; then
            name=$(echo "$session_info" | cut -d: -f1)
            ghostty -e tmux attach-session -t "$name" &
        fi
        ;;
    new)
        # Open a new tmux session
        ghostty -e tmux &
        ;;
    *)
        echo "Usage: $0 {count|session <idx>|attach <idx>|new}"
        exit 1
        ;;
esac
