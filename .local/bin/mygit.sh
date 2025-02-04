#!/usr/bin/env bash
#
# Executes specified Git commands across all managed projects, such as 'clone',
# 'pull' or 'status' (simple git operations), for streamlined multi-repo
# management.
#

myenv="$HOME/git/myenv"
salsa="$HOME/git/salsa"

for dir in "$myenv" "$salsa"; do
	if [ ! -d "$dir" ]; then
		echo >&2 "'$dir' directory not exist."
		exit 1
	fi
done

usage()
{
if (( $1 )); then
        >&2 echo "Try '$(basename $0) help' for more information."
        exit 1
else
cat << EOF
$(echo -e "\e[96mUsage: $(basename $0) [options]\e[0m")
Multiple Git Control (simple git operations).

  clone0         clone my GitHub projects in current directory
  clone1         clone my favorite Salsa projects in current directory

  pull0          pull from my GitHub projects. all branches
  pull1          pull from my favorite Salsa projects. all branches

  status0        status from my GitHub projects. current branch
  status1        status from my favorite Salsa projects. current branch

  help           show this help and exit

EOF

exit 0
fi
}

git_action()
{
	path="$1" option="$2"
	current_dirs="$(dirname $(find $path -type d -name '.git') 2>/dev/null)"

	if [ -z "$current_dirs" ]; then
		echo >&2 "'$path' there are no projects in this directory."
		exit 1
	fi

	for dir in ${current_dirs[*]}; do
		echo -e "\e[96m*** ---- $dir ---- ***\e[0m"
		cd "$dir"

		if [ "$option" == "pull" ]; then
			git fetch --all
			if git status | grep 'git pull' >/dev/null; then
				echo "git pull --all"
				git pull --all 2>/dev/null
			fi

			current_branch="$(git branch | grep '*' | awk '{print $2}')"
			branch_count="$(git branch | wc -l)"

			if (( $branch_count > 1 )); then
				# git pull from all have branches
				# I want actual git log
				branches=$(git branch --format='%(refname:short)')
				for b in ${branches[*]}; do
					git checkout "$b"
					if git status | grep 'git pull' >/dev/null; then
						echo "git pull: $b"
						git "$option" 2>/dev/null
					fi
				done

				# go back to the 'master' branch
				git checkout "$current_branch"
			fi
		fi

		if [ "$option" == "status" ]; then
			git "$option"
		fi

		cd - >/dev/null
		echo
	done
}

clone_salsa()
{
	dir=$1
	list=($2)

	mkdir $dir 2>/dev/null

	for name in ${list[*]}; do
		vcs=$(apt-get source --print-uris "$name" 2>/dev/null | grep -E 'https|salsa' | head -1)
		if [ -z "$vcs" ]; then
			echo >&2 "$name is not loaded on salsa."
			echo; continue
		fi

		sdir=$(basename 2>/dev/null $(basename "$vcs" .git))
		if [ ! -d "$dir/$sdir" ]; then
			git clone "$vcs" "$dir/$sdir"
			echo
		fi
	done
}

case "$1" in
	# 0 - means https://github.com/iikrllx my projects
	# 1 - means https://salsa.debian.org/public my favorite projects

	'clone0')
		projects=(notes dotfiles-debian chroot-deb-builder ioquake3-linux-install)

		for name in ${projects[*]}; do
			if [ ! -d "$name" ]; then
				git clone "git@github.com:iikrllx/$name"
				echo
			fi
		done
	;;

	'clone1')
		misc_projects=(mc bash tmux vim strace xterm xfce4-terminal git \
                aptitude grub2 telegram-desktop)

		xfce_projects=(exo-utils libexo-2-0 libexo-2-dev libexo-common \
		gir1.2-garcon-1.0 gir1.2-garcongtk-1.0 libgarcon-1-0 \
		libgarcon-1-0-dev libgarcon-1-dev libgarcon-common \
		libgarcon-gtk3-1-0 libgarcon-gtk3-1-dev gigolo \
		gir1.2-libxfce4ui-2.0 libxfce4ui-2-0 libxfce4ui-2-dev \
		libxfce4ui-common libxfce4ui-glade libxfce4ui-utils \
		gir1.2-libxfce4util-1.0 libxfce4util-bin libxfce4util-common \
		libxfce4util-dev libxfce4util7 light-locker gir1.2-lightdm-1 \
		liblightdm-gobject-1-0 liblightdm-gobject-dev liblightdm-qt5-3-0 \
		liblightdm-qt5-3-dev lightdm lightdm-vala lightdm-gtk-greeter \
		libmousepad-dev libmousepad0 mousepad orage orage-data parole \
		parole-dev ristretto gir1.2-thunarx-3.0 libthunarx-3-0 \
		libthunarx-3-dev thunar thunar-data thunar-archive-plugin \
		thunar-media-tags-plugin thunar-vcs-plugin thunar-volman \
		libtumbler-1-0 libtumbler-1-dev tumbler tumbler-common \
		tumbler-plugins-extra xfburn xfce4 xfce4-appfinder \
		xfce4-battery-plugin xfce4-clipman xfce4-clipman-plugin \
		xfce4-cpufreq-plugin xfce4-cpugraph-plugin xfce4-datetime-plugin \
		xfce4-dev-tools xfce4-dict xfce4-diskperf-plugin \
		xfce4-fsguard-plugin xfce4-genmon-plugin xfce4-goodies \
		xfce4-indicator-plugin xfce4-mailwatch-plugin xfce4-mount-plugin \
		xfce4-mpc-plugin xfce4-netload-plugin xfce4-notifyd \
		gir1.2-libxfce4panel-2.0 libxfce4panel-2.0-4 \
		libxfce4panel-2.0-dev xfce4-panel xfce4-panel-profiles \
		xfce4-places-plugin xfce4-power-manager xfce4-power-manager-data \
		xfce4-power-manager-plugins xfce4-pulseaudio-plugin \
		xfce4-screenshooter xfce4-sensors-plugin xfce4-session \
		xfce4-helpers xfce4-settings xfce4-smartbookmark-plugin \
		xfce4-systemload-plugin xfce4-taskmanager xfce4-timer-plugin \
		xfce4-verve-plugin xfce4-wavelan-plugin xfce4-weather-plugin \
		xfce4-whiskermenu-plugin xfce4-xkb-plugin gir1.2-xfconf-0 \
		libxfconf-0-3 libxfconf-0-dev xfconf xfdesktop4 xfdesktop4-data \
		xfwm4)

		trans_projects=(webwml manpages-l10n)

		# webwml not a package: https://salsa.debian.org/webmaster-team/webwml
		# aptitude not clone from the script (i don't know why):
		# https://salsa.debian.org/apt-team/aptitude.git

		clone_salsa "misc" "${misc_projects[*]}"
		clone_salsa "xfce" "${xfce_projects[*]}"
		clone_salsa "trans" "${trans_projects[*]}"
	;;

	'pull0') git_action "$myenv" "pull" ;;
	'pull1') git_action "$salsa" "pull" ;;
	'status0') git_action "$myenv" "status" ;;
	'status1') git_action "$salsa" "status" ;;
	'help') usage 0 ;;

	*) usage 1 ;;
esac
