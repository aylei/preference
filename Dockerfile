FROM spacemacs/emacs-snapshot:develop

# Basics packages
RUN apt-get update \
    && apt-get install zsh \
    && apt-get install silversearcher-ag \
    && apt-get install autojump \
    && apt-get install curl \
    && apt-get install wget \
# Cleanup
    && apt-get autoremove \
    && rm -rf /tmp/* /var/lib/apt/lists/* /root/.cache/*

# Setup Go Environment
ENV GO_VERSION="1.12.4"
RUN curl -fsSL https://golang.org/dl/go$GO_VERSION.linux-amd64.tar.gz -o golang.tar.gz \
    && tar -C /usr/local -xzf golang.tar.gz \
    && rm golang.tar.gz \
    && export GOPATH=${UHOME}/go \
    && export GOROOT=/usr/local/go \
    && export PATH=$GOPATH/bin:$GOROOT/bin:$PATH \
    && asEnvUser go get -u -v github.com/nsf/gocode \
    && asEnvUser go get -u -v github.com/rogpeppe/godef \
    && asEnvUser go get -u -v golang.org/x/tools/cmd/guru \
    && asEnvUser go get -u -v golang.org/x/tools/cmd/gorename \
    && asEnvUser go get -u -v golang.org/x/tools/cmd/goimports

# Setup Rust Enviroment
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.34.0

RUN wget https://static.rust-lang.org/rustup/archive/1.17.0/x86_64-unknown-linux-gnu/rustup-init \
    && chmod +x rustup-init \
    && ./rustup-init -y --no-modify-path --default-toolchain $RUST_VERSION \
    && rm ./rustup-init \
    && chmod -R a+w $RUSTUP_HOME $CARGO_HOME

# Install some tools using git
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ${UHOME}/.fzf \
    && ${UHOME}/.fzf/install \
# Docker
    && wget https://experimental.docker.com/builds/Linux/x86_64/docker-1.12.0.tgz \
    && tar zxvf docker-1.12.0.tgz docker \
    && mv docker /usr/local/bin/ \
    && rm docker-1.12.0.tgz \
# oh-my-zsh
    && asEnvUser wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# Spacemacs
COPY spacemacs ${UHOME}/.spacemacs
RUN chmod ug+rw ${UHOME}/.spacemacs \
    && asEnvUser emacs -batch -u ${UNAME} -kill \
    && asEnvUser emacs -batch -u ${UNAME} -kill \
    && chmod ug+rw -R ${UHOME}

# zshrc
COPY zshrc-base.sh ${UHOME}/.zshrc

# kubectl
COPY kubectl_aliases ${HOME}/.kubectl_aliases
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    chmod +x ./kubectl \
    mv ./kubectl /usr/local/bin/kubectl

# Spacemacs rust env
RUN export PATH=$PATH:/usr/local/cargo/bin \
    && asEnvUser rustup component add rustfmt \
    && asEnvUser rustup toolchain add nightly \
    && asEnvUser cargo +nightly install racer

WORKDIR /home/emacs

CMD ["zsh", "-l"]
