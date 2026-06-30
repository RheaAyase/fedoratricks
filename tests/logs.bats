#!/usr/bin/env bats

setup() {
  export PATH="$BATS_TEST_DIRNAME/mocks:$PATH"
  SCRIPT="$BATS_TEST_DIRNAME/../fedoratricks.sh"
  OUTDIR="$(mktemp -d)"
}

teardown() {
  rm -rf "$OUTDIR"
}

@test "logs -h shows command help" {
  run "$SCRIPT" logs -h
  [ "$status" -eq 0 ]
  [[ "$output" =~ "dmesg" ]]
}

@test "logs defaults to current boot" {
  run "$SCRIPT" logs -f "$OUTDIR"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "journalctl -b 0" ]]
}

@test "logs -1 captures last boot" {
  run "$SCRIPT" logs -1 -f "$OUTDIR"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "journalctl -b -1" ]]
}

@test "logs -d captures dmesg" {
  run "$SCRIPT" logs -d -f "$OUTDIR"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "dmesg -H" ]]
}

@test "logs -a captures all sources" {
  run "$SCRIPT" logs -a -f "$OUTDIR"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "dmesg" ]]
  [[ "$output" =~ "journalctl -b 0" ]]
  [[ "$output" =~ "journalctl -b -1" ]]
}

@test "logs unknown option exits 1" {
  run "$SCRIPT" logs --bogus
  [ "$status" -eq 1 ]
}
