export ZSH=$HOME/.oh-my-zsh
export GOPATH=/usr/local/go
export CARGO_HOME=/usr/local/cargo
export PATH=$PATH:$GOPATH/bin:$CARGO_HOME/bin

ZSH_THEME="robbyrussell"
plugins=(git docker autojump kubectl)

source $ZSH/oh-my-zsh.sh

source <(kubectl completion zsh)
[ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
