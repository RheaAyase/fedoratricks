#!/bin/bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR



