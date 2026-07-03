#!/bin/bash

INSTALL_FILE="$HOME/ovpn/openvpn-install.sh"
KEY_DIR="$HOME/keys/ovpn"
mkdir -p ${KEY_DIR}

echo "==> [CONFIG] Checking required variables..."
: "${KEY_NAME:?Missing KEY_NAME}"

OVPN_SPLIT_TUNNEL="${OVPN_SPLIT_TUNNEL:-false}"
OVPN_LOCAL_DNS="${OVPN_LOCAL_DNS:-false}"

echo "==> [GENERATE] Generating OVPN client key..."
sudo bash ${INSTALL_FILE} client add ${KEY_NAME} > /dev/null

KEY_FILE="$HOME/${KEY_NAME}.ovpn"

if [ "$OVPN_SPLIT_TUNNEL" = "true" ]; then
    echo "==> [CONFIG] OVPN_SPLIT_TUNNEL is set to true, adding split tunnel config to client file"
    echo "route 10.0.0.0 255.0.0.0 net_gateway" >> "${KEY_FILE}"
    echo "route 172.16.0.0 255.240.0.0 net_gateway" >> "${KEY_FILE}"
    echo "route 192.168.0.0 255.255.0.0 net_gateway" >> "${KEY_FILE}"
fi

if [ "$OVPN_LOCAL_DNS" = "true" ]; then
    echo "==> [CONFIG] OVPN_LOCAL_DNS is set to true, adding local dns config to client file"
    echo 'pull-filter ignore "dhcp-option DNS"' >> ${KEY_FILE}
fi

mv $HOME/${KEY_NAME}.ovpn ${KEY_DIR}

echo "==> [SUCCESS] ${KEY_NAME} key generated moved to ${KEY_DIR}"
