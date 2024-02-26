#!/bin/bash

UNIFORM_LENGHT=4


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

