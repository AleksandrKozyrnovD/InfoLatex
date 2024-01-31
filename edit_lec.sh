#!/bin/bash

UNIFORM_LENGHT=4


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


#Symlinks created here
ln -sf ./"$directory"/lectures/lec_"$uniform_num".tex ./current.tex
ln -sf ./"$directory"/preamble.tex preamble.tex

