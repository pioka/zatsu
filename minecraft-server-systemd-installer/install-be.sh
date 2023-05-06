#!/bin/bash
set -eu

APP_NAME='minecraft-be-server'
SERVER_VERSION=$1

echo "* Download server binary"
mkdir -p /opt/$APP_NAME
curl -fsSL "https://minecraft.azureedge.net/bin-linux/bedrock-server-$SERVER_VERSION.zip" -o /opt/$APP_NAME/server.zip
unzip /opt/$APP_NAME/server.zip -d /opt/$APP_NAME
rm /opt/$APP_NAME/server.zip

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
Description=Minecraft BE Server
Requires=$APP_NAME.socket
After=network.target $APP_NAME.socket

[Service]
StandardInput=socket
StandardOutput=journal
StandardError=journal
WorkingDirectory=/opt/$APP_NAME
ExecStart=/bin/bash -c '/opt/$APP_NAME/bedrock_server'
ExecStop=/bin/bash -c 'echo stop > /var/run/$APP_NAME.stdin'

[Install]
WantedBy=multi-user.target
EOS

echo "* Run daemon-reload"
systemctl daemon-reload

echo "* Done"
