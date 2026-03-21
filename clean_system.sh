#!/bin/bash

# ============================================
# COMPLETE HYPRLAND + CAELESTIA + CELESTIA INSTALLATION
# For Arch Linux based systems
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

# Проверка запуска от пользователя (не root)
if [[ $EUID -eq 0 ]]; then
    print_error "Do NOT run this script as root!"
    exit 1
fi

# Подтверждение
echo ""
print_warning "=========================================="
print_warning "THIS SCRIPT WILL INSTALL:"
print_warning "  - Hyprland (Wayland compositor)"
print_warning "  - Caelestia Dots & Shell"
print_warning "  - Celestia (space simulator)"
print_warning "  - All required dependencies"
print_warning "=========================================="
echo ""
read -p "Continue? (yes/no): " confirm

if [[ "$confirm" != "yes" ]]; then
    print_msg "Cancelled"
    exit 0
fi

# ============================================
# 1. UPDATE SYSTEM
# ============================================
print_msg "Updating system..."
sudo pacman -Syu --noconfirm

# ============================================
# 2. INSTALL YAY (AUR helper)
# ============================================
print_msg "Installing yay (AUR helper)..."

if ! command -v yay &> /dev/null; then
    sudo pacman -S --noconfirm --needed git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/yay
else
    print_msg "yay already installed"
fi

# ============================================
# 3. INSTALL HYPRLAND (official version)
# ============================================
print_msg "Installing Hyprland (official version)..."

# Установка Hyprland из официального репозитория [citation:7]
sudo pacman -S --noconfirm hyprland hyprpaper hyprlock hypridle hyprpicker

# ============================================
# 4. INSTALL CORE DEPENDENCIES
# ============================================
print_msg "Installing core dependencies..."

# Основные зависимости для Hyprland и Wayland [citation:6][citation:9]
sudo pacman -S --noconfirm --needed \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk \
    waybar \
    wofi \
    rofi \
    dunst \
    grim \
    slurp \
    swappy \
    wl-clipboard \
    cliphist \
    bluez-utils \
    blueman \
    network-manager-applet \
    inotify-tools \
    wireplumber \
    pipewire \
    pipewire-pulse \
    alsa-utils \
    brightnessctl \
    ddcutil \
    lm_sensors \
    pamixer \
    pavucontrol \
    libqalculate \
    aubio \
    cava \
    app2unit \
    trash-cli \
    imagemagick \
    jq \
    socat \
    curl \
    wget \
    git \
    base-devel

# ============================================
# 5. INSTALL TERMINAL AND SHELL
# ============================================
print_msg "Installing terminal and shell..."

# Установка foot и fish [citation:6]
sudo pacman -S --noconfirm --needed \
    foot \
    fish \
    fastfetch \
    starship \
    btop \
    zsh \
    lsd \
    bat

# Установка oh-my-zsh (опционально) [citation:4]
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    print_msg "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# ============================================
# 6. INSTALL FONTS AND THEMES
# ============================================
print_msg "Installing fonts and themes..."

# Nerd fonts [citation:6][citation:9]
sudo pacman -S --noconfirm --needed \
    ttf-jetbrains-mono-nerd \
    ttf-meslo-nerd \
    ttf-fira-code \
    noto-fonts \
    noto-fonts-emoji

# GTK themes and icons [citation:6]
sudo pacman -S --noconfirm --needed \
    adw-gtk-theme \
    papirus-icon-theme \
    breeze-gtk-theme

# Установка Material Symbols
yay -S --noconfirm ttf-material-symbols-variable

# ============================================
# 7. INSTALL QT CONFIGURATION
# ============================================
print_msg "Installing Qt configuration..."

sudo pacman -S --noconfirm --needed \
    qt5-wayland \
    qt6-wayland \
    qt5ct \
    qt6ct

# ============================================
# 8. INSTALL CAELESTIA COMPONENTS
# ============================================
print_msg "Installing Caelestia components..."

# Установка quickshell из AUR [citation:3][citation:9]
yay -S --noconfirm quickshell-git

# Установка caelestia-cli из AUR
yay -S --noconfirm caelestia-cli-git

# Установка caelestia-meta (все зависимости) [citation:6]
yay -S --noconfirm caelestia-meta

# Установка caelestia-shell [citation:9]
yay -S --noconfirm caelestia-shell-git

# ============================================
# 9. INSTALL CAELESTIA DOTS (CONFIGS)
# ============================================
print_msg "Installing Caelestia Dots..."

CAELESTIA_DIR="$HOME/.local/share/caelestia"

