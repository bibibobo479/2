#!/bin/bash

# ============================================
# Скрипт полной очистки графической подсистемы
# ВНИМАНИЕ! Скрипт удаляет ВСЕ графические окружения
# ============================================

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Функция для вывода сообщений
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

# Проверка прав
if [[ $EUID -eq 0 ]]; then
    print_error "Не запускайте скрипт от root!"
    exit 1
fi

# Подтверждение
echo ""
print_warning "=========================================="
print_warning "ЭТОТ СКРИПТ УДАЛИТ ВСЁ ГРАФИЧЕСКОЕ ОКРУЖЕНИЕ!"
print_warning "Вы останетесь только в консоли (tty)"
print_warning "=========================================="
echo ""
read -p "Вы уверены, что хотите продолжить? (yes/no): " confirm

if [[ "$confirm" != "yes" ]]; then
    print_msg "Отмена операции"
    exit 0
fi

echo ""
read -p "Введите ДА (прописными буквами) для подтверждения: " final_confirm

if [[ "$final_confirm" != "ДА" ]]; then
    print_msg "Отмена операции"
    exit 0
fi

# Создание бэкапа важных файлов
print_msg "Создание бэкапа в ~/backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p ~/backup_$(date +%Y%m%d_%H%M%S)
cp -r ~/.bashrc ~/backup_$(date +%Y%m%d_%H%M%S)/ 2>/dev/null
cp -r ~/.zshrc ~/backup_$(date +%Y%m%d_%H%M%S)/ 2>/dev/null
cp -r ~/.config ~/backup_$(date +%Y%m%d_%H%M%S)/ 2>/dev/null

# ============================================
# 1. Удаление Celestia (программа-симулятор)
# ============================================
print_msg "Удаление Celestia..."

# Через pacman
sudo pacman -Rns --noconfirm celestia 2>/dev/null
# Через AUR
yay -Rns --noconfirm celestia-bin celestia-git 2>/dev/null
paru -Rns --noconfirm celestia-bin celestia-git 2>/dev/null

# AppImage
rm -f ~/celestia.AppImage 2>/dev/null
rm -rf ~/Celestia 2>/dev/null

# Конфиги
rm -rf ~/.celestia 2>/dev/null
rm -rf ~/.config/celestia 2>/dev/null

print_msg "Celestia удален"

# ============================================
# 2. Удаление Hyprland и связанных пакетов
# ============================================
print_msg "Удаление Hyprland и оконных менеджеров..."

# Hyprland и компоненты
sudo pacman -Rns --noconfirm hyprland hyprpaper hyprlock hypridle hyprcursor \
  hyprutils hyprlang hyprwayland-scanner 2>/dev/null

# Панели и лаунчеры
sudo pacman -Rns --noconfirm waybar wofi rofi polybar \
  eww nwg-dock nwg-panel 2>/dev/null

# Уведомления
sudo pacman -Rns --noconfirm dunst mako 2>/dev/null

# Скриншоты и утилиты
sudo pacman -Rns --noconfirm grim slurp swappy wl-clipboard \
  wlogout swww 2>/dev/null

# Терминалы
sudo pacman -Rns --noconfirm foot alacritty kitty wezterm \
  st termite 2>/dev/null

# Портал Wayland
sudo pacman -Rns --noconfirm xdg-desktop-portal-hyprland \
  xdg-desktop-portal-gtk 2>/dev/null

# Qt и GTK Wayland
sudo pacman -Rns --noconfirm qt5-wayland qt6-wayland \
  qt5ct qt6ct 2>/dev/null

# Другие оконные менеджеры
sudo pacman -Rns --noconfirm i3-wm i3status i3lock \
  sway swaylock swayidle swaybg \
  bspwm sxhkd \
  awesome \
  openbox obconf \
  xfce4 xfce4-goodies \
  gnome gnome-extra \
  plasma-desktop plasma-meta \
  cinnamon 2>/dev/null

print_msg "Оконные менеджеры удалены"

# ============================================
# 3. Удаление AUR пакетов
# ============================================
print_msg "Удаление пакетов из AUR..."

# HyDE
yay -Rns --noconfirm hyde-git hyde-cli hyde-theme-git 2>/dev/null
paru -Rns --noconfirm hyde-git hyde-cli 2>/dev/null

# Caelestia
yay -Rns --noconfirm caelestia-meta caelestia-shell-git \
  caelestia-cli-git quickshell-git 2>/dev/null
paru -Rns --noconfirm caelestia-meta caelestia-shell-git \
  caelestia-cli-git quickshell-git 2>/dev/null

# Другое
yay -Rns --noconfirm nwg-look waybar-hyprland-git wlogout-git \
  swww-git pywal-git wal-steam-git 2>/dev/null
paru -Rns --noconfirm nwg-look waybar-hyprland-git 2>/dev/null

print_msg "AUR пакеты удалены"

