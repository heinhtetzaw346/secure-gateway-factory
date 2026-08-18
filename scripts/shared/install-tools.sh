#!/bin/bash

echo "==> [CONFIG] Checking required variables..."
: "${INSTALL_TOOLS:?Missing INSTALL_TOOLS}"

if [ "${INSTALL_TOOLS}" = "true" ]; then
	echo "==> [INSTALL] Installing required tools"
	sudo apt update
	sudo apt install vnstat btop -y
else
	echo "==> [EXIT] Skipping install tools"
	exit 0
fi

echo "==> [SUCCESS] Tools installed successfully"
exit 0
