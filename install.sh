#!/bin/bash

#TODO: error checking throughout the file

[ ! -d .hacklets/hacklets.git ] && mkdir -p .hacklets/hacklets.git
[ ! -f .hacklets/hacklets.git/config ] && /usr/bin/git clone -b master --bare git://github.com/hacklets/hacklets-test.git .hacklets/hacklets.git
[ ! -h .hacklets/master ] && ln -s hacklets.git .hacklets/master

/usr/bin/git --git-dir=.hacklets/master config core.bare false
/usr/bin/git --git-dir=.hacklets/master config core.worktree "../../"
/usr/bin/git --git-dir=.hacklets/master checkout

echo "Your real name will be used as a display name in your commits, on github, and in any similar situations."
SUGGEST=`getent passwd "$USER" | cut -d ':' -f 5`
read -e -p "Your real name: " -i "${SUGGEST}" REAL_NAME
echo "Your e-mail should be the same as the one used to register on github, for easier github integration."
read -e -p "Your E-Mail: " -i "${USER}@${HOSTNAME}" EMAIL

source bin/scripts.d/bsfl

/usr/bin/git config --replace-all --global user.email "${EMAIL}"
if [[ 0 != $? ]]; then 
    msg_fail "git config --replace-all --global user.email '${EMAIL}'"
    return $?;
else
    msg_ok "git config --replace-all --global user.email '${EMAIL}'"
fi

/usr/bin/git config --replace-all --global user.name "${REAL_NAME}"
if [[ 0 != $? ]]; then 
    msg_fail "git config --replace-all --global user.name '${REAL_NAME}'"
    return $?;
else
    msg_ok "git config --replace-all --global user.name '${REAL_NAME}'"
fi

source .bash_profile
hacklets_cmd ci -am "installation of hacklets finished"

echo "We are going to relogin you on your system, please provide your password"
su - `whoami`
