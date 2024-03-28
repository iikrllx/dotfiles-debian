#!/bin/bash
#
# This main project script which configure my Debian environment (dotfiles).
# Configures the necessary tools for development and convenience.
# Minimalistic environment and instruments with old-school fonts.
#
# Be careful when running this script on your main machine,
# it does not create backup dotfiles and may erase your current working environment.
#
# After the $ ./init.sh --xfce execution need to reboot.
# $ sudo reboot
#

set -ex

check_package()
{
	dpkg -l | awk '{print $2}' | grep ^$1$ &>/dev/null && return 0 || return 1
}

# ----------------------------------

mark_start="# ----"
mark_end="# ---- Don't write after this"

mark_s_file()
{
	echo -e "\n$mark_start\n" >> $1
}

mark_e_file()
{
	echo -e "\n$mark_end" >> $1
}

bold_message()
{
	echo -e "\e[96m*** ----- $1 ----- ***\e[0m"
}

remove_marked_lines()
{
	if grep "^$mark_start" $1; then
		sed -i "/$mark_start/Q" $1 # remove all lines after pattern
		sed -i '$ d' $1 # remove last empty line
	fi
}

usage()
{
cat << EOF
Usage: $(basename $0) [option]

  [option]
  --ftp                  ftp server configuration
  --hosts                modify hosts
  --sysctl               modify kernel parameters
  --initd                init.d script (operations before shutdown/reboot)
  --packages             install packages
  --clean-home           cleanup home directory
  --bashrc               ~/.bashrc extra rules
  --bash-completion      enable bash completion
  --locales              generate 'en_US' 'ru_RU' locales
  --xfce                 xfce configuration
  --xfce4-terminal       xfce4-terminal configuration
  --mc                   midnight commander configuration
  --tmux                 tmux configuration
  --vim                  vim configuration with plugins
  --mousepad             mousepad configuration
  --gdb                  gdb configuration
  --other                other operations
  -h, --help             show this help and exit

EOF

exit 0
}

# ----------------------------------

