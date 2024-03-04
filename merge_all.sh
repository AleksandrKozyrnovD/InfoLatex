#!/bin/bash

WHITE='\033[1;37m'
BLUE='\033[1;34m'
RED='\033[1;31m'
GREEN='\033[1;32m'
BOLD='\033[1m'
RESET='\033[0;0m'

dd=`date +"%D %T"`

#Updating old branch -> commiting whatever was made
git add .
git status
git commit -m "${dd} switching to master"
echo -e "${WHITE}Switching${RED} to ${BLUE}master${RESET}"
git checkout master 2> /dev/null


for branch in $(git for-each-ref --format='%(refname:short)'); do
     git merge $branch
done
