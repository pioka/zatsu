#!/bin/bash
set -eu

# Vars
APP_EDITION=$1
APP_VERSION=$2
APP_NAME="minecraft-${APP_EDITION}-server"
APP_DIR="/opt/$APP_NAME"

if [ "$APP_EDITION" != 'je' -a "$APP_EDITION" != 'be' ]; then
  echo 'Invalid edition. select `je` or `be`.'
  exit 1
fi



# Utils
## JE
function _process_je() {
  APP_EXECSTART="/bin/bash -c 'java -jar $APP_DIR/server.jar'"
  APP_EXECSTOP="/bin/bash -c 'echo stop > /var/run/$APP_NAME.stdin'"

  url='http://launchermeta.mojang.com/mc/game/version_manifest.json'
  url=$(curl -fsSL "$url" | jq -r ".versions[] | select(.id==\"${APP_VERSION}\").url")
  url=$(curl -fsSL "$url" | jq -r ".downloads.server.url")
  curl -fsSL "$url" -o $APP_DIR/server.jar
}

## BE
function _process_be() {
  APP_EXECSTART="/bin/bash -c '$APP_DIR/bedrock_server'"
  APP_EXECSTOP="/bin/bash -c 'echo stop > /var/run/$APP_NAME.stdin'"

  url="https://minecraft.azureedge.net/bin-linux/bedrock-server-$APP_VERSION.zip"
  curl -fsSL "$url" -o /opt/$APP_NAME/server.zip
  unzip -n $APP_DIR/server.zip -d $APP_DIR && rm $APP_DIR/server.zip
}



# Main
echo "* Download server binary"
mkdir -p $APP_DIR
_process_${APP_EDITION}

echo "* Install systemd units"
cat << EOS > /etc/systemd/system/$APP_NAME.socket
[Socket]
ListenFIFO=/var/run/$APP_NAME.stdin
RemoveOnStop=true

[Install]
WantedBy=sockets.target
EOS

cat << EOS > /etc/systemd/system/$APP_NAME.service
[Unit]
Requires=$APP_NAME.socket
After=network.target $APP_NAME.socket

[Service]
StandardInput=socket
StandardOutput=journal
StandardError=journal
WorkingDirectory=$APP_DIR
ExecStart=$APP_EXECSTART
ExecStop=$APP_EXECSTOP

[Install]
WantedBy=multi-user.target
EOS

echo "* Run daemon-reload"
systemctl daemon-reload

echo "* Done"
