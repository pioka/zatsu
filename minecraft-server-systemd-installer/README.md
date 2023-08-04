# minecraft-server-systemd-installer
## Usage
Install:

```shell-session
curl https://raw.githubusercontent.com/pioka/zatsu/master/minecraft-server-systemd-installer/install.sh | sudo bash -s je 1.20.1
```

Start server:

```shell
sudo systemctl start minecraft-je-server
```

Uninstall:
```shell
sudo rm -rf /opt/minecraft-je-server /etc/systemd/system/minecraft-je-server.*
```
