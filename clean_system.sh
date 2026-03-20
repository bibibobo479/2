#!/bin/bash

# ============================================
# Caelestia + Celestia Installation Script
# Полная установка с нуля
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

# Confirmation
echo ""
print_warning "=========================================="
print_warning "THIS SCRIPT WILL INSTALL:"
print_warning "- Hyprland + all dependencies"
print_warning "- Caelestia Dots (main configs)"
print_warning "- Caelestia Shell (widgets & panel)"
print_warning "- Celestia (space simulator)"
print_warning "=========================================="
echo ""
read -p "Continue? (yes/no): " confirm

if [[ "$confirm" != "yes" ]]; then
    print_msg "Operation cancelled"
    exit 0
fi

# Update system
print_msg "Updating system..."
sudo pacman -Syu --noconfirm

# ============================================
# 1. Install yay (AUR helper)
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
# 2. Install Hyprland and core dependencies
# ============================================
print_msg "Installing Hyprland and core dependencies..."

sudo pacman -S --noconfirm --needed \
    hyprland \
    hyprpaper \
    hyprlock \
    hypridle \
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
    foot \
    alacritty \
    fish \
    fastfetch \
    starship \
    btop \
    jq \
    socat \
    imagemagick \
    curl \
    wget \
    git \
    base-devel \
    brightnessctl \
    ddcutil \
    lm-sensors \
    libqalculate \
    app2unit \
    aubio \
    qt6-base \
    qt6-declarative \
    python \
    python-pip \
    thunar \
    pcmanfm \
    nemo \
    firefox \
    chromium

print_msg "Core dependencies installed"

# ============================================
# 3. Install AUR dependencies
# ============================================
print_msg "Installing AUR dependencies..."

# Themes and fonts
yay -S --noconfirm \
    adw-gtk-theme \
    papirus-icon-theme \
    ttf-jetbrains-mono-nerd \
    ttf-material-symbols-variable \
    caskaydia-cove-nerd-font \
    nwg-look

# Caelestia components
yay -S --noconfirm \
    quickshell-git \
    caelestia-cli-git \
    caelestia-meta

print_msg "AUR dependencies installed"

# ============================================
# 4. Install Caelestia Shell
# ============================================
print_msg "Installing Caelestia Shell..."

# Check if already installed
if yay -Q caelestia-shell-git &> /dev/null; then
    print_msg "Caelestia Shell already installed"
else
    yay -S --noconfirm caelestia-shell-git
fi

print_msg "Caelestia Shell installed"

# ============================================
# 5. Install Caelestia Dots (main configs)
# ============================================
print_msg "Installing Caelestia Dots..."

CAELESTIA_DIR="$HOME/.local/share/caelestia"

if [[ -d "$CAELESTIA_DIR" ]]; then
    print_warning "Caelestia directory already exists"
    read -p "Remove and reinstall? (yes/no): " reinstall
    if [[ "$reinstall" == "yes" ]]; then
        rm -rf "$CAELESTIA_DIR"
    else
        print_msg "Skipping Caelestia Dots installation"
        INSTALL_DOTS=false
    fi
fi

if [[ "$INSTALL_DOTS" != "false" ]]; then
    git clone https://github.com/caelestia-dots/caelestia.git "$CAELESTIA_DIR"
    cd "$CAELESTIA_DIR"
    
    # Run install script with fish
    if command -v fish &> /dev/null; then
        fish install.fish --noconfirm --zen --discord --vscode=codium
    else
        print_error "Fish shell not found. Installing..."
        sudo pacman -S --noconfirm fish
        fish install.fish --noconfirm --zen --discord --vscode=codium
    fi
    
    cd ~
    print_msg "Caelestia Dots installed"
fi

# ============================================
# 6. Install Celestia (space simulator) via AppImage
# ============================================
print_msg "Installing Celestia (space simulator)..."

CELESTIA_APPIMAGE="$HOME/.local/bin/celestia.AppImage"

# Create bin directory if it doesn't exist
mkdir -p "$HOME/.local/bin"

# Download latest Celestia AppImage
print_msg "Downloading Celestia AppImage..."
wget -O "$CELESTIA_APPIMAGE" \
    "https://github.com/ivan-hc/Celestia-appimage/releases/download/continuous/Celestia-qt6-x86_64.AppImage"

chmod +x "$CELESTIA_APPIMAGE"

# Create desktop entry
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
EOF

print_msg "Celestia installed"

# ============================================
# 7. Configure Caelestia settings
# ============================================
print_msg "Configuring Caelestia settings..."

# Create config directory
mkdir -p "$HOME/.config/caelestia"
mkdir -p "$HOME/Pictures/Wallpapers"
mkdir -p "$HOME/Pictures/Profile"

# Create default shell config
cat > "$HOME/.config/caelestia/shell.json" << EOF
{
    "general": {
        "apps": {
            "terminal": ["foot"],
            "audio": ["pavucontrol"]
        }
    },
    "background": {
        "enabled": true,
        "visualiser": {
            "enabled": false,
            "autoHide": true
        }
    },
    "bar": {
        "persistent": true,
        "showOnHover": true,
        "status": {
            "showAudio": true,
            "showBattery": true,
            "showBluetooth": true,
            "showNetwork": true
        },
        "workspaces": {
            "activeIndicator": true,
            "showWindows": true,
            "shown": 5
        }
    },
    "paths": {
        "wallpaperDir": "~/Pictures/Wallpapers"
    },
    "session": {
        "commands": {
            "logout": ["loginctl", "terminate-user", ""],
            "shutdown": ["systemctl", "poweroff"],
            "reboot": ["systemctl", "reboot"]
        }
    }
}
EOF

