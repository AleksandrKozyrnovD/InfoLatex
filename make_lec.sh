#!/bin/bash

WHITE='\033[1;37m'
BLUE='\033[1;34m'
RED='\033[1;31m'
GREEN='\033[1;32m'
BOLD='\033[1m'
RESET='\033[0;0m'

UNIFORM_LENGHT=4
dd=`date +"%D %T"`


if [ "$#" -ne 1 ]; then
    echo "USAGE: ./make_lec.sh <folder>"
    exit 1
fi

directory=$1

if [ ! -d "$directory" ]; then
    echo Directory "$directory" does not exists!
    exit 1
fi


num=0
maxnum=0
num_for_next_lecture=0
for file in ./"$directory"/lectures/*.tex; do
    num=$(echo "$file" | grep -o '[0-9]*')
    if [[ -z "$num" ]]; then
        echo "None of lectures before recorded..."
        break
    fi
    while [ "${num::1}" -eq "0" ]; do
        num="${num:1}"
        if [[ -z "$num" ]]; then
            echo "Null num"
            break
        fi
    done
    if [ "$num" -ge "$maxnum" ]; then
        maxnum=$num
    fi
done
num_for_next_lecture="$(($maxnum + 1))"

uniform_num=$num_for_next_lecture

#Creating uniform num. Will look line lec_0004 or lec_0012
while [ ${#uniform_num} -lt "$UNIFORM_LENGHT" ]; do
    uniform_num="0""$uniform_num"
done

#Updating old branch -> commiting whatever was made
git add .

git status

git commit -m "${dd} switching to _${directory}"

echo -e "${WHITE}Switching${RED} to ${BLUE}_${directory}${RESET}"

git checkout _$directory 2> /dev/null
return=$?

if [ $return -ne 0 ]; then
    echo -e "${RED}No branch before${RESET}"
    git branch _$directory
    git checkout _$directory
fi

#New tex file
touch ./"$directory"/lectures/lec_"$uniform_num".tex

#Symlinks created here
ln -sf ./"$directory"/lectures/lec_"$uniform_num".tex ./current.tex
ln -sf ./"$directory"/preamble.tex preamble.tex

#if template exists
if [ -f ./"$directory"/template.tex ]; then
    cat ./"$directory"/template.tex >> ./current.tex
fi

