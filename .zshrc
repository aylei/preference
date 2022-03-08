export ZSH=$HOME/.oh-my-zsh
export GOPATH=$HOME/go
export PYPATH=$HOME/Library/Python/3.7
export PATH=$PATH:$GOPATH/bin:$PYPATH/bin:/usr/local/apiserver-builder/bin/:/usr/local/kubebuilder/bin:$HOME/.ideabin
export PATH=$PATH:/Users/alei/.pulumi/bin
export PATH=$PATH:/Users/alei/go/src/github.com/pingcap/ticat/bin

ZSH_THEME="robbyrussell"
plugins=(git kubectl docker autojump osx virtualenv)


source $ZSH/oh-my-zsh.sh

source <(kubectl completion zsh)
[ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases

alias e="~/.launch-emacs.sh"
alias emacsd="emacs --daemon"

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
if hash tkctl 2>/dev/null; then source <(tkctl completion zsh); fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/google-cloud-sdk/path.zsh.inc' ]; then . '/usr/local/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/google-cloud-sdk/completion.zsh.inc' ]; then . '/usr/local/google-cloud-sdk/completion.zsh.inc'; fi
export PATH=/Users/alei/.tiup/bin:$PATH
setopt histignorealldups
export PATH=/Users/alei/.go-tpc/bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
complete -F __start_kubectl k
