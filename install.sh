#!/bin/bash

mkdir -p .hacklets/hacklets.git
git clone --bare git://github.com/hacklets/hacklets-test.git .hacklets/hacklets.git
ln -s hacklets.git .hacklets/master
git --git-dir=.hacklets/master config core.bare false
git --git-dir=.hacklets/master config core.worktree "../../"
git --git-dir=.hacklets/master checkout
