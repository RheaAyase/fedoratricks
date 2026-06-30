#!/usr/bin/env bats

setup() {
  export PATH="$BATS_TEST_DIRNAME/mocks:$PATH"
  SCRIPT="$BATS_TEST_DIRNAME/../fedoratricks.sh"
}

@test "no arguments shows usage and exits 1" {
  run "$SCRIPT"
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Usage:" ]]
}

@test "--help shows usage and exits 0" {
  run "$SCRIPT" --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Usage:" ]]
}

@test "unknown command exits 1" {
  run "$SCRIPT" unknowncmd
  [ "$status" -eq 1 ]
}

@test "help lists available commands" {
  run "$SCRIPT" --help
  [[ "$output" =~ "logs" ]]
  [[ "$output" =~ "rpmfusion" ]]
}
