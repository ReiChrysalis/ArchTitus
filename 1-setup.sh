#!/usr/bin/env bash
#-------------------------------------------------------------------------
#   █████╗ ██████╗  ██████╗██╗  ██╗████████╗██╗████████╗██╗   ██╗███████╗
#  ██╔══██╗██╔══██╗██╔════╝██║  ██║╚══██╔══╝██║╚══██╔══╝██║   ██║██╔════╝
#  ███████║██████╔╝██║     ███████║   ██║   ██║   ██║   ██║   ██║███████╗
#  ██╔══██║██╔══██╗██║     ██╔══██║   ██║   ██║   ██║   ██║   ██║╚════██║
#  ██║  ██║██║  ██║╚██████╗██║  ██║   ██║   ██║   ██║   ╚██████╔╝███████║
#  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝   ╚═╝    ╚═════╝ ╚══════╝
#-------------------------------------------------------------------------
echo "--------------------------------------"
echo "--          Network Setup           --"
echo "--------------------------------------"
pacman -S networkmanager dhclient --noconfirm --needed
systemctl enable --now NetworkManager
echo "-------------------------------------------------"
echo "Setting up mirrors for optimal download          "
echo "-------------------------------------------------"
pacman -S --noconfirm pacman-contrib curl
pacman -S --noconfirm reflector rsync
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

nc=$(grep -c ^processor /proc/cpuinfo)
echo "You have " $nc" cores."
echo "-------------------------------------------------"
echo "Changing the makeflags for "$nc" cores."
TOTALMEM=$(cat /proc/meminfo | grep -i 'memtotal' | grep -o '[[:digit:]]*')
if [[  $TOTALMEM -gt 8000000 ]]; then
sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=\"-j$nc\"/g" /etc/makepkg.conf
echo "Changing the compression settings for "$nc" cores."
sed -i "s/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T $nc -z -)/g" /etc/makepkg.conf
fi
echo "-------------------------------------------------"
echo "       Setup Language to US and set locale       "
echo "-------------------------------------------------"
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
timedatectl --no-ask-password set-timezone America/Chicago
timedatectl --no-ask-password set-ntp 1
localectl --no-ask-password set-locale LANG="en_US.UTF-8" LC_TIME="en_US.UTF-8"

# Set keymaps
localectl --no-ask-password set-keymap us

# Add sudo no password rights
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

#Add parallel downloading
sed -i 's/^#Para/Para/' /etc/pacman.conf

#Enable multilib
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
pacman -Sy --noconfirm

echo -e "\nInstalling Base System\n"

PKGS=(
'mesa' # Essential Xorg First
'xorg'
'xorg-server'
'xorg-xinit'
'xorg-xwininfo'
'plasma-desktop' # KDE Load second
'plasma-browser-integration'
'plasma-disks'
'plasma-integration'
'plasma-systemmonitor'
'plasma-vault'
'plasma-workspace'
'polkit-kde-agent'
'pipewire' # audio
'pipewire-jack'
'pipewire-pulse'
'ark' # compression
'autoconf' # build
'automake' # build
'base'
'bash-completion'
'bat'
'binutils'
'bison'
'bluedevil'
'bluez'
'bluez-utils'
'breeze'
'breeze-gtk'
'btrfs-progs'
'emacs'
'element-desktop'
'flameshot'
'mpv' # video players
'discover'
'discord'
'dolphin'
'drkonqi'
'dosfstools'
'efibootmgr' # EFI boot
'egl-wayland'
'extra-cmake-modules'
'flex'
'foliate'
'fanficfare'
'firefox'
'fuse2'
'fuse3'
'gamemode'
'gnome-keyring'
'lib32-gamemode'
'gcc'
'gimp' # Photo editing
'git'
'gptfdisk'
'grub'
'gst-libav'
'gst-plugins-good'
'gst-plugins-ugly'
'gwenview'
'jdk-openjdk' # Java 17
'ffmpegthumbs'
'ffmpegthumbnailer'
'kcodecs'
'kcoreaddons'
'kdeplasma-addons'
'kdenlive'
'kde-gtk-config'
'kinfocenter'
'ksshaskpass'
'kwallet-pam'
'kwrited'
'krdc'
'krfb'
'krita'
'kdeconnect'
'kdecoration'
'kdegraphics-mobipocket'
'kdegraphics-thumbnailers'
'icoutils'
'libappimage'
'kdenetwork-filesharing'
'kdialog'
'kipi-plugins'
'kimageformats'
'kmenuedit'
'kfind'
'keditbookmarks'
'kscreen'
'keepassxc'
'konsole'
'kscreen'
'layer-shell-qt'
'libdvdcss'
'libnewt'
'libtool'
'linux-zen'
'linux-firmware'
'linux-zen-headers'
'lsof'
'lib32-vkd3d'
'lib32-vulkan-icd-loader'
'lutris'
'jq'
'm4'
'make'
'milou'
'mpd'
'mpc'
'mcomix'
'man-db'
'neofetch'
'networkmanager'
'ntfs-3g'
'openssh'
'os-prober'
'p7zip'
'pacman-contrib'
'patch'
'packagekit-qt5'
'python-pyinotify'
'pkgconf'
'plasma-nm'
'powerdevil'
'python-pyqt5'
'python-pip'
'ranger'
'scanmem'
'sddm'
'sddm-kcm'
'shntool'
'smartmontools'
'sshfs'
'snapper'
'spectacle'
'steam'
'sudo'
'vkd3d'
'systemsettings'
'unrar'
'unzip'
'ueberzug'
'usbutils'
'neovim'
'wget'
'which'
'wine-staging'
'winetricks'
'xdg-desktop-portal'
'xdg-desktop-portal-kde'
'xdg-user-dirs'
'qbittorrent'
'yakuake'
'youtube-dl'
'zathura-pdf-mupdf'
'zoxide'
'zsh'
'zsh-syntax-highlighting'
'zsh-autosuggestions'
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

#
# determine processor type and install microcode
# 
proc_type=$(lscpu | awk '/Vendor ID:/ {print $3}')
case "$proc_type" in
	GenuineIntel)
		print "Installing Intel microcode"
		pacman -S --noconfirm intel-ucode
		proc_ucode=intel-ucode.img
		;;
	AuthenticAMD)
		print "Installing AMD microcode"
		pacman -S --noconfirm amd-ucode
		proc_ucode=amd-ucode.img
		;;
esac	

# Graphics Drivers find and install
if lspci | grep -E "NVIDIA|GeForce"; then
    pacman -S nvidia --noconfirm --needed
	nvidia-xconfig
elif lspci | grep -E "Radeon"; then
    pacman -S xf86-video-amdgpu --noconfirm --needed
elif lspci | grep -E "Integrated Graphics Controller"; then
    pacman -S libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils --needed --noconfirm
fi

echo -e "\nDone!\n"
if ! source install.conf; then
	read -p "Please enter username:" username
echo "username=$username" >> ${HOME}/rei/install.conf
fi
if [ $(whoami) = "root"  ];
then
    useradd -m -G wheel -s /bin/bash $username 
	passwd $username
	cp -R /root/rei /home/$username/
    chown -R $username: /home/$username/rei
	read -p "Please name your machine:" nameofmachine
	echo $nameofmachine > /etc/hostname
else
	echo "You are already a user proceed with aur installs"
fi

