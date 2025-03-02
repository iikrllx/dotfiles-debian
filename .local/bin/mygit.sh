#!/usr/bin/env bash
#
# Execute specified Git commands across all managed projects, such as 'clone',
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

git_command()
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
	# 0 - means https://github.com/krekhovx my projects
	# 1 - means https://salsa.debian.org/public my favorite projects

	'clone0')
		projects=(notes dotfiles-debian chroot-deb-builder ioquake3-linux-install)

		for name in ${projects[*]}; do
			if [ ! -d "$name" ]; then
				git clone "git@github.com:krekhovx/$name"
				echo
			fi
		done
	;;

	'clone1')
		misc_packages=(bash mc tmux strace telegram-desktop xterm \
		aptitude git grub2 pbuilder debootstrap eatmydata)

		xfce_packages=$(grep-aptavail -F Maintainer -s Package -n \
		"Debian Xfce Maintainers <debian-xfce@lists.debian.org>")

		vim_packages=$(grep-aptavail -F Maintainer -s Package -n \
		"Debian Vim Maintainers <team+vim@tracker.debian.org>")

		trans_packages=(webwml manpages-l10n)

		# webwml not a package: https://salsa.debian.org/webmaster-team/webwml
		# aptitude not clone from the script (i don't know why):
		# https://salsa.debian.org/apt-team/aptitude.git

		clone_salsa "misc" "${misc_packages[*]}"
		clone_salsa "xfce" "${xfce_packages[*]}"
		clone_salsa "vim" "${vim_packages[*]}"
		clone_salsa "trans" "${trans_packages[*]}"
	;;

	'pull0') git_command "$myenv" "pull" ;;

	'pull1') git_command "$salsa" "pull" ;;

	'status0') git_command "$myenv" "status" ;;

	'status1') git_command "$salsa" "status" ;;

	'help') usage 0 ;;

	*) usage 1 ;;
esac
