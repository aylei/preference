#!/usr/bin/env bash

cat << EOF
Let's spin up the...

 █████╗ ██╗     ███████╗██╗    ███████╗███╗   ██╗██╗   ██╗
██╔══██╗██║     ██╔════╝██║    ██╔════╝████╗  ██║██║   ██║
███████║██║     █████╗  ██║    █████╗  ██╔██╗ ██║██║   ██║
██╔══██║██║     ██╔══╝  ██║    ██╔══╝  ██║╚██╗██║╚██╗ ██╔╝
██║  ██║███████╗███████╗██║    ███████╗██║ ╚████║ ╚████╔╝
╚═╝  ╚═╝╚══════╝╚══════╝╚═╝    ╚══════╝╚═╝  ╚═══╝  ╚═══╝

EOF

PM=""
OS=""
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    OS="linux"
    # Prefer modern package manager...
    if hash dnf 2>/dev/null; then
        dnf update
        PM="dnf"
    elif hash apt-get 2>/dev/null; then
        apt-get update
        PM="apt-get"
    elif hash pacman 2>/dev/null; then
        PM="pacman -S"
    elif hash yum 2>/dev/null; then
        yum update
        PM="yum -y"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="darwin"
    PM="brew"
else
    echo "No package manager find!"
    exit 1
fi

# Check zsh
if ! command -v zsh >/dev/null 2>&1; then
    $PM install zsh
    if [[ $PM == "brew" ]]; then
        $PM install zsh-completions
    fi
fi

# Check git
if ! command -v git >/dev/null 2>&1; then
    if [[ $PM == "brew" ]]; then
        $PM install git
    else
        $PM install git-all
    fi
fi

# Check emacs
if ! command -v emacs >/dev/null 2>&1; then
    if [[ $PM == "brew" ]]; then
        $PM tap railwaycat/emacsmacport
        $PM install emacs-mac
    else
        $PM install emacs
fi

# Check ag
if ! command -v ag >/dev/null 2>&1; then
    if [[ $PM == "apt-get" ]]; then
        $PM install silversearcher-ag
    else
        $PM install the_silver_searcher
    fi
fi

# Check fzf
if ! command -v fzf >/dev/null 2>&1; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
fi

# Check aspell
if ! command -v aspell >/dev/null 2>&1; then
    $PM install aspell
fi

# Check autojump
if ! command -v autojump >/dev/null 2>&1; then
    $PM install autojump
fi

# Check docker-cli
if ! command -v docker >/dev/null 2>&1; then
    curl -sSL https://experimental.docker.com/builds/Linux/x86_64/docker-1.12.0.tgz
    tar zxvf docker-1.12.0.tgz docker
    mv docker /usr/local/bin/
    rm docker-1.12.0.tgz
fi

# Setup Go environment
if ! command -v go >/dev/null 2>&1; then
    GO_VERSION="1.12.4"
    curl -fsSL https://golang.org/dl/go$GO_VERSION.$OS-amd64.tar.gz -o golang.tar.gz
    tar -C /usr/local -xzf golang.tar.gz
    rm golang.tar.gz
fi

# Setup Rust environment
if ! command -v cargo >/dev/null 2>&1; then
    curl https://sh.rustup.rs -sSf | sh

    # tools
    rustup component add rustfmt
    rustup toolchain add nightly
    cargo +nightly install racer
fi

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install spacemacs
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

# Clone preference and link
git clone https://github.com/aylei/preference.git ~/.preference
[ -f ~/.spacemacs ] && rm ~/.spacemacs
ln -s ~/.preference/.spacemacs ~/.spacemacs
[ -f ~/.zshrc ] && rm ~/.zshrc
ln -s ~/.preference/.zshrc ~/.zshrc
