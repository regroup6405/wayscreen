#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

curl -sSL https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-linux-amd64 -o /usr/bin/jq && chmod +x /usr/bin/jq
curl -sSL https://github.com/mikefarah/yq/releases/download/v4.48.2/yq_linux_amd64 -o /usr/bin/yq && chmod +x /usr/bin/yq

PIPS=$(cat <<EOF
pulsemixer
streamlink
EOF
)

echo "$PIPS" | while IFS= read -r i; do
    python -m pip install --prefix=/usr "$i"
done
