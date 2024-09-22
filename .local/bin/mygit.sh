#!/usr/bin/env bash
#
# Executes specified Git commands across all managed projects, such as 'clone', 'pull' or 'status'
# (simple git operations), for streamlined multi-repo management.
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
		echo -e "\e[96m*** ----- $dir ----- ***\e[0m"
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

case "$1" in
	# 0 - means https://github.com/iikrllx my projects
	# 1 - means https://salsa.debian.org/public my favorite projects

	'clone0')
		projects=(notes dotfiles-debian chroot-deb-builder iikrllx \
		typp quake3-terminal-theme glibc-with-shred linux-insides-ru binout)

		for name in ${projects[*]}; do
			if [ ! -d "$name" ]; then
				git clone "git@github.com:iikrllx/$name"
				echo
			fi
		done
	;;

	'clone1')
		projects=(bash tmux vim mousepad xfce4 xfce4-terminal \
		strace xterm tig tree aptitude cowsay oneko \
		ncurses mc webwml manpages-l10n)

		# webwml not a package: https://salsa.debian.org/webmaster-team/webwml
		# aptitude not clone from the script (i don't know why):
		# https://salsa.debian.org/apt-team/aptitude.git

		for name in ${projects[*]}; do
			vcs=$(apt-get -t sid --print-uris --only-source source "$name" 2>/dev/null | grep -E 'https|salsa')
			if [ $? != 0 ]; then
				echo >&2 "$name is not loaded on salsa."
				echo; continue
			fi

			repo=$(echo "$vcs" | head -1)
			dir=$(basename 2>/dev/null $(basename "$repo" .git))

			if [ ! -d "$dir" ]; then
				git clone "$repo"
				echo
			fi
		done
	;;

	'pull0') git_action "$myenv" "pull" ;;
	'pull1') git_action "$salsa" "pull" ;;
	'status0') git_action "$myenv" "status" ;;
	'status1') git_action "$salsa" "status" ;;
	'help') usage 0 ;;

	*) usage 1 ;;
esac