if [[ -d "$CAELESTIA_DIR" ]]; then
    print_warning "Caelestia directory already exists"
    read -p "Remove and reinstall? (yes/no): " reinstall
    if [[ "$reinstall" == "yes" ]]; then
        rm -rf "$CAELESTIA_DIR"
        INSTALL_DOTS="true"
    else
        INSTALL_DOTS="false"
    fi
else
    INSTALL_DOTS="true"
fi

if [[ "$INSTALL_DOTS" == "true" ]]; then
    git clone https://github.com/caelestia-dots/caelestia.git "$CAELESTIA_DIR"
    cd "$CAELESTIA_DIR"
    
    # Запуск установочного скрипта [citation:6]
    if command -v fish &> /dev/null; then
        fish install.fish --noconfirm --zen --vscode=codium
    else
        print_error "Fish shell not found. Installing..."
        sudo pacman -S --noconfirm fish
        fish install.fish --noconfirm --zen --vscode=codium
    fi
    
    cd ~
    print_msg "Caelestia Dots installed"
fi

# ============================================
# 10. INSTALL CELESTIA (SPACE SIMULATOR)
# ============================================
print_msg "Installing Celestia (space simulator)..."

# Создание директории для бинарных файлов
mkdir -p "$HOME/.local/bin"

# Скачивание последней версии Celestia AppImage [citation:2][citation:8]
CELESTIA_URL="https://github.com/ivan-hc/Celestia-appimage/releases/download/continuous/Celestia-qt6-x86_64.AppImage"
CELESTIA_PATH="$HOME/.local/bin/celestia.AppImage"

print_msg "Downloading Celestia AppImage..."
wget -O "$CELESTIA_PATH" "$CELESTIA_URL"

chmod +x "$CELESTIA_PATH"

# Создание desktop entry [citation:5]
mkdir -p "$HOME/.local/share/applications"
cat > "$HOME/.local/share/applications/celestia.desktop" << EOF
[Desktop Entry]
Name=Celestia
Comment=3D Space Visualization
Exec=$HOME/.local/bin/celestia.AppImage
Icon=celestia
Terminal=false
Type=Application
Categories=Education;Science;Astronomy;
Keywords=space;planet;star;universe;astronomy;
EOF

# Загрузка иконки
ICON_PATH="$HOME/.local/share/icons/celestia.png"
mkdir -p "$HOME/.local/share/icons"
wget -O "$ICON_PATH" "https://raw.githubusercontent.com/CelestiaProject/Celestia/main/logo/celestia.png" 2>/dev/null

print_msg "Celestia installed"

# ============================================
# 11. CREATE CAELESTIA CONFIGURATION
# ============================================
print_msg "Creating Caelestia configuration..."

mkdir -p "$HOME/.config/caelestia"
mkdir -p "$HOME/Pictures/Wallpapers"

# Создание конфигурации shell [citation:9]
cat > "$HOME/.config/caelestia/shell.json" << 'EOF'
{
    "bar": {
        "workspaces": {
            "activeIndicator": true,
            "showWindows": true,
            "shown": 5
        }
    },
    "dashboard": {
        "mediaUpdateInterval": 500,
        "visualiserBars": 45
    },
    "launcher": {
        "actionPrefix": ">",
        "maxShown": 8,
        "maxWallpapers": 9
    },
    "notifs": {
        "defaultExpireTimeout": 5000,
        "expire": false
    },
    "osd": {
        "hideDelay": 2000
    },
    "paths": {
        "wallpaperDir": "~/Pictures/Wallpapers"
    }
}
EOF

# Создание файла для аватара [citation:3]
touch "$HOME/.face"

# ============================================
# 12. CREATE HYPRLAND CONFIGURATION
# ============================================
print_msg "Creating Hyprland configuration..."

mkdir -p "$HOME/.config/hypr"

# Базовая конфигурация Hyprland (если не установлена Caelestia Dots)
if [[ ! -f "$HOME/.config/hypr/hyprland.conf" ]]; then
    cat > "$HOME/.config/hypr/hyprland.conf" << 'EOF'
# Hyprland Configuration

# Monitor
monitor=,preferred,auto,1

# Startup
exec-once = waybar & dunst & caelestia shell

# Input
input {
    kb_layout = us
    kb_variant =
    follow_mouse = 1
    touchpad {
        natural_scroll = false
    }
}

# General
general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)
    layout = dwindle
}

# Decoration
decoration {
    rounding = 10
    blur {
        enabled = true
        size = 3
        passes = 1
    }
    drop_shadow = true
    shadow_range = 4
}