# ============================================
# 4. Удаление менеджеров входа
# ============================================
print_msg "Удаление менеджеров входа..."

# SDDM
sudo pacman -Rns --noconfirm sddm sddm-kcm 2>/dev/null
sudo systemctl disable sddm 2>/dev/null

# GDM
sudo pacman -Rns --noconfirm gdm 2>/dev/null
sudo systemctl disable gdm 2>/dev/null

# LightDM
sudo pacman -Rns --noconfirm lightdm lightdm-gtk-greeter 2>/dev/null
sudo systemctl disable lightdm 2>/dev/null

# LXDM
sudo pacman -Rns --noconfirm lxdm 2>/dev/null
sudo systemctl disable lxdm 2>/dev/null

print_msg "Менеджеры входа удалены"

# ============================================
# 5. Удаление конфигурационных файлов
# ============================================
print_msg "Удаление конфигурационных файлов..."

# Удаление папок
rm -rf ~/.config/* 2>/dev/null
rm -rf ~/.cache/* 2>/dev/null
rm -rf ~/.local/share/* 2>/dev/null
rm -rf ~/.local/bin/* 2>/dev/null
rm -rf ~/.local/lib/* 2>/dev/null

# Удаление скрытых файлов
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
rm -f ~/.xsession 2>/dev/null

# Удаление точек
rm -rf ~/.hyprland 2>/dev/null
rm -rf ~/.hyde 2>/dev/null
rm -rf ~/.caelestia 2>/dev/null
rm -rf ~/.gnome 2>/dev/null
rm -rf ~/.kde 2>/dev/null
rm -rf ~/.local 2>/dev/null
rm -rf ~/.mozilla 2>/dev/null
rm -rf ~/.thunderbird 2>/dev/null

print_msg "Конфигурации удалены"

# ============================================
# 6. Удаление системных тем и иконок
# ============================================
print_msg "Удаление тем и иконок..."

sudo rm -rf /usr/share/themes/* 2>/dev/null
sudo rm -rf /usr/share/icons/* 2>/dev/null
sudo rm -rf /usr/share/sddm/themes/* 2>/dev/null
sudo rm -rf /usr/share/gnome-shell/theme/* 2>/dev/null
sudo rm -rf /usr/local/share/themes/* 2>/dev/null
sudo rm -rf /usr/local/share/icons/* 2>/dev/null

print_msg "Темы и иконки удалены"

# ============================================
# 7. Очистка пакетного менеджера
# ============================================
print_msg "Очистка пакетного менеджера..."

# Удаление ненужных зависимостей
sudo pacman -Rns --noconfirm $(pacman -Qdtq) 2>/dev/null

# Очистка кэша
sudo pacman -Scc --noconfirm 2>/dev/null
yay -Scc --noconfirm 2>/dev/null
paru -Scc --noconfirm 2>/dev/null

print_msg "Пакетный менеджер очищен"

# ============================================
# 8. Установка базовых консольных утилит
# ============================================
print_msg "Установка базовых консольных утилит..."

sudo pacman -S --noconfirm --needed base base-devel \
  linux linux-firmware \
  vim nano \
  sudo networkmanager dhcpcd \
  alsa-utils pipewire pipewire-pulse \
  openssh git curl wget \
  htop neofetch 2>/dev/null

print_msg "Базовые утилиты установлены"

# ============================================
# 9. Создание чистых конфигов
# ============================================
print_msg "Создание чистых конфигурационных файлов..."

# .bashrc
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

# History
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth

# Colorize grep
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
EOF

# .profile
cat > ~/.profile << 'EOF'
# ~/.profile
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
EOF

# .bash_logout
cat > ~/.bash_logout << 'EOF'
# ~/.bash_logout
clear
EOF

print_msg "Конфиги созданы"

# ============================================
# 10. Включение сети
# ============================================
print_msg "Настройка сети..."

sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

print_msg "Сеть настроена"

# ============================================
# 11. Финальная очистка
# ============================================
print_msg "Финальная очистка..."

# Очистка мусора
rm -rf ~/.cache/* 2>/dev/null
rm -rf ~/.local/share/Trash/* 2>/dev/null
rm -rf /tmp/* 2>/dev/null

# Синхронизация
sync

print_msg "Очистка завершена"

# ============================================
# Завершение
# ============================================
echo ""
print_warning "=========================================="
print_warning "СКРИПТ ЗАВЕРШИЛ РАБОТУ!"
print_warning "=========================================="
print_info "Бэкап сохранен в: ~/backup_$(ls -t ~/ | grep backup_ | head -1)"
print_info "После перезагрузки вы окажетесь в консоли (tty)"
echo ""
read -p "Перезагрузить систему сейчас? (yes/no): " reboot_confirm

if [[ "$reboot_confirm" == "yes" ]]; then
    print_msg "Перезагрузка..."
    sudo reboot
else
    print_msg "Перезагрузка отменена. Выполните 'sudo reboot' позже"
fi
