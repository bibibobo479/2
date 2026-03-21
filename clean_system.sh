#!/bin/bash

# ============================================
# AGGRESSIVE SYSTEM CLEANUP
# Removes ALL packages related to graphics
# ============================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_msg() { echo -e "${GREEN}[+]${NC} $1"; }
print_error() { echo -e "${RED}[!]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[*]${NC} $1"; }

# Check root
if [[ $EUID -eq 0 ]]; then
    print_error "Do NOT run as root!"
    exit 1
fi

echo ""
print_warning "=========================================="
print_warning "AGGRESSIVE CLEANUP - REMOVES EVERYTHING!"
print_warning "This will remove ALL GUI packages!"
print_warning "=========================================="
echo ""
read -p "Type YES (all caps) to continue: " confirm
if [[ "$confirm" != "YES" ]]; then
    print_msg "Cancelled"
    exit 0
fi

# ============================================
# 1. Remove ALL AUR packages
# ============================================
print_msg "Removing ALL AUR packages..."

# List all installed AUR packages and remove them
yay -Qqm 2>/dev/null | while read pkg; do
    print_msg "Removing AUR: $pkg"
    yay -Rns --noconfirm "$pkg" 2>/dev/null
    paru -Rns --noconfirm "$pkg" 2>/dev/null
done

# Force remove specific packages
yay -Rns --noconfirm --nocheck \
    hyde-git hyde-cli hyde-theme-git \
    caelestia-meta caelestia-shell-git caelestia-cli-git \
    quickshell-git quickshell \
    waybar-hyprland-git wlogout-git swww-git \
    pywal-git wal-git nwg-look nwg-dock nwg-panel \
    celestia-bin celestia-git celestia \
    2>/dev/null

paru -Rns --noconfirm --nocheck \
    hyde-git caelestia-meta caelestia-shell-git \
    quickshell-git 2>/dev/null

# Remove yay and paru themselves (optional)
# yay -Rns --noconfirm yay 2>/dev/null
# paru -Rns --noconfirm paru 2>/dev/null

print_msg "AUR packages removed"

# ============================================
# 2. Remove ALL official graphics packages
# ============================================
print_msg "Removing ALL official graphics packages..."

# Get all packages related to graphics and remove them
PACKAGES_TO_REMOVE=(
    # Hyprland ecosystem
    hyprland hyprland-git hyprpaper hyprlock hypridle hyprcursor
    hyprutils hyprlang hyprwayland-scanner hyprpicker
    # Wayland stuff
    wayland wayland-protocols wayland-utils
    # WMs and compositors
    sway swaylock swayidle swaybg sway-contrib
    i3-wm i3status i3lock i3-gaps
    bspwm sxhkd
    awesome
    openbox obconf
    dwm dmenu st
    qtile
    # Xorg
    xorg-server xorg-xinit xorg-apps xorg-xrandr xorg-xsetroot
    xorg-xbacklight xf86-input-libinput xf86-video-*
    # Panels
    waybar polybar eww lemonbar tint2
    wofi rofi rofi-lbonn-wayland rofi-calc
    # Notifications
    dunst mako notification-daemon
    # Terminals
    foot alacritty kitty wezterm termite st
    # Screenshots
    grim slurp swappy wl-clipboard wlroots
    # Screen management
    wlogout swww mpvpaper
    # Portals
    xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-hyprland
    xdg-desktop-portal-wlr
    # QT and GTK
    qt5-wayland qt6-wayland qt5ct qt6ct
    # File managers
    thunar pcmanfm nemo dolphin ranger vifm
    # Browsers
    firefox chromium brave google-chrome
    # Media
    mpv vlc
    # Themes
    adw-gtk-theme papirus-icon-theme
    # Display managers
    sddm sddm-kcm gdm lightdm lxdm greetd
    # Python stuff
    python-pywal python-wal
    # Celestia
    celestia celestia-data
)

