#!/bin/bash
#copy pasted from the arch linux wiki: https://wiki.archlinux.org/index.php/feh#File_Browser_Image_Launcher
shopt -s nullglob

if [[ ! -f $1 ]]; then
	echo "$0: first argument is not a file" >&2
	exit 1
fi

file=$(basename -- "$1")
dir=$(dirname -- "$1")
arr=()
shift

cd -- "$dir"

for i in *; do
	[[ -f $i ]] || continue
	arr+=("$i")
	[[ $i == $file ]] && c=$((${#arr[@]} - 1))
done

exec feh --scale-down"$@" -- "${arr[@]:c}" "${arr[@]:0:c}"
