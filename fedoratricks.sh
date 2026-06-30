#!/bin/bash

set -x
set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR

COMMANDS=("template" "logs" "rpmfusion")

COMMAND_DIR="$(rpm -E '%{_datarootdir}')/fedoratricks"
if [[ $(readlink -f -- "$0") == *"${HOME}"* ]]; then
  COMMAND_DIR="$(dirname -- "$(readlink -f -- "$0")")/commands"
  echo "Using user directory, this is for development purposes only:"
  echo "${COMMAND_DIR}"
fi
if [[ ! -d ${COMMAND_DIR} ]]; then
  echo "Plugins not found in: ${COMMAND_DIR}"
fi

args=()

for cmd in "${COMMANDS[@]}" ; do
  # shellcheck disable=SC1090
  source "${COMMAND_DIR}/${cmd}"
done

help() {
  cat <<EOF
Usage: fedoratricks <command> [options]

Global options:
-h|--help   Print the help text and exit.
            Use -h with each command to learn what options they have.

Available commands:
EOF

  for cmd in "${COMMANDS[@]}" ; do
    echo "$cmd"
  done

  if [[ ${#args[@]} != 0 ]]; then
    echo ""

    if [[ ! ${COMMANDS[*]} =~ ${args[0]} ]]; then
      echo "Unknown command: ${args[0]}"
      exit 1
    fi

    "${args[0]}Help"
  fi
}

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      help
      exit 0
      ;;
    -v|--value)
      exampleValue="$2"
      printf 'value: %s\n' "${exampleValue}"
      shift 2
      ;;
    -b|--boolean)
      exampleBool=true
      printf 'boolean: %s\n' "${exampleBool}"
      shift
      ;;
    *)
      args+=("$1")
      shift
      ;;
  esac
done

if [[ ${#args[@]} == 0 ]]; then
  help
  exit 1
fi

if [[ ! ${COMMANDS[*]} =~ ${args[0]} ]]; then
  echo Unknown command.
  exit 1
fi

"${args[0]}Execute" "${args[@]:1}"

# shellcheck disable=SC2329
cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  if [[ ${#args[@]} != 0 ]]; then
    echo ""

    if [[ ! ${COMMANDS[*]} =~ ${args[0]} ]]; then
      "${args[0]}Cleanup"
    fi
  fi

}

exit 0
