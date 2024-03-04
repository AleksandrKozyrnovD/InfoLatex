#!/bin/bash

WHITE='\033[1;37m'
BLUE='\033[1;34m'
RED='\033[1;31m'
GREEN='\033[1;32m'
BOLD='\033[1m'
RESET='\033[0;0m'

UNIFORM_LENGHT=4
dd=`date +"%D %T"`

if [ "$#" -ne 2 ]; then
    echo "USAGE: ./edit_lec.sh <folder> <number of lecture>"
    exit 1
fi

directory=$1

if [ ! -d "$directory" ]; then
    echo Directory "$directory" does not exists!
    exit 1
fi

num=$2
uniform_num=$num

#Creating uniform num. Will look like lec_0004 or lec_0012
while [ ${#uniform_num} -lt "$UNIFORM_LENGHT" ]; do
    uniform_num="0""$uniform_num"
done

if [ ! -f ./"$directory"/lectures/lec_"$uniform_num".tex ]; then
    echo "Lecture with that num does not exists!"
    exit 1
fi

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

#Symlinks created here
ln -sf ./"$directory"/lectures/lec_"$uniform_num".tex ./current.tex
ln -sf ./"$directory"/preamble.tex preamble.tex

