#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/build-payload.sh"

echo "::add-mask::$INPUT_AUTH_HEADER"

JSON_STRING=$(build_json_payload)

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
