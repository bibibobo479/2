#!/bin/bash

# ============================================
# COMPLETE SYSTEM CLEANUP SCRIPT
# Removes ALL: Hyprland, Caelestia, HyDE, themes, configs
# Leaves only pure console
# ============================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_msg() { echo -e "${GREEN}[+]${NC} $1"; }
print_error() { echo -e "${RED}[!]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[*]${NC} $1"; }
print_info() { echo -e "${BLUE}[i]${NC} $1"; }

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    print_error "Do NOT run this script as root!"
    exit 1
fi

echo ""
print_warning "=========================================="
print_warning "COMPLETE SYSTEM CLEANUP"
print_warning "This will remove:"
print_warning "  - All Hyprland packages"
print_warning "  - All Caelestia files"
print_warning "  - All HyDE files and themes"
print_warning "  - All configs and dotfiles"
print_warning "  - All themes and icons"
print_warning "  - All AUR packages"
print_warning "=========================================="
echo ""
read -p "Type YES (all caps) to continue: " confirm

if [[ "$confirm" != "YES" ]]; then
    print_msg "Cancelled"
    exit 0
fi

# ============================================
# 1. REMOVE ALL AUR PACKAGES (HyDE, Caelestia, etc)
# ============================================
print_msg "Removing ALL AUR packages..."

# Get all installed AUR packages and remove them
AUR_PKGS=$(yay -Qqm 2>/dev/null)
if [[ -n "$AUR_PKGS" ]]; then
    for pkg in $AUR_PKGS; do
        print_msg "Removing AUR: $pkg"
        yay -Rns --noconfirm "$pkg" 2>/dev/null
    done
fi

# Force remove specific packages
yay -Rns --noconfirm \
    hyde-git hyde-cli hyde-theme-git \
    caelestia-meta caelestia-shell-git caelestia-cli-git \
    quickshell-git quickshell \
    waybar-hyprland-git wlogout-git swww-git \
    pywal-git wal-git nwg-look nwg-dock nwg-panel \
    adw-gtk-theme papirus-icon-theme \
    2>/dev/null

paru -Rns --noconfirm \
    hyde-git caelestia-meta caelestia-shell-git quickshell-git \
    2>/dev/null

print_msg "AUR packages removed"

# ============================================
# 2. REMOVE OFFICIAL GRAPHICS PACKAGES
# ============================================
print_msg "Removing official graphics packages..."

# Hyprland ecosystem
sudo pacman -Rns --noconfirm \
    hyprland hyprpaper hyprlock hypridle hyprcursor hyprpicker \
    hyprutils hyprlang hyprwayland-scanner \
    waybar wofi rofi rofi-lbonn-wayland \
    dunst mako \
    foot alacritty kitty \
    grim slurp swappy wl-clipboard wlroots \
    xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-hyprland \
    qt5-wayland qt6-wayland qt5ct qt6ct \
    sddm gdm lightdm \
    2>/dev/null

# Other WMs
sudo pacman -Rns --noconfirm \
    sway swaylock swayidle i3-wm bspwm awesome openbox \
    xorg-server xorg-xinit \
    2>/dev/null

print_msg "Official packages removed"

# ============================================
# 3. REMOVE ALL CONFIGURATION FILES
# ============================================
print_msg "Removing all configuration files..."

# Config directories
CONFIG_DIRS=(
    hypr hyde caelestia quickshell
    waybar rofi wofi dunst mako
    foot alacritty kitty wezterm
    gtk-3.0 gtk-4.0 Kvantum qt5ct qt6ct
    wal pywal
    i3 i3status sway bspwm sxhkd awesome openbox xfce4
    thunar pcmanfm nemo ranger
    fish starship fastfetch btop neofetch
    nvim vim
)

for dir in "${CONFIG_DIRS[@]}"; do
    if [[ -d "$HOME/.config/$dir" ]]; then
        print_msg "Removing: ~/.config/$dir"
        rm -rf "$HOME/.config/$dir"
    fi
done

