# Kali Linux Custom ISO – XFCE Panel Enhancer

This repository contains a custom Kali Linux ISO builder configuration that includes:
- A full-featured XFCE panel customization script for hacking/OSINT workflows
- Desktop launcher integration
- XFCE panel backup/restore automation

## How to Build

```bash
git clone https://gitlab.com/kalilinux/build-scripts/live-build-config.git
cd live-build-config
# Merge this repository's `config/` directory into it
sudo ./build.sh --variant xfce
```

## Script Location

The script is installed at:

```bash
/usr/local/bin/panel-xfce-kali.sh
```

And a desktop launcher is available by default in the XFCE desktop.

## Credits
Crafted whit DazkaOni$✳️Offensive Security
