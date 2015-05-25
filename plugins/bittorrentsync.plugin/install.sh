#!/bin/bash

if [[ "$(uname -m)" = "x86_64" ]]; then
	ARCH="64"
else
	ARCH="32"
fi

CACHEDIR="/var/cache/fedy/bittorrentsync";

mkdir -p "$CACHEDIR"
cd "$CACHEDIR"

if [[ $ARCH = "64" ]]; then
URL="http://download.getsyncapp.com/endpoint/btsync/os/linux-x64/track/stable"
FILE="bittorrent_sync_x64.tar.gz"
else
URL="http://download.getsyncapp.com/endpoint/btsync/os/linux-i386/track/stable"
FILE="bittorrent_sync_i386.tar.gz"
fi

wget -c "$URL" -O "$FILE"

if [[ ! -f "$FILE" ]]; then
	exit 1
fi

mkdir -p "/opt/bittorrent-sync"
tar -xf "$FILE" -C "/opt/bittorrent-sync"
ln -sf "/opt/bittorrent-sync/btsync" "/usr/bin/btsync"

btsync --dump-sample-config > /etc/btsync.conf
systemctl enable btsync
systemctl start btsync

cat <<EOF | tee /usr/share/applications/bittorrent-sync.desktop
[Desktop Entry]
Name=BitTorrent Sync
Icon=btsync-user
Comment=Sync Anything You Want
Exec=xdg-open http://127.0.0.1:8888
Terminal=false
Type=Application
StartupNotify=true
Categories=Sync;BitTorrent
Keywords=Sync;Files;torrent;BitTorrent
EOF