# Remove everything in .config
rm -rf "$HOME/.config"/* 2>/dev/null

# ============================================
# 4. REMOVE CACHE FILES
# ============================================
print_msg "Removing cache files..."

CACHE_DIRS=(
    hypr hyprland hyde caelestia quickshell
    waybar rofi dunst wal pywal
    mesa_shader_cache
)

for dir in "${CACHE_DIRS[@]}"; do
    if [[ -d "$HOME/.cache/$dir" ]]; then
        print_msg "Removing: ~/.cache/$dir"
        rm -rf "$HOME/.cache/$dir"
    fi
done

rm -rf "$HOME/.cache"/* 2>/dev/null

# ============================================
# 5. REMOVE LOCAL DATA
# ============================================
print_msg "Removing local data..."

LOCAL_DIRS=(
    hyde caelestia quickshell hyprland
    wal fonts themes icons
)

for dir in "${LOCAL_DIRS[@]}"; do
    if [[ -d "$HOME/.local/share/$dir" ]]; then
        print_msg "Removing: ~/.local/share/$dir"
        rm -rf "$HOME/.local/share/$dir"
    fi
done

rm -rf "$HOME/.local/share"/* 2>/dev/null
rm -rf "$HOME/.local/bin"/* 2>/dev/null
rm -rf "$HOME/.local/lib"/* 2>/dev/null
rm -rf "$HOME/.local/state"/* 2>/dev/null

# ============================================
# 6. REMOVE USER THEMES AND ICONS (HyDE, Caelestia)
# ============================================
print_msg "Removing user themes and icons..."

# User themes
rm -rf "$HOME/.themes" 2>/dev/null
rm -rf "$HOME/.icons" 2>/dev/null
rm -rf "$HOME/.local/share/themes" 2>/dev/null
rm -rf "$HOME/.local/share/icons" 2>/dev/null

# Remove all theme directories
find "$HOME" -type d -name "*.theme" -exec rm -rf {} + 2>/dev/null
find "$HOME" -type d -name "hyde*" -exec rm -rf {} + 2>/dev/null
find "$HOME" -type d -name "caelestia*" -exec rm -rf {} + 2>/dev/null

# ============================================
# 7. REMOVE SYSTEM THEMES (HyDE, Caelestia) - WITH SUDO
# ============================================
print_msg "Removing system themes (requires sudo)..."

# Remove HyDE themes from system
if [[ -d "/usr/share/themes" ]]; then
    sudo find /usr/share/themes -name "*hyde*" -exec rm -rf {} + 2>/dev/null
    sudo find /usr/share/themes -name "*HyDE*" -exec rm -rf {} + 2>/dev/null
    sudo find /usr/share/themes -name "*caelestia*" -exec rm -rf {} + 2>/dev/null
    sudo find /usr/share/themes -name "*Caelestia*" -exec rm -rf {} + 2>/dev/null
fi

# Remove HyDE icons
if [[ -d "/usr/share/icons" ]]; then
    sudo find /usr/share/icons -name "*hyde*" -exec rm -rf {} + 2>/dev/null
    sudo find /usr/share/icons -name "*HyDE*" -exec rm -rf {} + 2>/dev/null
    sudo find /usr/share/icons -name "*caelestia*" -exec rm -rf {} + 2>/dev/null
fi

# Remove SDDM themes
if [[ -d "/usr/share/sddm/themes" ]]; then
    sudo find /usr/share/sddm/themes -name "*hyde*" -exec rm -rf {} + 2>/dev/null
    sudo find /usr/share/sddm/themes -name "*HyDE*" -exec rm -rf {} + 2>/dev/null
    sudo find /usr/share/sddm/themes -name "*caelestia*" -exec rm -rf {} + 2>/dev/null
fi

# Remove desktop entries
sudo rm -f /usr/share/applications/hyde* 2>/dev/null
sudo rm -f /usr/share/applications/HyDE* 2>/dev/null
sudo rm -f /usr/share/applications/caelestia* 2>/dev/null
sudo rm -f /usr/share/applications/Caelestia* 2>/dev/null

# Remove from /usr/local
if [[ -d "/usr/local/share/themes" ]]; then
    sudo find /usr/local/share/themes -name "*hyde*" -exec rm -rf {} + 2>/dev/null
    sudo find /usr/local/share/themes -name "*caelestia*" -exec rm -rf {} + 2>/dev/null
fi

if [[ -d "/usr/local/share/icons" ]]; then
    sudo find /usr/local/share/icons -name "*hyde*" -exec rm -rf {} + 2>/dev/null
    sudo find /usr/local/share/icons -name "*caelestia*" -exec rm -rf {} + 2>/dev/null
fi

print_msg "System themes removed"

# ============================================
# 8. REMOVE DOTFILES AND DOT DIRECTORIES
# ============================================
print_msg "Removing dotfiles and dot directories..."

# Dotfiles
DOTFILES=(
    .bashrc .bash_profile .profile .zshrc .zprofile
    .xinitrc .xprofile .Xresources .xsession
    .gtkrc-2.0 .gtkrc-3.0
    .face .wallpaper .fehbg
    .gitconfig .gitignore
)

for file in "${DOTFILES[@]}"; do
    rm -f "$HOME/$file" 2>/dev/null
done

# Dot directories
DOT_DIRS=(
    .hyprland .hyde .caelestia
    .gnome .gnome2 .gconf .gconfd
    .kde .kde4
    .mozilla .thunderbird
    .steam .local/share/Steam
    .npm .cargo .rustup .gradle .m2
    .vim .nvim
    .fonts .themes .icons .wallpapers
    .config/hypr .config/hyde .config/caelestia
)

for dir in "${DOT_DIRS[@]}"; do
    if [[ -d "$HOME/$dir" ]]; then
        print_msg "Removing: ~/$dir"
        rm -rf "$HOME/$dir"
    fi
done

# ============================================
# 9. REMOVE CAELESTIA SHELL FILES
# ============================================
print_msg "Removing Caelestia shell files..."

rm -rf "$HOME/.local/share/caelestia" 2>/dev/null
rm -rf "$HOME/.config/caelestia" 2>/dev/null
rm -rf "$HOME/.cache/caelestia" 2>/dev/null
rm -rf "$HOME/.local/bin/caelestia"* 2>/dev/null
rm -f "$HOME/.face" 2>/dev/null

# ============================================
# 10. REMOVE CELESTIA (space simulator)
# ============================================
print_msg "Removing Celestia..."

rm -f "$HOME/.local/bin/celestia.AppImage" 2>/dev/null
rm -f "$HOME/celestia.AppImage" 2>/dev/null
rm -rf "$HOME/Celestia" 2>/dev/null
rm -rf "$HOME/.celestia" 2>/dev/null
rm -rf "$HOME/.config/celestia" 2>/dev/null
rm -f "$HOME/.local/share/applications/celestia.desktop" 2>/dev/null

# ============================================
# 11. REMOVE WALLPAPERS
# ============================================
print_msg "Removing wallpapers..."

rm -rf "$HOME/Pictures/Wallpapers" 2>/dev/null
rm -rf "$HOME/Pictures/wallpapers" 2>/dev/null
rm -rf "$HOME/Wallpapers" 2>/dev/null
rm -rf "$HOME/.wallpapers" 2>/dev/null
rm -rf "$HOME/backgrounds" 2>/dev/null

# ============================================
# 12. DISABLE DISPLAY MANAGERS
# ============================================
print_msg "Disabling display managers..."

sudo systemctl disable sddm 2>/dev/null
sudo systemctl disable gdm 2>/dev/null
sudo systemctl disable lightdm 2>/dev/null
sudo systemctl disable lxdm 2>/dev/null

# ============================================
# 13. CLEAN PACKAGE MANAGER
# ============================================
print_msg "Cleaning package manager..."

sudo pacman -Rns --noconfirm $(pacman -Qdtq) 2>/dev/null
sudo pacman -Scc --noconfirm
yay -Scc --noconfirm 2>/dev/null
paru -Scc --noconfirm 2>/dev/null

# ============================================
# 14. INSTALL CONSOLE ESSENTIALS
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
    man-db man-pages

sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

# ============================================
# 15. CREATE MINIMAL CONSOLE CONFIG
# ============================================
print_msg "Creating minimal console config..."

cat > "$HOME/.bashrc" << 'EOF'
# ~/.bashrc - Minimal config
alias ls='ls --color=auto'
alias ll='ls -la'
alias la='ls -A'
alias ..='cd ..'

PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

export EDITOR=nano
EOF

cat > "$HOME/.profile" << 'EOF'
# ~/.profile
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
EOF

mkdir -p "$HOME/.config"

# ============================================
# 16. VERIFICATION
# ============================================
echo ""
print_warning "=========================================="
print_warning "CLEANUP COMPLETE!"
print_warning "=========================================="

print_info "Checking for remaining HyDE/Caelestia files..."

# Check for remaining HyDE files
HYDE_FILES=$(find "$HOME" -name "*hyde*" -o -name "*HyDE*" 2>/dev/null | head -20)
if [[ -n "$HYDE_FILES" ]]; then
    print_warning "Found remaining HyDE files:"
    echo "$HYDE_FILES"
    print_info "Run: find ~ -name '*hyde*' -exec rm -rf {} + 2>/dev/null"
else
    print_msg "No HyDE files found ✓"
fi

# Check for remaining Caelestia files
CAELESTIA_FILES=$(find "$HOME" -name "*caelestia*" -o -name "*Caelestia*" 2>/dev/null | head -20)
if [[ -n "$CAELESTIA_FILES" ]]; then
    print_warning "Found remaining Caelestia files:"
    echo "$CAELESTIA_FILES"
    print_info "Run: find ~ -name '*caelestia*' -exec rm -rf {} + 2>/dev/null"
else
    print_msg "No Caelestia files found ✓"
fi

# Check for remaining themes
THEMES_COUNT=$(find /usr/share/themes -name "*hyde*" -o -name "*caelestia*" 2>/dev/null | wc -l)
if [[ $THEMES_COUNT -gt 0 ]]; then
    print_warning "Found $THEMES_COUNT remaining system themes"
    print_info "Run: sudo find /usr/share/themes -name '*hyde*' -exec rm -rf {} +"
else
    print_msg "No system themes found ✓"
fi

echo ""
print_info "Config files in ~/.config: $(find ~/.config -type f 2>/dev/null | wc -l)"
print_info "Dotfiles in ~: $(find ~ -maxdepth 1 -name ".*" -type f 2>/dev/null | wc -l)"

echo ""
read -p "Reboot now? (yes/no): " reboot_confirm

if [[ "$reboot_confirm" == "yes" ]]; then
    print_msg "Rebooting..."
    sudo reboot
else
    print_msg "Reboot later with: sudo reboot"
fi
