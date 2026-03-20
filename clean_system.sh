#!/bin/bash

# ============================================
# System Cleanup Script - Remove ALL GUI
# WARNING! This will remove ALL graphical environments
# ============================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_msg() {
    echo -e "${GREEN}[+]${NC} $1"
}

print_error() {
    echo -e "${RED}[!]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[*]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    print_error "Do NOT run this script as root!"
    exit 1
fi

# First confirmation
echo ""
print_warning "=========================================="
print_warning "THIS SCRIPT WILL REMOVE ALL GUI!"
print_warning "You will be left with only console (tty)"
print_warning "=========================================="
echo ""
read -p "Are you sure you want to continue? (yes/no): " confirm

if [[ "$confirm" != "yes" ]]; then
    print_msg "Operation cancelled"
    exit 0
fi

# Second confirmation with CAPITAL
echo ""
read -p "Type YES (all caps) to confirm: " final_confirm

if [[ "$final_confirm" != "YES" ]]; then
    print_msg "Operation cancelled"
    exit 0
fi

# Create backup
print_msg "Creating backup in ~/backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p ~/backup_$(date +%Y%m%d_%H%M%S)
cp -r ~/.bashrc ~/backup_$(date +%Y%m%d_%H%M%S)/ 2>/dev/null
cp -r ~/.zshrc ~/backup_$(date +%Y%m%d_%H%M%S)/ 2>/dev/null
cp -r ~/.config ~/backup_$(date +%Y%m%d_%H%M%S)/ 2>/dev/null

# ============================================
# 1. Remove Celestia
# ============================================
print_msg "Removing Celestia..."

sudo pacman -Rns --noconfirm celestia 2>/dev/null
yay -Rns --noconfirm celestia-bin celestia-git 2>/dev/null
paru -Rns --noconfirm celestia-bin celestia-git 2>/dev/null
rm -f ~/celestia.AppImage 2>/dev/null
rm -rf ~/Celestia 2>/dev/null
rm -rf ~/.celestia 2>/dev/null
rm -rf ~/.config/celestia 2>/dev/null

print_msg "Celestia removed"

# ============================================
# 2. Remove Hyprland and all WMs
# ============================================
print_msg "Removing Hyprland and Window Managers..."

# Hyprland components
sudo pacman -Rns --noconfirm hyprland hyprpaper hyprlock hypridle hyprcursor \
  hyprutils hyprlang hyprwayland-scanner 2>/dev/null

# Panels and launchers
sudo pacman -Rns --noconfirm waybar wofi rofi polybar \
  eww nwg-dock nwg-panel 2>/dev/null

# Notifications
sudo pacman -Rns --noconfirm dunst mako 2>/dev/null

# Screenshot tools
sudo pacman -Rns --noconfirm grim slurp swappy wl-clipboard \
  wlogout swww 2>/dev/null

# Terminals
sudo pacman -Rns --noconfirm foot alacritty kitty wezterm \
  st termite 2>/dev/null

# Wayland portal
sudo pacman -Rns --noconfirm xdg-desktop-portal-hyprland \
  xdg-desktop-portal-gtk 2>/dev/null

# Qt GTK Wayland
sudo pacman -Rns --noconfirm qt5-wayland qt6-wayland \
  qt5ct qt6ct 2>/dev/null

# Other Window Managers
sudo pacman -Rns --noconfirm i3-wm i3status i3lock \
  sway swaylock swayidle swaybg \
  bspwm sxhkd \
  awesome \
  openbox obconf \
  xfce4 xfce4-goodies \
  gnome gnome-extra \
  plasma-desktop plasma-meta \
  cinnamon 2>/dev/null

print_msg "Window Managers removed"

# ============================================
# 3. Remove AUR packages
# ============================================
print_msg "Removing AUR packages..."

# HyDE
yay -Rns --noconfirm hyde-git hyde-cli hyde-theme-git 2>/dev/null
paru -Rns --noconfirm hyde-git hyde-cli 2>/dev/null

# Caelestia
yay -Rns --noconfirm caelestia-meta caelestia-shell-git \
  caelestia-cli-git quickshell-git 2>/dev/null
paru -Rns --noconfirm caelestia-meta caelestia-shell-git \
  caelestia-cli-git quickshell-git 2>/dev/null

# Other
yay -Rns --noconfirm nwg-look waybar-hyprland-git wlogout-git \
  swww-git pywal-git wal-steam-git 2>/dev/null
paru -Rns --noconfirm nwg-look waybar-hyprland-git 2>/dev/null

print_msg "AUR packages removed"

# ============================================
# 4. Remove Display Managers
# ============================================
print_msg "Removing Display Managers..."

sudo pacman -Rns --noconfirm sddm sddm-kcm 2>/dev/null
sudo systemctl disable sddm 2>/dev/null
sudo pacman -Rns --noconfirm gdm 2>/dev/null
sudo systemctl disable gdm 2>/dev/null
sudo pacman -Rns --noconfirm lightdm lightdm-gtk-greeter 2>/dev/null
sudo systemctl disable lightdm 2>/dev/null
sudo pacman -Rns --noconfirm lxdm 2>/dev/null
sudo systemctl disable lxdm 2>/dev/null

print_msg "Display Managers removed"

# ============================================
# 5. Remove all config files
# ============================================
print_msg "Removing configuration files..."

rm -rf ~/.config/* 2>/dev/null
rm -rf ~/.cache/* 2>/dev/null
rm -rf ~/.local/share/* 2>/dev/null
rm -rf ~/.local/bin/* 2>/dev/null
rm -rf ~/.local/lib/* 2>/dev/null

rm -f ~/.bashrc 2>/dev/null
rm -f ~/.zshrc 2>/dev/null
rm -f ~/.profile 2>/dev/null
rm -f ~/.bash_profile 2>/dev/null
rm -f ~/.xinitrc 2>/dev/null
rm -f ~/.xprofile 2>/dev/null
rm -f ~/.Xresources 2>/dev/null
rm -f ~/.gtkrc-* 2>/dev/null
rm -f ~/.face 2>/dev/null
rm -f ~/.wallpaper 2>/dev/null
rm -f ~/.fehbg 2>/dev/null

rm -rf ~/.hyprland 2>/dev/null
rm -rf ~/.hyde 2>/dev/null
rm -rf ~/.caelestia 2>/dev/null
rm -rf ~/.gnome 2>/dev/null
rm -rf ~/.kde 2>/dev/null

print_msg "Configuration files removed"

# ============================================
# 6. Remove system themes and icons
# ============================================
print_msg "Removing themes and icons..."

sudo rm -rf /usr/share/themes/* 2>/dev/null
sudo rm -rf /usr/share/icons/* 2>/dev/null
sudo rm -rf /usr/share/sddm/themes/* 2>/dev/null
sudo rm -rf /usr/share/gnome-shell/theme/* 2>/dev/null
sudo rm -rf /usr/local/share/themes/* 2>/dev/null
sudo rm -rf /usr/local/share/icons/* 2>/dev/null

print_msg "Themes and icons removed"

# ============================================
# 7. Clean package manager
# ============================================
print_msg "Cleaning package manager..."

sudo pacman -Rns --noconfirm $(pacman -Qdtq) 2>/dev/null
sudo pacman -Scc --noconfirm 2>/dev/null
yay -Scc --noconfirm 2>/dev/null
paru -Scc --noconfirm 2>/dev/null

print_msg "Package manager cleaned"

# ============================================
# 8. Install basic console utilities
# ============================================
print_msg "Installing basic console utilities..."

sudo pacman -S --noconfirm --needed base base-devel \
  linux linux-firmware \
  vim nano \
  sudo networkmanager dhcpcd \
  alsa-utils pipewire pipewire-pulse \
  openssh git curl wget \
  htop neofetch 2>/dev/null

print_msg "Basic utilities installed"

# ============================================
# 9. Create clean configs
# ============================================
print_msg "Creating clean configuration files..."

cat > ~/.bashrc << 'EOF'
# ~/.bashrc
alias ls='ls --color=auto'
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'

PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

export EDITOR=nano

HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
EOF

cat > ~/.profile << 'EOF'
# ~/.profile
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
EOF

cat > ~/.bash_logout << 'EOF'
# ~/.bash_logout
clear
EOF

print_msg "Configs created"

# ============================================
# 10. Setup network
# ============================================
print_msg "Setting up network..."

sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

print_msg "Network configured"

# ============================================
# 11. Final cleanup
# ============================================
print_msg "Final cleanup..."

rm -rf ~/.cache/* 2>/dev/null
rm -rf ~/.local/share/Trash/* 2>/dev/null
rm -rf /tmp/* 2>/dev/null
sync

print_msg "Cleanup finished"

# ============================================
# Done
# ============================================
echo ""
print_warning "=========================================="
print_warning "SCRIPT FINISHED!"
print_warning "=========================================="
print_info "Backup saved in: ~/backup_$(ls -t ~/ 2>/dev/null | grep backup_ | head -1)"
print_info "After reboot you will be in console (tty)"
echo ""
read -p "Reboot now? (yes/no): " reboot_confirm

if [[ "$reboot_confirm" == "yes" ]]; then
    print_msg "Rebooting..."
    sudo reboot
else
    print_msg "Reboot cancelled. Run 'sudo reboot' later"
fi