# Animations
animations {
    enabled = true
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    animation = windows, 1, 7, myBezier
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

# Keybinds
$mainMod = SUPER

bind = $mainMod, Q, exec, foot
bind = $mainMod, C, killactive,
bind = $mainMod, M, exit,
bind = $mainMod, V, togglefloating,
bind = $mainMod, R, exec, wofi --show drun
bind = $mainMod, L, exec, hyprlock
bind = $mainMod, SPACE, exec, caelestia launcher

# Workspaces
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

# Move windows to workspaces
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10

# Media keys
bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
bind = , XF86AudioPlay, exec, playerctl play-pause
bind = , XF86AudioNext, exec, playerctl next
bind = , XF86AudioPrev, exec, playerctl previous

# Brightness
bind = , XF86MonBrightnessUp, exec, brightnessctl s +10%
bind = , XF86MonBrightnessDown, exec, brightnessctl s 10%-
EOF
fi

# ============================================
# 13. CONFIGURE FISH SHELL
# ============================================
print_msg "Configuring fish shell..."

# Установка fish как shell по умолчанию
if [[ "$SHELL" != "/usr/bin/fish" ]]; then
    print_info "Changing default shell to fish..."
    chsh -s /usr/bin/fish
fi

# Создание конфигурации fish
mkdir -p "$HOME/.config/fish"
cat > "$HOME/.config/fish/config.fish" << 'EOF'
# Fish configuration for Caelestia

# Starship prompt
starship init fish | source

# Aliases
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'

# PATH
set -gx PATH $HOME/.local/bin $PATH

# Environment
set -gx EDITOR nvim
set -gx BROWSER firefox

# Welcome message
fastfetch
EOF

# ============================================
# 14. CONFIGURE STARSHIP PROMPT
# ============================================
print_msg "Configuring starship prompt..."

mkdir -p "$HOME/.config"
cat > "$HOME/.config/starship.toml" << 'EOF'
# Starship configuration

add_newline = true

[character]
success_symbol = "[➜](bold green)"
error_symbol = "[✗](bold red)"

[directory]
style = "bold blue"
truncation_length = 3

[git_branch]
symbol = "🌿 "
style = "bold purple"

[git_status]
style = "yellow"

[package]
style = "bold yellow"

[nodejs]
style = "bold green"

[rust]
style = "bold red"

[time]
disabled = false
time_format = "%H:%M"
style = "bold white"
EOF

# ============================================
# 15. ENABLE SERVICES
# ============================================
print_msg "Enabling system services..."

# Включение Bluetooth
sudo systemctl enable bluetooth 2>/dev/null

# Включение NetworkManager
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

# ============================================
# 16. FINAL SETUP
# ============================================
print_msg "Performing final setup..."

# Создание дополнительных директорий
mkdir -p "$HOME/Pictures/Screenshots"
mkdir -p "$HOME/Videos"
mkdir -p "$HOME/Music"

# Копирование примера wallpaper (если есть)
if [[ -f "/usr/share/backgrounds/default.png" ]]; then
    cp "/usr/share/backgrounds/default.png" "$HOME/Pictures/Wallpapers/default.png" 2>/dev/null
fi

# ============================================
# 17. VERIFICATION
# ============================================
echo ""
print_warning "=========================================="
print_warning "INSTALLATION COMPLETE!"
print_warning "=========================================="
echo ""

print_msg "Installed components:"
print_info "  ✓ Hyprland (Wayland compositor)"
print_info "  ✓ Caelestia Dots & Shell"
print_info "  ✓ Celestia (space simulator)"
print_info "  ✓ Fish shell with starship prompt"

echo ""
print_info "Directories:"
print_info "  Wallpapers: ~/Pictures/Wallpapers"
print_info "  Profile picture: ~/.face"
print_info "  Caelestia config: ~/.config/caelestia/"

echo ""
print_info "Keybinds:"
print_info "  Super         - Open launcher"
print_info "  Super + T     - Open terminal (foot)"
print_info "  Super + W     - Open browser (Zen)"
print_info "  Super + C     - Open IDE (VSCodium)"
print_info "  Super + #     - Switch workspace"
print_info "  Ctrl+Alt+Del  - Session menu"

echo ""
print_info "Celestia (space simulator):"
print_info "  Run: ~/.local/bin/celestia.AppImage"
print_info "  Or find in application menu"

echo ""
print_warning "To start Hyprland:"
print_info "  1. Log out of current session"
print_info "  2. Login from TTY (console)"
print_info "  3. Run: Hyprland"
print_info "  Or install a display manager (SDDM, GDM)"

echo ""
read -p "Reboot now? (yes/no): " reboot_confirm

if [[ "$reboot_confirm" == "yes" ]]; then
    print_msg "Rebooting..."
    sudo reboot
else
    print_msg "Reboot later with: sudo reboot"
fi
