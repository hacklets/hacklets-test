#!/bin/bash

#TODO: error checking throughout the file

mkdir -p .hacklets/hacklets.git
git clone --bare git://github.com/hacklets/hacklets-test.git .hacklets/hacklets.git
ln -s hacklets.git .hacklets/master
git --git-dir=.hacklets/master config core.bare false
git --git-dir=.hacklets/master config core.worktree "../../"
git --git-dir=.hacklets/master checkout

echo "Your real name will be used as a display name in your commits, on github, and in any similar situations."
SUGGEST=`getent passwd "$USER" | cut -d ':' -f 5`
read -e -p "Your real name: " -i "${SUGGEST}" REAL_NAME
echo "Your e-mail should be the same as the one used to register on github, for easier github integration."
read -e -p "Your E-Mail: " -i "${USER}@${HOSTNAME}" EMAIL

source bin/scripts.d/bsfl

cmd "git config --global user.email ${EMAIL}"
cmd "git config --global user.name '${REAL_NAME}'"
