FROM debian:stable

ADD https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage nvim.appimage

ADD https://golang.org/dl/go1.16.5.linux-amd64.tar.gz go.tar.gz

RUN tar -C /usr/local -xzf go.tar.gz

RUN ln -s /usr/local/go/bin/go /usr/bin/go

RUN chmod +x nvim.appimage

RUN apt update

RUN apt install git curl npm python3 php composer \
    php-curl php-xml python3-pip -y

RUN mkdir /root/.config

RUN mkdir -p /root/.local/bin

RUN git clone https://github.com/lalanikarim/nvim-config.git /root/.config/nvim

RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

RUN bash ~/.config/nvim/install-language-servers.sh

ENV PATH="/root/.local/bin:/usr/local/go/bin:${PATH}"

RUN GO111MODULE=on go get golang.org/x/tools/gopls@latest

RUN /nvim.appimage --appimage-extract-and-run -u ~/.config/nvim/plugins.vim -c ":PlugInstall|:q|:q"

