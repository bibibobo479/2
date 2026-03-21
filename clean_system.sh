#!/bin/bash

# ============================================
# COMPLETE CONFIGURATION REMOVAL SCRIPT
# Removes ALL configs: Hyprland, Caelestia, HyDE, Celestia, etc.
# ============================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_msg() { echo -e "${GREEN}[+]${NC} $1"; }
print_error() { echo -e "${RED}[!]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[*]${NC} $1"; }

echo ""
print_warning "=========================================="
print_warning "COMPLETE CONFIGURATION REMOVAL"
print_warning "This will delete ALL config files for:"
print_warning "  - Hyprland"
print_warning "  - Caelestia Dots & Shell"
print_warning "  - HyDE"
print_warning "  - Celestia"
print_warning "  - Waybar, Rofi, Dunst, Foot, Kitty"
print_warning "  - GTK, QT, Kvantum"
print_warning "  - And more..."
print_warning "=========================================="
echo ""
read -p "Type YES to continue: " confirm

if [[ "$confirm" != "YES" ]]; then
    print_msg "Cancelled"
    exit 0
fi

# ============================================
# 1. DELETE ALL CONFIG DIRECTORIES
# ============================================
print_msg "Deleting all config directories..."

CONFIG_DIRS=(
    # Hyprland & Caelestia
    "hypr"
    "hyde"
    "caelestia"
    "quickshell"
    
    # Panels & Launchers
    "waybar"
    "rofi"
    "polybar"
    "eww"
    "nwg-dock"
    "nwg-panel"
    "wofi"
    
    # Notifications
    "dunst"
    "mako"
    
    # Terminals
    "foot"
    "alacritty"
    "kitty"
    "wezterm"
    "termite"
    "st"
    
    # GTK & QT
    "gtk-3.0"
    "gtk-4.0"
    "Kvantum"
    "qt5ct"
    "qt6ct"
    
    # Themes & Colors
    "wal"
    "wpg"
    "pywal"
    
    # Other WMs (if any)
    "i3"
    "i3status"
    "sway"
    "bspwm"
    "sxhkd"
    "awesome"
    "openbox"
    "xfce4"
    
    # File managers
    "thunar"
    "pcmanfm"
    "nemo"
    "ranger"
    
    # Other apps
    "fish"
    "starship"
    "fastfetch"
    "btop"
    "neofetch"
    "mpv"
    "nvim"
    "vim"
)

for dir in "${CONFIG_DIRS[@]}"; do
    if [[ -d "$HOME/.config/$dir" ]]; then
        print_msg "Removing: ~/.config/$dir"
        rm -rf "$HOME/.config/$dir"
    fi
done

