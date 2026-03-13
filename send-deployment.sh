#!/usr/bin/env bash
set -euo pipefail

echo "::add-mask::$INPUT_AUTH_HEADER"

JSON_STRING=$(jq --null-input --compact-output \
  --arg version "$INPUT_VERSION" \
  --arg appName "$INPUT_APP_NAME" \
  '{"version": $version, "appName": $appName}')

if [[ -n "$INPUT_ENVIRONMENT" ]]; then
  JSON_STRING=$(echo "$JSON_STRING" | jq --compact-output --arg environment "$INPUT_ENVIRONMENT" '. + {environment: $environment}')
fi

if [[ -n "$INPUT_DEPLOYED_AT" ]]; then
  JSON_STRING=$(echo "$JSON_STRING" | jq --compact-output --arg deployedAt "$INPUT_DEPLOYED_AT" '. + {deployedAt: $deployedAt}')
fi

if [[ -n "$INPUT_DESCRIPTION" ]]; then
  JSON_STRING=$(echo "$JSON_STRING" | jq --compact-output --arg description "$INPUT_DESCRIPTION" '. + {description: $description}')
fi

if [[ -n "$INPUT_COMMIT_SHA" ]]; then
  JSON_STRING=$(echo "$JSON_STRING" | jq --compact-output --arg commitSha "$INPUT_COMMIT_SHA" '. + {commitSha: $commitSha}')
fi

if [[ -n "$INPUT_REPOSITORY_FULL_NAME" ]]; then
  JSON_STRING=$(echo "$JSON_STRING" | jq --compact-output --arg repositoryFullName "$INPUT_REPOSITORY_FULL_NAME" '. + {repositoryFullName: $repositoryFullName}')
fi

if [[ -n "$INPUT_INCLUDED_COMMIT_SHAS" ]]; then
  JSON_STRING=$(echo "$JSON_STRING" | jq --compact-output --argjson includedCommitShas "$INPUT_INCLUDED_COMMIT_SHAS" '. + {includedCommitShas: $includedCommitShas}')
fi

if [[ -n "$INPUT_FILE_PATH_FILTER" ]]; then
  JSON_STRING=$(echo "$JSON_STRING" | jq --compact-output --arg filePathFilter "$INPUT_FILE_PATH_FILTER" '. + {filePathFilter: $filePathFilter}')
fi

echo "Sending deployment to Swarmia API..."
echo "Payload: $JSON_STRING"

HTTP_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
  --header @<(echo "Authorization: $INPUT_AUTH_HEADER") \
  -H "Content-Type: application/json" \
  -d "$JSON_STRING" \
  "https://hook.swarmia.com/deployments")

HTTP_CODE=$(echo "$HTTP_RESPONSE" | tail -n1)
BODY=$(echo "$HTTP_RESPONSE" | sed '$d')

if [[ "$HTTP_CODE" -ge 400 ]]; then
  echo "::error::Swarmia Deployment API returned HTTP $HTTP_CODE: $BODY"
  exit 1
fi

echo "Deployment sent successfully (HTTP $HTTP_CODE): $BODY"
