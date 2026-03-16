#!/usr/bin/env bash

common_setup() {
  DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" && pwd)"
  PROJECT_ROOT="$(cd "$DIR/.." && pwd)"
}