for pkg in "${PACKAGES_TO_REMOVE[@]}"; do
    print_msg "Removing: $pkg"
    sudo pacman -Rns --noconfirm "$pkg" 2>/dev/null
done

# Remove all orphaned packages
print_msg "Removing orphaned packages..."
sudo pacman -Rns --noconfirm $(pacman -Qdtq) 2>/dev/null

print_msg "Official packages removed"

# ============================================
# 3. Kill all user processes
# ============================================
print_msg "Killing all user processes..."

# Kill all graphical sessions
pkill -9 -t tty* 2>/dev/null
pkill -9 Xorg 2>/dev/null
pkill -9 Hyprland 2>/dev/null
pkill -9 sway 2>/dev/null
pkill -9 waybar 2>/dev/null

# Kill all user processes (except current terminal)
kill -9 -1 2>/dev/null

print_msg "Processes killed"

# ============================================
# 4. Remove ALL config files and directories
# ============================================
print_msg "Removing ALL configuration files..."

# Remove all .config directories
rm -rf ~/.config/* 2>/dev/null

# Remove all cache
rm -rf ~/.cache/* 2>/dev/null

# Remove local data
rm -rf ~/.local/share/* 2>/dev/null
rm -rf ~/.local/bin/* 2>/dev/null
rm -rf ~/.local/lib/* 2>/dev/null
rm -rf ~/.local/state/* 2>/dev/null

# Remove all dotfiles
rm -rf ~/.bashrc ~/.bash_profile ~/.profile ~/.zshrc ~/.zprofile 2>/dev/null
rm -rf ~/.xinitrc ~/.xprofile ~/.Xresources ~/.xsession 2>/dev/null
rm -rf ~/.gtkrc* ~/.face ~/.wallpaper ~/.fehbg 2>/dev/null

# Remove all dot directories
rm -rf ~/.hyprland ~/.hyde ~/.caelestia 2>/dev/null
rm -rf ~/.gnome ~/.gnome2 ~/.gconf ~/.gconfd 2>/dev/null
rm -rf ~/.kde ~/.kde4 ~/.config/kde* 2>/dev/null
rm -rf ~/.mozilla ~/.mozilla2 2>/dev/null
rm -rf ~/.thunderbird 2>/dev/null
rm -rf ~/.steam ~/.local/share/Steam 2>/dev/null
rm -rf ~/.npm ~/.node-gyp 2>/dev/null
rm -rf ~/.cargo ~/.rustup 2>/dev/null
rm -rf ~/.gradle ~/.m2 2>/dev/null
rm -rf ~/.cabal ~/.ghc 2>/dev/null
rm -rf ~/.vim ~/.vimrc ~/.nvim ~/.config/nvim 2>/dev/null

# Remove fonts
rm -rf ~/.fonts ~/.local/share/fonts 2>/dev/null

# Remove themes
rm -rf ~/.themes ~/.icons ~/.local/share/themes ~/.local/share/icons 2>/dev/null

# Remove wallpapers
rm -rf ~/Pictures/Wallpapers ~/Pictures/wallpapers 2>/dev/null
rm -rf ~/Wallpapers 2>/dev/null

# Remove Caelestia specific
rm -rf ~/.local/share/caelestia 2>/dev/null
rm -rf ~/.config/caelestia 2>/dev/null
rm -rf ~/.config/quickshell 2>/dev/null
rm -rf ~/.cache/caelestia 2>/dev/null

# Remove Celestia
rm -rf ~/.celestia ~/.config/celestia 2>/dev/null
rm -f ~/.local/bin/celestia.AppImage 2>/dev/null
rm -f ~/celestia.AppImage 2>/dev/null
rm -rf ~/Celestia 2>/dev/null

# Remove any remaining dotfiles
find ~ -maxdepth 1 -type d -name ".*" -not -name "." -not -name ".." -not -name ".local" -not -name ".cache" -not -name ".config" -exec rm -rf {} + 2>/dev/null

print_msg "Config files removed"

# ============================================
# 5. Remove system-level files
# ============================================
print_msg "Removing system-level files..."

# Remove system themes
sudo rm -rf /usr/share/themes/* 2>/dev/null
sudo rm -rf /usr/share/icons/* 2>/dev/null
sudo rm -rf /usr/local/share/themes/* 2>/dev/null
sudo rm -rf /usr/local/share/icons/* 2>/dev/null

# Remove SDDM themes
sudo rm -rf /usr/share/sddm/themes/* 2>/dev/null

# Remove GDM themes
sudo rm -rf /usr/share/gnome-shell/theme/* 2>/dev/null

# Remove desktop entries for installed packages
sudo rm -rf /usr/share/applications/hyde* 2>/dev/null
sudo rm -rf /usr/share/applications/caelestia* 2>/dev/null
sudo rm -rf /usr/share/applications/celestia* 2>/dev/null

# Remove user desktop entries
rm -rf ~/.local/share/applications/hyde* 2>/dev/null
rm -rf ~/.local/share/applications/caelestia* 2>/dev/null
rm -rf ~/.local/share/applications/celestia* 2>/dev/null

print_msg "System files removed"

# ============================================
# 6. Disable all display managers
# ============================================
print_msg "Disabling display managers..."

sudo systemctl disable sddm 2>/dev/null
sudo systemctl disable gdm 2>/dev/null
sudo systemctl disable lightdm 2>/dev/null
sudo systemctl disable lxdm 2>/dev/null
sudo systemctl disable greetd 2>/dev/null

print_msg "Display managers disabled"

# ============================================
# 7. Clean package manager cache
# ============================================
print_msg "Cleaning package manager cache..."

sudo pacman -Scc --noconfirm
yay -Scc --noconfirm 2>/dev/null
paru -Scc --noconfirm 2>/dev/null

# Clean pacman database
sudo pacman -Syy

print_msg "Cache cleaned"

# ============================================
# 8. Install ONLY console essentials
# ============================================
print_msg "Installing console essentials..."

sudo pacman -S --noconfirm --needed \
    base base-devel \
    linux linux-firmware \
    vim nano \
    sudo \
    networkmanager dhcpcd \
    openssh \
    git curl wget \
    htop \
    man-db man-pages \
    tmux \
    neofetch

# Enable network
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

print_msg "Console essentials installed"

# ============================================
# 9. Create minimal console config
# ============================================
print_msg "Creating minimal console config..."

cat > ~/.bashrc << 'EOF'
# ~/.bashrc - Minimal config
alias ls='ls --color=auto'
alias ll='ls -la'
alias la='ls -A'
alias ..='cd ..'

PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

export EDITOR=nano
EOF

cat > ~/.profile << 'EOF'
# ~/.profile
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
EOF

print_msg "Minimal config created"

# ============================================
# 10. Final cleanup
# ============================================
print_msg "Final cleanup..."

# Clear all logs
sudo journalctl --rotate 2>/dev/null
sudo journalctl --vacuum-time=1s 2>/dev/null

# Clear temp
rm -rf /tmp/* 2>/dev/null
rm -rf ~/.cache/* 2>/dev/null

# Sync
sync

print_msg "Final cleanup done"

# ============================================
# Done
# ============================================
echo ""
print_warning "=========================================="
print_warning "CLEANUP COMPLETE!"
print_warning "=========================================="
print_info "All GUI packages and configs have been removed"
print_info "You are now in a minimal console environment"
echo ""
print_info "To check what's still installed:"
print_info "  pacman -Q | grep -E 'hypr|wayland|xorg|sway|i3|gtk|qt'"
echo ""
read -p "Reboot now? (yes/no): " reboot_confirm

if [[ "$reboot_confirm" == "yes" ]]; then
    print_msg "Rebooting..."
    sudo reboot
else
    print_msg "Reboot later with: sudo reboot"
fi
