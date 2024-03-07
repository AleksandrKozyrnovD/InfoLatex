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
    echo "USAGE: ./make_master.sh <folder>"
    exit 1
fi

directory=$1

if [ ! -d "$directory" ]; then
    echo Directory "$directory" does not exists!
    exit 1
fi

if [ ! -f ./"$directory"/template_master.tex ]; then
    echo In directory can not find \<template_master.tex\>!
    exit 1
fi

#Updating old branch -> commiting whatever was made
#git add .
#git status
#git commit -m "${dd} switching to _${directory}"
#echo -e "${WHITE}Switching${RED} to ${BLUE}_${directory}${RESET}"
#git checkout _$directory 2> /dev/null
#return=$?

#if [ $return -ne 0 ]; then
#    echo -e "${RED}No branch before${RESET}"
#    git branch _$directory
#    git checkout _$directory
#fi

rm ./"$directory"/master/*.tex 2> /dev/null

MASTER=./"$directory"/master/master.tex
cat ./"$directory"/template_master.tex > $MASTER
num=0
echo "\\begin{document}" >> $MASTER
for file in ./"$directory"/lectures/*.tex; do
    cat $file > ./"$directory"/master/"$num".tex
    sed '1,7d' ./"$directory"/master/"$num".tex > ./test.txt
    sed '$d' ./test.txt > ./"$directory"/master/"$num".tex
    
    echo -e "\\include*{$num}" >> $MASTER

    num=$(($num+1))
done
rm test.txt
echo "\\end{document}" >> $MASTER

# ln -sf ./"$directory"/preamble.tex ./"$directory"/master/preamble.tex
cp ./"$directory"/preamble.tex ./"$directory"/master/preamble.tex

