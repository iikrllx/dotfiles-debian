#!/usr/bin/env bash
#
# Stupid script for fetching source codes.
# My favorite Debian packages here (for maintenance work).
#

misc_packages=(mc bash tmux vim strace xterm xfce4-terminal tig git aptitude ncurses \
grub2 telegram-desktop)

# Debian Xfce Maintainers
xfce_packages=(\
exo-utils libexo-2-0 libexo-2-dev libexo-common gir1.2-garcon-1.0 gir1.2-garcongtk-1.0 libgarcon-1-0 \
libgarcon-1-0-dev libgarcon-1-dev libgarcon-common libgarcon-gtk3-1-0 libgarcon-gtk3-1-dev gigolo \
gir1.2-libxfce4ui-2.0 libxfce4ui-2-0 libxfce4ui-2-dev libxfce4ui-common libxfce4ui-glade \
libxfce4ui-utils gir1.2-libxfce4util-1.0 libxfce4util-bin libxfce4util-common libxfce4util-dev \
libxfce4util7 light-locker gir1.2-lightdm-1 liblightdm-gobject-1-0 liblightdm-gobject-dev \
liblightdm-qt5-3-0 liblightdm-qt5-3-dev lightdm lightdm-vala lightdm-gtk-greeter libmousepad-dev \
libmousepad0 mousepad orage orage-data parole parole-dev ristretto gir1.2-thunarx-3.0 libthunarx-3-0 \
libthunarx-3-dev thunar thunar-data thunar-archive-plugin thunar-media-tags-plugin thunar-vcs-plugin \
thunar-volman libtumbler-1-0 libtumbler-1-dev tumbler tumbler-common tumbler-plugins-extra xfburn \
xfce4 xfce4-appfinder xfce4-battery-plugin xfce4-clipman xfce4-clipman-plugin xfce4-cpufreq-plugin \
xfce4-cpugraph-plugin xfce4-datetime-plugin xfce4-dev-tools xfce4-dict xfce4-diskperf-plugin \
xfce4-fsguard-plugin xfce4-genmon-plugin xfce4-goodies xfce4-indicator-plugin xfce4-mailwatch-plugin \
xfce4-mount-plugin xfce4-mpc-plugin xfce4-netload-plugin xfce4-notifyd gir1.2-libxfce4panel-2.0 \
libxfce4panel-2.0-4 libxfce4panel-2.0-dev xfce4-panel xfce4-panel-profiles xfce4-places-plugin \
xfce4-power-manager xfce4-power-manager-data xfce4-power-manager-plugins xfce4-pulseaudio-plugin \
xfce4-screenshooter xfce4-sensors-plugin xfce4-session xfce4-helpers xfce4-settings \
xfce4-smartbookmark-plugin xfce4-systemload-plugin xfce4-taskmanager xfce4-timer-plugin \
xfce4-verve-plugin xfce4-wavelan-plugin xfce4-weather-plugin xfce4-whiskermenu-plugin \
xfce4-xkb-plugin gir1.2-xfconf-0 libxfconf-0-3 libxfconf-0-dev xfconf xfdesktop4 \
xfdesktop4-data xfwm4)

mkdir ~/sources 2>/dev/null
mkdir ~/sources/misc 2>/dev/null
mkdir ~/sources/xfce 2>/dev/null

get_sources()
{
	dir=$1
	list=($2)

	for pkg in ${list[*]}; do
		[ ! -d ~/sources/$dir/sid-$pkg ] && mkdir ~/sources/$dir/sid-$pkg || continue
		cd ~/sources/$dir/sid-$pkg
		apt-get source $pkg
	done
}

get_sources "misc" "${misc_packages[*]}"
get_sources "xfce" "${xfce_packages[*]}"

cd ~