# Remove all remaining files in .config (just in case)
print_msg "Cleaning any remaining files in ~/.config..."
rm -rf "$HOME/.config"/* 2>/dev/null

# ============================================
# 2. DELETE CACHE DIRECTORIES
# ============================================
print_msg "Deleting cache directories..."

CACHE_DIRS=(
    "hyprland"
    "hypr"
    "hyde"
    "caelestia"
    "quickshell"
    "waybar"
    "rofi"
    "dunst"
    "wal"
    "pywal"
    "mesa_shader_cache"
)

for dir in "${CACHE_DIRS[@]}"; do
    if [[ -d "$HOME/.cache/$dir" ]]; then
        print_msg "Removing: ~/.cache/$dir"
        rm -rf "$HOME/.cache/$dir"
    fi
done

# Remove all remaining cache
rm -rf "$HOME/.cache"/* 2>/dev/null

# ============================================
# 3. DELETE LOCAL DATA DIRECTORIES
# ============================================
print_msg "Deleting local data directories..."

LOCAL_DIRS=(
    "hyde"
    "caelestia"
    "quickshell"
    "hyprland"
    "wal"
    "fonts"
    "themes"
    "icons"
)

for dir in "${LOCAL_DIRS[@]}"; do
    if [[ -d "$HOME/.local/share/$dir" ]]; then
        print_msg "Removing: ~/.local/share/$dir"
        rm -rf "$HOME/.local/share/$dir"
    fi
done

# Remove all remaining local share
rm -rf "$HOME/.local/share"/* 2>/dev/null

# Remove local bin
rm -rf "$HOME/.local/bin"/* 2>/dev/null
rm -rf "$HOME/.local/lib"/* 2>/dev/null
rm -rf "$HOME/.local/state"/* 2>/dev/null

# ============================================
# 4. DELETE DOTFILES IN HOME DIRECTORY
# ============================================
print_msg "Deleting dotfiles in home directory..."

DOTFILES=(
    ".bashrc"
    ".bash_profile"
    ".profile"
    ".zshrc"
    ".zprofile"
    ".xinitrc"
    ".xprofile"
    ".Xresources"
    ".xsession"
    ".gtkrc-2.0"
    ".gtkrc-3.0"
    ".face"
    ".wallpaper"
    ".fehbg"
    ".gitconfig"
    ".gitignore"
    ".npmrc"
    ".wgetrc"
    ".tmux.conf"
    ".vimrc"
    ".nanorc"
)

for file in "${DOTFILES[@]}"; do
    if [[ -f "$HOME/$file" ]]; then
        print_msg "Removing: ~/$file"
        rm -f "$HOME/$file"
    fi
done

# ============================================
# 5. DELETE DOT DIRECTORIES IN HOME
# ============================================
print_msg "Deleting dot directories in home directory..."

DOT_DIRS=(
    ".hyprland"
    ".hyde"
    ".caelestia"
    ".gnome"
    ".gnome2"
    ".gconf"
    ".kde"
    ".kde4"
    ".mozilla"
    ".thunderbird"
    ".steam"
    ".npm"
    ".cargo"
    ".rustup"
    ".gradle"
    ".m2"
    ".cabal"
    ".ghc"
    ".vim"
    ".nvim"
    ".fonts"
    ".themes"
    ".icons"
    ".wallpapers"
)

for dir in "${DOT_DIRS[@]}"; do
    if [[ -d "$HOME/$dir" ]]; then
        print_msg "Removing: ~/$dir"
        rm -rf "$HOME/$dir"
    fi
fi

# ============================================
# 6. DELETE CELESTIA SPECIFIC FILES
# ============================================
print_msg "Deleting Celestia files..."

# Celestia AppImage
rm -f "$HOME/.local/bin/celestia.AppImage" 2>/dev/null
rm -f "$HOME/celestia.AppImage" 2>/dev/null

# Celestia source
rm -rf "$HOME/Celestia" 2>/dev/null

# Celestia configs
rm -rf "$HOME/.celestia" 2>/dev/null
rm -rf "$HOME/.config/celestia" 2>/dev/null

# Celestia desktop entry
rm -f "$HOME/.local/share/applications/celestia.desktop" 2>/dev/null
rm -f "$HOME/.local/share/applications/caelestia"* 2>/dev/null

# ============================================
# 7. DELETE SYSTEM-LEVEL FILES (requires sudo)
# ============================================
print_msg "Deleting system-level files (requires sudo)..."

# Remove user-installed themes
if [[ -d "/usr/share/themes" ]]; then
    sudo rm -rf /usr/share/themes/hyde* 2>/dev/null
    sudo rm -rf /usr/share/themes/caelestia* 2>/dev/null
fi

# Remove user-installed icons
if [[ -d "/usr/share/icons" ]]; then
    sudo rm -rf /usr/share/icons/hyde* 2>/dev/null
    sudo rm -rf /usr/share/icons/caelestia* 2>/dev/null
fi

# Remove SDDM themes
if [[ -d "/usr/share/sddm/themes" ]]; then
    sudo rm -rf /usr/share/sddm/themes/hyde* 2>/dev/null
    sudo rm -rf /usr/share/sddm/themes/caelestia* 2>/dev/null
fi

# Remove desktop entries
sudo rm -f /usr/share/applications/hyde* 2>/dev/null
sudo rm -f /usr/share/applications/caelestia* 2>/dev/null
sudo rm -f /usr/share/applications/celestia* 2>/dev/null

# ============================================
# 8. DELETE WALLPAPERS AND MEDIA
# ============================================
print_msg "Deleting wallpapers and media..."

rm -rf "$HOME/Pictures/Wallpapers" 2>/dev/null
rm -rf "$HOME/Pictures/wallpapers" 2>/dev/null
rm -rf "$HOME/Wallpapers" 2>/dev/null
rm -rf "$HOME/.wallpapers" 2>/dev/null

# ============================================
# 9. CREATE MINIMAL CLEAN CONFIGS
# ============================================
print_msg "Creating minimal clean configs..."

# Minimal .bashrc
cat > "$HOME/.bashrc" << 'EOF'
# ~/.bashrc - Minimal
alias ls='ls --color=auto'
alias ll='ls -la'
alias la='ls -A'
alias ..='cd ..'

PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

export EDITOR=nano
EOF

# Minimal .profile
cat > "$HOME/.profile" << 'EOF'
# ~/.profile
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
EOF

# Minimal .config directory (clean)
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share"

# ============================================
# 10. VERIFICATION
# ============================================
echo ""
print_warning "=========================================="
print_warning "REMOVAL COMPLETE!"
print_warning "=========================================="

print_msg "Checking remaining configs..."

# Check remaining in .config
CONFIG_COUNT=$(find "$HOME/.config" -type f 2>/dev/null | wc -l)
print_msg "Files remaining in ~/.config: $CONFIG_COUNT"

# Check remaining dotfiles
DOTFILE_COUNT=$(find "$HOME" -maxdepth 1 -name ".*" -type f 2>/dev/null | wc -l)
print_msg "Dotfiles remaining in ~: $DOTFILE_COUNT"

echo ""
print_info "If you still see files, run this command:"
print_info "  find ~/.config -type f -name \"*hypr*\" -o -name \"*caelestia*\" -o -name \"*hyde*\""
print_info "  find ~ -maxdepth 1 -name \".*\" | grep -E \"hypr|caelestia|hyde\""

echo ""
read -p "Reboot now? (yes/no): " reboot_confirm

if [[ "$reboot_confirm" == "yes" ]]; then
    print_msg "Rebooting..."
    sudo reboot
else
    print_msg "Reboot later with: sudo reboot"
fi
