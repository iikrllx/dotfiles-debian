#!/bin/bash
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
cat << EOF
$(echo -e "\e[96mUsage: $(basename $0) [options]\e[0m")
Git Control (simple git operations)

  --clone-my          clone my projects in current directory
  --pull-my           pull from my projects. all branches
  --status-my         status from my projects. current branch

EOF

exit
}

git_action()
{
	path=$1 str=$2 opt=$3

	current_dirs=$(dirname $(find $path -type d -name '.git'))
	for dir in ${current_dirs[*]}; do
		echo -e "\e[96m*** ----- $str '$dir' ----- ***\e[0m"
		cd $dir

		if [ "$str" == "Pull" ]; then
			git fetch --all
			git pull --all 2>/dev/null

			# grep asterisk
			current_branch=$(git branch | grep '*' | awk '{print $2}')

			branch_count=$(git branch | wc -l)
			if (( $branch_count > 1 )); then

				# git pull from all have branches
				# I want actual git log
				branches=$(git branch --format='%(refname:short)')
				for b in ${branches[*]}; do
					echo "git pull: $b"
					git checkout $b
					git $opt 2>/dev/null
				done

				# go back to the previous branch
				git checkout $current_branch
			else
				echo "git pull: $current_branch"
				git $opt 2>/dev/null
			fi
		else
			git $opt
		fi

		cd - >/dev/null
		echo
	done
}

case $1 in
	'--clone-my')
		private_projects=$(ssh rserver-git 'ls projects')
		for name in ${private_projects[*]}; do
			if [ ! -d $name ]; then
				git clone rserver-git:projects/$name
				echo
			fi
		done

		public_projects=(binout typp bootstrap-env glibc-with-shred)
		for name in ${public_projects[*]}; do
			if [ ! -d $name ]; then
				git clone git@github.com:iikrllx/$name
				echo
			fi
		done
	;;

	'--pull-my') git_action $myenv "Pull" "pull" ;;
	'--status-my') git_action $myenv "Status" "status" ;;

	*) usage ;;
esac
