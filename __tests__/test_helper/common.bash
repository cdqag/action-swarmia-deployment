#!/usr/bin/env bash

common_setup() {
  DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" && pwd)"
  PROJECT_ROOT="$(cd "$DIR/.." && pwd)"

  export INPUT_VERSION=""
  export INPUT_APP_NAME=""
  export INPUT_ENVIRONMENT=""
  export INPUT_DEPLOYED_AT=""
  export INPUT_DESCRIPTION=""
  export INPUT_COMMIT_SHA=""
  export INPUT_REPOSITORY_FULL_NAME=""
  export INPUT_INCLUDED_COMMIT_SHAS=""
  export INPUT_FILE_PATH_FILTER=""
  export INPUT_AUTH_HEADER=""
}
