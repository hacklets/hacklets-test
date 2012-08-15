[ -z "$PS1" ] && return

alias vi=vim
alias fgrep='fgrep --exclude-dir=".svn"'

export EDITOR=vim
export VISUAL=vim

PS1='[\u@\h \W]\$ '

# TODO clean below
#
alias ls='ls++'
alias gvim='gvim --remote-silent --servername main-gvim'
alias vim='vim --servername main-vim'


#export GOPATH=~/projects/temp/golang/gopath

