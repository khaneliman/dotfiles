#!/usr/bin/env sh

usage() {
	echo "show-ansi-colors <n>"
	exit 0
}

(( $# < 1 )) && usage

show_ansi_colors() {
	local colors=$1
	echo "showing $colors ansi colors:"
	for (( n=0; n < $colors; n++ )) do
		printf " [%d] $(tput setaf $n)%s$(tput sgr0)" $n "wMwMwMwMwMwMwMwMwMwMwMwMwMwMwMwMwMwMwMwMwMwMw
"
	done
	echo
}

show_ansi_colors "$@"
