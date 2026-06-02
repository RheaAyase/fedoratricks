#!/bin/bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR

help() {
  cat <<EOF
Usage: fedoratricks [-h]

Global options:
-h   Print the help text and exit.

Commands:
  todo - iterate over commands and print their help text

Use -h with each command to learn what options they have.
EOF
  exit 0
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # todo - clean up based on what command was executed
  echo Squeeeeky clean.
}

# todo - load commands from elsewhere, aka modules or plugins
# todo - create a specification for what those should look like

# todo - parse arguments and execute a command (or print help)
# todo - temporary help output since there is nothing better to do
help


exit 0
