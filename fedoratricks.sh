#!/bin/bash

# shellcheck disable=SC2329
set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR

# The master list of all available fedoratricks modules
COMMANDS=("logs" "multimedia" "rpmfusion" "nvidia")

# shellcheck disable=SC1083
COMMAND_DIR="$(rpm -E %{_datarootdir})/fedoratricks"
if [[ $(readlink -f -- "$0") == *"${HOME}"* ]]; then
    COMMAND_DIR="$(dirname -- "$(readlink -f -- "$0")")/commands"
    echo "Using user directory, this is for development purposes only:"
    echo "${COMMAND_DIR}"
fi
if [[ ! -d "${COMMAND_DIR}" ]]; then
    echo "Plugins not found in: ${COMMAND_DIR}"
fi

args=()

# Source all command modules (including hidden ones to leave code there)
for cmd in "${COMMANDS[@]}" "secureboot" "template"; do
    if [[ -f "${COMMAND_DIR}/${cmd}" ]]; then
        # shellcheck source=/dev/null
        source "${COMMAND_DIR}/${cmd}"
    fi
done

help() {
    cat <<EOF
Usage: fedoratricks <command> [options]

Global options:
-h|--help   Print the help text and exit.
            Use -h with each command to learn what options they have.

Available commands:
EOF

    for cmd in "${COMMANDS[@]}"; do
        echo "  ${cmd}"
    done

    if [[ ${#args[@]} -ne 0 ]]; then
        echo ""

        if [[ " ${COMMANDS[*]} " != *" ${args[0]} "* ]]; then
            echo "Unknown command: ${args[0]}"
            exit 1
        fi

        "${args[0]}"Help
    fi
}

# Parse global arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
    -h | --help)
        help
        exit 0
        ;;
    -v | --value)
        # shellcheck disable=SC2034
        exampleValue="$2"
        shift 2
        ;;
    -b | --boolean)
        # shellcheck disable=SC2034
        exampleBool=true
        shift
        ;;
    *)
        args+=("$1")
        shift
        ;;
    esac
done

if [[ ${#args[@]} -eq 0 ]]; then
    help
    exit 1
fi

if [[ " ${COMMANDS[*]} " != *" ${args[0]} "* ]]; then
    echo "Unknown command: ${args[0]}"
    exit 1
fi

# Execute the specific module and pass all remaining arguments to it
"${args[0]}"Execute "${args[@]:1}"

cleanup() {
    trap - SIGINT SIGTERM ERR EXIT
    if [[ ${#args[@]} -ne 0 ]]; then
        echo ""

        if [[ " ${COMMANDS[*]} " != *" ${args[0]} "* ]]; then
            "${args[0]}"Cleanup
        fi
    fi
}

exit 0
