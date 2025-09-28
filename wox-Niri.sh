#!/bin/bash

# --------------------------------------------
#       author: wox
#       update: 25/09/28/20:59
# --------------------------------------------

clear

installwoxniri() {
    echo "安装paru..."
    sudo cat >> /etc/pacman.conf << EOF
[archlinuxcn]
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/\$arch
EOF
    sudo pacman-key --lsign-key "farseerfc@archlinux.org"
    sudo pacman -Sy archlinuxcn-keyring
    sudo pacman -S paru
    echo "正在更新系统..."
    sudo pacman -Syu --noconfirm
    paru -S sddm niri btop kitty swaylock  swww  waybar  wlogout
    cp -fr ./config/* $HOME/.config/
    systemctl --user enable --now niri
    sudo systemctl enable --now sddm
}

envniri() {
    sudo cat >> /etc/environment << EOF
# Wayland
export WAYLAND_DISPLAY=wayland-1
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_TYPE=wayland
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export SDL_VIDEODRIVER=wayland
EOF
}

# 读取用户输入
read -p "请确认是否要进行安装(y/n): " answer

# 处理用户输入
case $answer in
    [Yy]|Yes|YES|yes)
        echo "开始安装..."
        installwoxniri
        envniri
        ;;
    [Nn]|No|NO|no|"")
        echo "安装已取消"
        exit 0
        ;;
    *)
        echo "无效输入，安装已取消"
        exit 1
        ;;
esac