#!/usr/bin/env bash
#-------------------------------------------------------------------------
#   █████╗ ██████╗  ██████╗██╗  ██╗████████╗██╗████████╗██╗   ██╗███████╗
#  ██╔══██╗██╔══██╗██╔════╝██║  ██║╚══██╔══╝██║╚══██╔══╝██║   ██║██╔════╝
#  ███████║██████╔╝██║     ███████║   ██║   ██║   ██║   ██║   ██║███████╗
#  ██╔══██║██╔══██╗██║     ██╔══██║   ██║   ██║   ██║   ██║   ██║╚════██║
#  ██║  ██║██║  ██║╚██████╗██║  ██║   ██║   ██║   ██║   ╚██████╔╝███████║
#  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝   ╚═╝    ╚═════╝ ╚══════╝
#-------------------------------------------------------------------------

echo -e "\nINSTALLING AUR SOFTWARE\n"
# You can solve users running this script as root with this and then doing the same for the next for statement. However I will leave this up to you.

echo "CLONING: PARU"
cd ~
git clone "https://aur.archlinux.org/paru.git"
cd ${HOME}/yay
makepkg -si --noconfirm
cd ~

PKGS=(
'lightly-git'
'cbonsai'
'dust-git'
'fluent-reader-bin'
'gotop'
'gtk3-nocsd-git'
'imgbrd-grabber'
'kotatogram-desktop-bin'
'kwin-bismuth'
'latte-dock-git'
'logmein-hamachi'
'logo-ls'
'mailspring'
'mpdris2'
'ncmpcpp-git'
'pfetch'
'plasma5-applets-virtual-desktop-bar-git'
'protontricks'
'samrewritten-git'
'spaceship-prompt-git'
'spotify'
'trackma'
'zsh-fast-syntax-highlighting-git'
'noto-fonts-emoji'
'plasma-pa'
'snapper-gui-git'
)

for PKG in "${PKGS[@]}"; do
    yay -S --noconfirm $PKG
done

export PATH=$PATH:~/.local/bin
cp -r $HOME/ArchTitus/dotfiles/* $HOME/.config/
pip install konsave
konsave -i $HOME/ArchTitus/kde.knsv
sleep 1
konsave -a kde

echo -e "\nDone!\n"
exit
