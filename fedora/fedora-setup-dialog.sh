#!/usr/bin/env bash
HEIGHT=20
WIDTH=90
CHOICE_HEIGHT=4
BACKTITLE="Fedora Setup"
TITLE="Please Make a selection"
MENU="Please Choose one of the following options:"

#Check to see if Dialog is installed, if not install it
# if [ "$(rpm -q dialog 2>/dev/null | grep -c "is not installed")" -eq 1 ]; then
#     sudo dnf install -y dialog
# fi

#Check to see if Dialog is installed, if not show error
command_exist() { command -v "$1" >/dev/null 2>&1; }
for dep in dialog curl; do command_exist "$dep" || {
    echo "Error: $dep is not installed." >&2
    exit 1
}; done

OPTIONS=(1 "Debloat System"
         2 "Enabling RPM Fusion"
         3 "Installing Essential Software"
         4 "Installing Codecs"
         5 "Installing Extras"
         6 "Install Nvidia - Install akmod nvidia drivers"
         7 "Disable SElinux - Reboot need"
         8 "Enable Terra repo"
         9 "Quit")

while [ "$CHOICE -ne 4" ]; do
    CHOICE=$(dialog --clear \
                    --backtitle "$BACKTITLE" \
                    --title "$TITLE" \
                    --nocancel \
                    --menu "$MENU" \
                    $HEIGHT $WIDTH $CHOICE_HEIGHT \
                    "${OPTIONS[@]}" \
                    2>&1 >/dev/tty)
    clear

    case $CHOICE in
        1)  echo "Debloat System"
            sudo dnf remove -y libreoffice-core yelp abrt \
                 gnome-user-docs gnome-boxes gnome-tour \
                 ibus-libzhuyin ibus-hangul ibus-anthy
            notify-send "Debloat System" --expire-time=10
            ;;

        2)  echo "Enabling RPM Fusion"
            sudo dnf install -y https://mirrors.ustc.edu.cn/rpmfusion/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.ustc.edu.cn/rpmfusion/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
            notify-send "RPM Fusion Enabled" --expire-time=10
            ;;

        3)  echo "Installing Essential Software"
            sudo dnf install -y gnome-tweaks gnome-extensions-app dconf-editor \
                 jetbrains-mono-fonts fira-code-fonts \
                 zsh p7zip-plugins rpmreaper
            notify-send "Software has been installed" --expire-time=10
            ;;

        4)  echo "Installing Codecs"
            sudo dnf group upgrade -y --with-optional --allowerasing Multimediar
            # sudo dnf install lame\* --exclude=lame-devel
            notify-send "Codecs has been installed" --expire-time=10
            ;;


        5)  echo "Installing Extras"
            sudo dnf copr enable timlau/yumex-ng -y
            sudo dnf install yumex -y
            sudo dnf group install -y --with-optional virtualization
            sudo dnf group install -y @"C Development Tools and Libraries"
            notify-send "All done" --expire-time=10
            ;;

        6)  echo "Installing Nvidia Driver Akmod-Nvidia"
            sudo dnf install -y akmod-nvidia
            notify-send "All done" --expire-time=10
            ;;

        7)  echo "Disable SElinux"
            sudo sed -i s/^SELINUX=.*$/SELINUX=disabled/ /etc/selinux/config
            sestatus
            notify-send "All done" --expire-time=10
            ;;

        8) echo "Enable Terra repo"
           # https://terra.fyralabs.com/
           sudo dnf install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
           ;;

        9)
            exit 0
            ;;
    esac
done
