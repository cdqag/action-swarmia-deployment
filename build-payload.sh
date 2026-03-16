#!/usr/bin/env bash

build_json_payload() {
  local json

  json=$(jq --null-input --compact-output \
    --arg version "$INPUT_VERSION" \
    --arg appName "$INPUT_APP_NAME" \
    '{"version": $version, "appName": $appName}')

  if [[ -n "${INPUT_ENVIRONMENT:-}" ]]; then
    json=$(echo "$json" | jq --compact-output --arg environment "$INPUT_ENVIRONMENT" '. + {environment: $environment}')
  fi

  if [[ -n "${INPUT_DEPLOYED_AT:-}" ]]; then
    json=$(echo "$json" | jq --compact-output --arg deployedAt "$INPUT_DEPLOYED_AT" '. + {deployedAt: $deployedAt}')
  fi

  if [[ -n "${INPUT_DESCRIPTION:-}" ]]; then
    json=$(echo "$json" | jq --compact-output --arg description "$INPUT_DESCRIPTION" '. + {description: $description}')
  fi

  if [[ -n "${INPUT_COMMIT_SHA:-}" ]]; then
    json=$(echo "$json" | jq --compact-output --arg commitSha "$INPUT_COMMIT_SHA" '. + {commitSha: $commitSha}')
  fi

  if [[ -n "${INPUT_REPOSITORY_FULL_NAME:-}" ]]; then
    json=$(echo "$json" | jq --compact-output --arg repositoryFullName "$INPUT_REPOSITORY_FULL_NAME" '. + {repositoryFullName: $repositoryFullName}')
  fi

  if [[ -n "${INPUT_INCLUDED_COMMIT_SHAS:-}" ]]; then
    json=$(echo "$json" | jq --compact-output --argjson includedCommitShas "$INPUT_INCLUDED_COMMIT_SHAS" '. + {includedCommitShas: $includedCommitShas}')
  fi

  if [[ -n "${INPUT_FILE_PATH_FILTER:-}" ]]; then
    json=$(echo "$json" | jq --compact-output --arg filePathFilter "$INPUT_FILE_PATH_FILTER" '. + {filePathFilter: $filePathFilter}')
  fi

  echo "$json"
}
