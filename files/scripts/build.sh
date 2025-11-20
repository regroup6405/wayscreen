#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -ouex pipefail

DESKTOP_TYPE="$(cat /etc/desktoptype)"
DESKTOP_ENV="$(cat /etc/desktopenv)"
USERNAME="ryan"

SDDM_CONF=$(cat <<EOF
[Autologin]
Session=${DESKTOP_ENV}
User=${USERNAME}
[General]
DisplayServer=${DESKTOP_TYPE}
EOF
)

echo "${SDDM_CONF}" > /etc/sddm.conf

ln -sf /usr/lib/systemd/system/sddm.service /etc/systemd/system/display-manager.service

curl -sSL https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-linux-amd64 -o /usr/bin/jq && chmod +x /usr/bin/jq
curl -sSL https://github.com/mikefarah/yq/releases/download/v4.48.2/yq_linux_amd64 -o /usr/bin/yq && chmod +x /usr/bin/yq
curl -sSL https://github.com/KaranGauswami/socks-to-http-proxy/releases/download/v0.5.0/sthp-linux -o /usr/bin/sthp && chmod +x /usr/bin/sthp

CHROME_VERSION="$(google-chrome-stable --version | rev | awk '{print $1}' | rev)"

curl -sSL "https://storage.googleapis.com/chrome-for-testing-public/${CHROME_VERSION}/linux64/chromedriver-linux64.zip" -o chromedriver-linux64.zip \
  && unzip chromedriver-linux64.zip \
  && mv chromedriver-linux64/chromedriver /usr/bin/chromedriver \
  && chmod +x /usr/bin/chromedriver \
  && rm -rf chromedriver-linux64

PIPS=$(cat <<EOF
pulsemixer
python-mpv
selenium
streamlink
EOF
)

echo "$PIPS" | sort | while IFS= read -r i; do
    python -m pip install --prefix=/usr "$i"
done

find /usr/bin -iname "*.sh" -type f | sort | while IFS= read -r i; do
  chmod +x "$i"
done