for arg in "$@"; do
        case "$arg" in
		"--ftp")
			bold_message "FTP server configuration"

			if ! check_package vsftpd; then
				sudo apt-get -y install vsftpd
			fi

			if [ ! -d /srv/ftp/upload ]; then
				sudo mkdir /srv/ftp/upload
				sudo chmod 777 /srv/ftp/upload
			fi

			sudo cp ./etc/vsftpd.conf /etc/vsftpd.conf
			sudo systemctl restart vsftpd.service
		;;

                "--hosts")
			bold_message "Hosts"
			sudo cp ./etc/hosts /etc/hosts
			sudo sed -i "s/<MY-HOSTNAME>/$(hostname)/" /etc/hosts &>/dev/null
		;;

                "--sysctl")
			bold_message "Modify kernel parameters"
			sudo cp ./etc/sysctl.conf /etc/sysctl.conf
			sudo sysctl -p
			echo "Core file size: $(ulimit -c)"
		;;

		"--initd")
			bold_message "init.d script for user home directory"
			sudo cp ./etc/init.d/clean-env /etc/init.d
			sudo ln -s /etc/init.d/clean-env /etc/rc5.d/S00clean-env &>/dev/null | true
			sudo ln -s /etc/init.d/clean-env /etc/rc6.d/K00clean-env &>/dev/null | true
			sudo systemctl daemon-reload
			sudo systemctl restart clean-env.service
		;;

		"--packages")
			net=(dnsutils traceroute whois tcpdump nmap wget curl netcat net-tools dirmngr \
			ca-certificates nfs-common)

			info=(info man-db mandoc manpages manpages-dev manpages-posix manpages-posix-dev \
			linux-doc gcc-doc gcc-base-doc)

			tools=(nano mousepad vim vim-gtk3 gdb tmux mc git tig galculator gparted gcc make \
			strace xsel ripgrep bash-completion pkg-config valgrind gpg locales sudo ssh sshpass \
			systemd-coredump moreutils coreutils binutils diffutils mawk gawk perl-base psmisc \
			dialog whiptail exuberant-ctags hwinfo indent wipe patch fakeroot python-pip python3-pip)

			fonts=(font-manager xfonts-terminus fonts-unifont fonts-hack fonts-glasstty fonts-ibm-plex)

			deb=(apt-file dpkg-dev devscripts lintian cdbs debootstrap pbuilder dconf-cli automake \
			autoconf dh-make debhelper build-essential autotools-dev)

			other=(task-russian task-russian-desktop gnome-screensaver telegram-desktop audacious)

			packs=("${net[*]}" "${info[*]}" "${tools[*]}" "${fonts[*]}" "${deb[*]}" "${other[*]}")

			bold_message "Install useful packages"
			sudo apt-get update

			if ! check_package eatmydata; then
				>&2 echo "Please, install 'eatmydata' package"
				exit 1
			fi

			set +e
			for p in ${packs[*]}; do
				if ! check_package $p; then
					sudo eatmydata apt-get -y install $p
					echo -e "$?\n"
				fi
			done
			set -e

			sudo mandb
			sudo apt-file update
		;;

		"--clean-home")
			bold_message "Cleanup $HOME"

			trash_dirs=(Видео Музыка Общедоступные Шаблоны Документы \
			Videos Music Public Templates Documents)

			# I don't need these dirs =)
			for dir in ${trash_dirs[*]}; do
				[ -d ~/$dir ] && rm -ri ~/$dir
			done

			mkdir ~/sources &>/dev/null | true
			chmod 700 ~/sources
			ls ~
		;;

		"--bashrc")
			bold_message "~/.bashrc extra rules"
			remove_marked_lines ~/.bashrc
			mark_s_file ~/.bashrc
			cat ./.bashrc >> ~/.bashrc
			mark_e_file ~/.bashrc
		;;

		"--bash-completion")
			bold_message "Enable bash completion"
			sudo perl -i -pe '$i++ if /^#if ! shopt -oq posix;/; s/^#// if $i==1; $i=0 if /^fi/' \
			/etc/bash.bashrc
		;;

		"--locales")
			bold_message "Generate locales"

			# for the shell, I use 'en_US.UTF-8'
			# for the interface 'ru_RU.UTF-8'
			# maybe something will change in the future

			for loc in en_US.UTF-8 ru_RU.UTF-8; do
				if ! grep ^$loc /etc/locale.gen &>/dev/null; then
					echo "$loc UTF-8" | sudo tee -a /etc/locale.gen
					sudo locale-gen
				fi
			done

			# all interface all users
			echo LANG="en_US.UTF8" | sudo tee /etc/default/locale
		;;

		"--xfce")
			# XDG_DATA_DIRS not set in ssh session
			#if echo "$XDG_DATA_DIRS" | grep 'xfce' &>/dev/null; then

			bold_message "XFCE configuration"

			if check_package xfce4-session; then
				cp ./.config/xfce4/xfconf/xfce-perchannel-xml/* \
				~/.config/xfce4/xfconf/xfce-perchannel-xml
			else
				>&2 echo "Current desktop environment not 'xfce'"
				exit 1
			fi
		;;

		"--xfce4-terminal")
			bold_message "xfce4-terminal configuration"

			if check_package xfce4-terminal; then
				mkdir ~/.config/xfce4/terminal &>/dev/null | true
				chmod 700 ~/.config/xfce4/terminal
				cp ./.config/xfce4/terminal/terminalrc ~/.config/xfce4/terminal

				mkdir -p ~/.local/share/xfce4/terminal/colorschemes &>/dev/null | true
				cp ./.local/share/xfce4/terminal/colorschemes/* ~/.local/share/xfce4/terminal/colorschemes
			else
				>&2 echo "Please, install 'xfce4-terminal' package"
				exit 1
			fi
		;;

		"--mc")
			bold_message "Midnight Commander configuration"

			mkdir -p ~/.config/mc &>/dev/null | true
			chmod 700 ~/.config
			chmod 700 ~/.config/mc

			sudo mkdir -p /root/.config/mc &>/dev/null | true
			sudo chmod 700 /root/.config
			sudo chmod 700 /root/.config/mc

			cp ./.config/mc/{ini,panels.ini,hotlist} ~/.config/mc
			sudo cp ./.config/mc/{ini,panels.ini} /root/.config/mc
		;;

		"--tmux")
			bold_message "Tmux configuration"
			cp ./.tmux.conf ~/.tmux.conf
		;;

		"--vim")
			bold_message "Vim configuration with plugins"

			plug_vim=~/.vim/autoload/plug.vim

			if [ ! -e $plug_vim ]; then
				curl -fLo $plug_vim --create-dirs \
				https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
			fi

			cp ./.vimrc ~/.vimrc
			vim +PlugClean +PlugInstall +q +q
		;;

		"--mousepad")
			# How export mousepad configuration ? Commands:
			# $ dconf dump /org/xfce/mousepad/ > mousepad.settings
			# $ dconf load /org/xfce/mousepad/ < mousepad.settings
			bold_message "Mousepad configuration"
			cp ./.config/dconf/mousepad.settings ~/.config/dconf
			dconf load /org/xfce/mousepad/ < ~/.config/dconf/mousepad.settings
		;;

		"--gdb")
			bold_message "Gdb configuration"

			if [ ! -e ~/.gdbinit ]; then
				wget -P ~/ https://git.io/.gdbinit
				pip install pygments --break-system-packages
			fi

			remove_marked_lines ~/.gdbinit
			mark_s_file ~/.gdbinit
			cat ./.gdbinit >> ~/.gdbinit
			mark_e_file ~/.gdbinit
		;;

		"--other")
			bold_message "Other"

			# git
			cp ./.gitconfig ~/

			# color setup for ls
			cp ./.dircolors ~/

			# scripts
			chmod 700 ~/.local
			mkdir ~/.local/bin &>/dev/null | true
			chmod 700 ~/.local/bin
			cp .local/bin/* ~/.local/bin

			# backgrounds
			mkdir ~/.local/share &>/dev/null | true
			chmod 700 ~/.local/share
			cp -r .local/share/* ~/.local/share
		;;

                "-h" | "--help") usage ;;
        esac
done
