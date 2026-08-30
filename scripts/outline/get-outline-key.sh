#!/bin/bash

KEY_DIR="$HOME/keys/outline"
KEY_FILE="${KEY_DIR}/${KEY_NAME}.json"
API_FILE="$HOME/outline/outline-api.json"

mkdir -p ${KEY_DIR}
echo "==> [CONFIG] Checking required variables..."
: "${KEY_NAME:?Missing KEY_NAME}"

if [ -z "${API_URL}" ]; then
    if [ ! -f "$API_FILE" ]; then
        echo "[ERROR] API configuration file $API_FILE not found."
        exit 1
    fi
    RAW_API_URL=$(jq -r '.apiUrl' "$API_FILE")
    API_URL=$(echo "$RAW_API_URL" | sed -E 's|https://[^:]+:|https://127.0.0.1:|')
else
    API_URL=$(echo "$API_URL" | sed -E 's|https://[^:]+:|https://127.0.0.1:|')
fi

echo "==> [GENERATE] Generating and naming access key via localhost..."
curl -k -s -X POST "$API_URL/access-keys" > $KEY_FILE
ID=$(jq -r '.id' $KEY_FILE)

curl -k -s -X PUT "$API_URL/access-keys/$ID/name" \
	-d "name=$KEY_NAME"

echo "==> [FETCH] Retrieving updated key data with name..."
curl -k -s -X GET "$API_URL/access-keys/$ID" > "$KEY_FILE"

echo "==> [SUCCESS] ${KEY_NAME} key generated and saved to ${KEY_FILE}"

KEY=$(jq -r '.accessUrl' $KEY_FILE)
echo $KEY

