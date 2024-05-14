#!/usr/bin/env bash
#
# This script manage all my git projects (simple git operations).
#

myenv=$HOME/git/myenv

if [ ! -d $myenv ]; then
	echo >&2 "$myenv directory not exist"
	exit 1
fi

usage()
{
if (( $1 )); then
        >&2 echo "Try '$(basename $0) --help' for more information"
        exit 1
else
cat << EOF
$(echo -e "\e[96mUsage: $(basename $0) [options]\e[0m")
Multiple Git Control (simple git operations).

  clone         clone my projects in current directory
  pull          pull from my projects. all branches
  status        status from my projects. current branch
  help          show this help and exit

EOF

exit 0
fi
}

git_action()
{
	path=$1 option=$2

	current_dirs=$(dirname $(find $path -type d -name '.git'))
	for dir in ${current_dirs[*]}; do
		echo -e "\e[96m*** ----- '$dir' ----- ***\e[0m"
		cd $dir

		if [ "$option" == "pull" ]; then
			git fetch --all
			if git status | grep 'git pull' >/dev/null; then
				echo "git pull --all"
				git pull --all 2>/dev/null
			fi

			current_branch=$(git branch | grep '*' | awk '{print $2}')
			branch_count=$(git branch | wc -l)

			if (( $branch_count > 1 )); then
				# git pull from all have branches
				# I want actual git log
				branches=$(git branch --format='%(refname:short)')
				for b in ${branches[*]}; do
					git checkout $b
					if git status | grep 'git pull' >/dev/null; then
						echo "git pull: $b"
						git $option 2>/dev/null
					fi
				done

				# go back to the 'master' branch
				git checkout $current_branch
			fi
		fi

		if [ "$option" == "status" ]; then
			git $option
		fi

		cd - >/dev/null
		echo
	done
}

case $1 in
	'clone')
		private_projects=$(ssh rserver-git 'ls projects')
		for name in ${private_projects[*]}; do
			if [ ! -d $name ]; then
				git clone rserver-git:projects/$name
				echo
			fi
		done

		public_projects=(binout chroot-deb-builder dotfiles-debian notes glibc-with-shred typp)
		for name in ${public_projects[*]}; do
			if [ ! -d $name ]; then
				git clone git@github.com:iikrllx/$name
				echo
			fi
		done
	;;
	'pull') git_action $myenv "pull" ;;
	'status') git_action $myenv "status" ;;
	'help') usage 0 ;;
	*) usage 1 ;;
esac
