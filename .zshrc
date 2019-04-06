export ZSH=$HOME/.oh-my-zsh
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin 

ZSH_THEME="robbyrussell"
plugins=(git kubectl docker autojump)


source $ZSH/oh-my-zsh.sh

source <(kubectl completion zsh)
[ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases

alias e="~/.launch-emacs.sh"
alias emacsd="emacs --daemon"
