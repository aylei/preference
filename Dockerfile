FROM spacemacs/emacs-snapshot:develop

# Basics packages
RUN apt-get install zsh \
    && apt-get install silversearcher-ag \
    && apt-get install autojump \
# Cleanup
    && apt-get autoremove \
    && rm -rf /tmp/* /var/lib/apt/lists/* /root/.cache/*

# Install from git
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ${UHOME}/.fzf \
    && asEnvUser ${UHOME}/.fzf/install \
# Docker
    && curl -sSL https://experimental.docker.com/builds/Linux/x86_64/docker-1.12.0.tgz \
    && tar zxvf docker-1.12.0.tgz docker \
    && mv docker /usr/local/bin/ \
    && rm docker-1.12.0.tgz \
# oh-my-zsh
    && asEnvUser sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Setup Go Environment
ENV GO_VERSION="1.12.4"
RUN curl -fsSL https://golang.org/dl/go$GO_VERSION.linux-amd64.tar.gz -o golang.tar.gz \
    && tar -C /usr/local -xzf golang.tar.gz \
    && rm golang.tar.gz \
    && asEnvUser go get -u -v github.com/nsf/gocode
    && asEnvUser go get -u -v github.com/rogpeppe/godef
    && asEnvUser go get -u -v golang.org/x/tools/cmd/guru
    && asEnvUser go get -u -v golang.org/x/tools/cmd/gorename
    && asEnvUser go get -u -v golang.org/x/tools/cmd/goimports

# Setup Rust Enviroment
RUN asEnvUser curl https://sh.rustup.rs -sSf | sh \
    && asEnvUser rustup component add rustfmt \
    && asEnvUser rustup toolchain add nightly \
    && asEnvUser cargo +nightly install racer

# Spacemacs
COPY .spacemacs ${UHOME}/.spacemacs \
     && asEnvUser emacs -batch -u ${UNAME} -kill \
     && asEnvUser emacs -batch -u ${UNAME} -kill \
     && chmod ug+rw -R ${UHOME}

# zshrc
COPY .zshrc ${UHOME}/.zshrc

WORKDIR /home/emacs

CMD ["zsh", "-l"]
