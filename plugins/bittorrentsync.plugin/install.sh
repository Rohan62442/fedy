#!/bin/bash

if [[ "$(uname -m)" = "x86_64" ]]; then
	ARCH="64"
else
	ARCH="32"
fi

CACHEDIR="$HOME/.cache/fedy/bittorrentsync";

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

mkdir -p "$HOME/.local/share/bittorrent-sync"
mkdir -p "$HOME/.local/bin"
tar -xf "$FILE" -C "$HOME/.local/share/bittorrent-sync"
ln -sf "$HOME/.local/share/bittorrent-sync/btsync" "$HOME/.local/bin/btsync"

cat <<EOF | tee $HOME/.local/share/applications/bittorrent-sync.desktop
[Desktop Entry]
Name=BitTorrent Sync
Icon=bittorrent-sync
Comment=Sync Anything You Want
Exec=bash -c "btsync; xdg-open http://127.0.0.1:8888"
Terminal=false
Type=Application
StartupNotify=true
Categories=Sync;BitTorrent
Keywords=Sync;Files;torrent;BitTorrent
EOF