# Create default wallpaper info
cat > "$HOME/Pictures/Wallpapers/README.txt" << EOF
Place your wallpapers here!
They will appear in the Caelestia wallpaper switcher.
EOF

print_msg "Caelestia configured"

# ============================================
# 8. Create Hyprland config
# ============================================
print_msg "Creating Hyprland config..."

mkdir -p "$HOME/.config/hypr"

# Check if hyprland.conf already exists from Caelestia Dots
if [[ ! -f "$HOME/.config/hypr/hyprland.conf" ]]; then
    cat > "$HOME/.config/hypr/hyprland.conf" << EOF
# Hyprland config for Caelestia

# Monitor
monitor=,preferred,auto,1

# Startup
exec-once = waybar & dunst & caelestia shell

# Input
input {
    kb_layout = us
    kb_variant =
    kb_model =
    kb_options =
    kb_rules =
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
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

# Animations
animations {
    enabled = true
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

# Window rules
windowrulev2 = nomaximizerequest, class:.*
windowrulev2 = center, class:floating

# Keybinds
\$mainMod = SUPER

bind = \$mainMod, Q, exec, foot
bind = \$mainMod, C, killactive,
bind = \$mainMod, M, exit,
bind = \$mainMod, E, exec, thunar
bind = \$mainMod, V, togglefloating,
bind = \$mainMod, R, exec, wofi --show drun
bind = \$mainMod, P, exec, grim -g "\$(slurp)"
bind = \$mainMod, L, exec, hyprlock
bind = \$mainMod, SPACE, exec, caelestia launcher

# Workspaces
bind = \$mainMod, 1, workspace, 1
bind = \$mainMod, 2, workspace, 2
bind = \$mainMod, 3, workspace, 3
bind = \$mainMod, 4, workspace, 4
bind = \$mainMod, 5, workspace, 5
bind = \$mainMod, 6, workspace, 6
bind = \$mainMod, 7, workspace, 7
bind = \$mainMod, 8, workspace, 8
bind = \$mainMod, 9, workspace, 9
bind = \$mainMod, 0, workspace, 10

# Move windows to workspaces
bind = \$mainMod SHIFT, 1, movetoworkspace, 1
bind = \$mainMod SHIFT, 2, movetoworkspace, 2
bind = \$mainMod SHIFT, 3, movetoworkspace, 3
bind = \$mainMod SHIFT, 4, movetoworkspace, 4
bind = \$mainMod SHIFT, 5, movetoworkspace, 5
bind = \$mainMod SHIFT, 6, movetoworkspace, 6
bind = \$mainMod SHIFT, 7, movetoworkspace, 7
bind = \$mainMod SHIFT, 8, movetoworkspace, 8
bind = \$mainMod SHIFT, 9, movetoworkspace, 9
bind = \$mainMod SHIFT, 0, movetoworkspace, 10

# Scroll through workspaces
bind = \$mainMod, mouse_down, workspace, e+1
bind = \$mainMod, mouse_up, workspace, e-1

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

    print_msg "Hyprland config created"
else
    print_msg "Hyprland config already exists (from Caelestia Dots)"
fi

# ============================================
# 9. Set up fish shell
# ============================================
print_msg "Setting up fish shell..."

# Change default shell to fish
if [[ "$SHELL" != "/usr/bin/fish" ]]; then
    print_info "Changing default shell to fish..."
    chsh -s /usr/bin/fish
fi

# Create fish config
mkdir -p "$HOME/.config/fish"
cat > "$HOME/.config/fish/config.fish" << 'EOF'
# Fish config for Caelestia

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
neofetch
EOF

print_msg "Fish shell configured"

# ============================================
# 10. Final cleanup and setup
# ============================================
print_msg "Performing final setup..."

# Create directories
mkdir -p "$HOME/.local/share/wallpapers"
mkdir -p "$HOME/.local/share/fonts"

# Set profile picture placeholder (if not exists)
if [[ ! -f "$HOME/.face" ]]; then
    print_info "Create a profile picture later by placing an image at ~/.face"
fi

# Enable services
print_msg "Enabling system services..."

sudo systemctl enable bluetooth
sudo systemctl enable NetworkManager

# Disable display manager if any (use TTY login)
sudo systemctl disable sddm 2>/dev/null
sudo systemctl disable gdm 2>/dev/null
sudo systemctl disable lightdm 2>/dev/null

print_msg "Services configured"

# ============================================
# Done
# ============================================
echo ""
print_warning "=========================================="
print_warning "INSTALLATION COMPLETE!"
print_warning "=========================================="
print_info "What's installed:"
print_info "  ✓ Hyprland (Wayland compositor)"
print_info "  ✓ Caelestia Dots (main configs)"
print_info "  ✓ Caelestia Shell (widgets & panel)"
print_info "  ✓ Celestia (space simulator)"
print_info ""
print_info "Next steps:"
print_info "  1. Log out of current session"
print_info "  2. Login from TTY (console)"
print_info "  3. Run 'Hyprland' to start"
print_info "  4. Or select Hyprland from your display manager"
print_info ""
print_info "Keybinds:"
print_info "  Super         - Open launcher"
print_info "  Super + T     - Open terminal (foot)"
print_info "  Super + W     - Open browser (Zen)"
print_info "  Super + C     - Open IDE (VSCodium)"
print_info "  Super + #     - Switch workspace"
print_info "  Ctrl+Alt+Del  - Session menu"
print_info ""
print_info "For Celestia (space simulator):"
print_info "  Run: ~/.local/bin/celestia.AppImage"
print_info "  Or find it in your app menu"
print_info ""
read -p "Reboot now? (yes/no): " reboot_confirm

if [[ "$reboot_confirm" == "yes" ]]; then
    print_msg "Rebooting..."
    sudo reboot
else
    print_msg "Reboot cancelled. Run 'sudo reboot' later"
fi
