#!/usr/bin/env bats

setup() {
  export PATH="$BATS_TEST_DIRNAME/mocks:$PATH"
  SCRIPT="$BATS_TEST_DIRNAME/../fedoratricks.sh"
}

@test "rpmfusion -h shows command help" {
  run "$SCRIPT" rpmfusion -h
  [ "$status" -eq 0 ]
  [[ "$output" =~ "enable" ]]
  [[ "$output" =~ "disable" ]]
  [[ "$output" =~ "status" ]]
}

@test "rpmfusion defaults to status" {
  run "$SCRIPT" rpmfusion
  [ "$status" -eq 0 ]
  [[ "$output" =~ "RPMFusion" ]]
}

@test "rpmfusion enable shows dnf install command" {
  run "$SCRIPT" rpmfusion enable
  [[ "$output" =~ "dnf install" ]]
}

@test "rpmfusion disable shows dnf config-manager disable command" {
  run "$SCRIPT" rpmfusion disable
  [[ "$output" =~ "dnf config-manager disable" ]]
}

@test "rpmfusion unknown option exits 1" {
  run "$SCRIPT" rpmfusion bogus
  [ "$status" -eq 1 ]
}
