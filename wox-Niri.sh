#!/bin/bash

# --------------------------------------------
#       author: wox
#       update: 25/10/01/02:21
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
    paru -S sddm niri btop kitty swww mako waybar wlogout swaylock-effects swayidle
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
export OZONE_PLATFORM=wayland
export ELECTRON_OZONE_PLATFORM_HINT=auto

# fcitx
# 通用输入法配置
GTK_IM_MODULE=fcitx      # GTK 程序
QT_IM_MODULE=fcitx       # Qt 程序
XMODIFIERS=@im=fcitx     # X11 传统程序
# 游戏/多媒体框架
SDL_IM_MODULE=fcitx      # SDL 应用
GLFW_IM_MODULE=fcitx     # GLFW 应用
# 遗留库支持
CLUTTER_IM_MODULE=fcitx  # Clutter 应用
EOF
}

cpconf() {
    cp -fr ./config/* $HOME/.config/
}

lnsf(){
   ln -sf $HOME/.config/waybar/conf/config.jsonc $HOME/.config/waybar/config.jsonc
   ln -sf $HOME/.config/waybar/style/style.css $HOME/.config/waybar/style.css
   ln -sf $HOME/.config/mako/conf/config-dark $HOME/.config/mako/config
   ln -sf $HOME/.config/wofi/conf/config $HOME/.config/wofi/config
   ln -sf $HOME/.config/wofi/style/style-dark.css $HOME/.config/wofi/style.css
}

# 读取用户输入
read -p "请确认是否要进行安装(y/n): " answer

# 处理用户输入
case $answer in
    [Yy]|Yes|YES|yes)
        echo "开始安装..."
        installwoxniri
        envniri
        cpconf
        lnsf
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