#!/usr/bin/bash

progress() {
    local msg=$1
    shift
    local log_file=${PROGRESS_LOG_FILE:-progress.log}
    local start_line=0

    [[ -f "$log_file" ]] && start_line=$(wc -l <"$log_file")

    # append separator if needed
    if [[ -s "$log_file" ]]; then
        printf '\n' >> "$log_file"
        ((start_line++))  # account for separator line
    fi

    exec 4>/dev/tty 2>/dev/null || exec 4>&1

    cleanup() {
        tput rmcup >&4 2>/dev/null || true
        tput cnorm >&4 2>/dev/null || true
    }
    trap cleanup EXIT TERM HUP

    tput smcup >&4 2>/dev/null || true
    tput civis >&4 2>/dev/null || true

    "$@" >>"$log_file" 2>&1 &
    local cmd_pid=$!
    local spin='-\|/' i=0

    while kill -0 "$cmd_pid" 2>/dev/null; do
        printf '\e[H\e[2J' >&4
        printf '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n' >&4
        tail -n +"$((start_line + 1))" "$log_file" 2>/dev/null | tail -n 5 >&4
        printf '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n' >&4
        printf ' [%c] %s\n' "${spin:i++%${#spin}:1}" "$msg" >&4
        sleep 0.1
    done

    wait "$cmd_pid"
    local status=$?

    cleanup
    trap - EXIT TERM HUP

    if (( status != 0 )); then
        printf '✖ failed (%d)\n' "$status"
    else
        printf '✓ done\n'
    fi

    return "$status"
}

output1() {
    echo 1; sleep 0.5
    echo 2; sleep 0.5
    echo 3; sleep 0.5
    echo 4; sleep 0.5
    echo 5; sleep 0.5
    echo 6; sleep 0.5
    echo done >&2; sleep 0.5
    return 0
}

progress "something is happening..." output1
