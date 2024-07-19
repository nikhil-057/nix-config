## Nvim setup

```
## cd into the git repo before running the below
REPO_DIR=$PWD

## install packages
sudo apt-get update
sudo apt-get install \
    fd-find \
    ripgrep \
    unzip \
    lua5.1 \
    liblua5.1-dev \
    python3-pip \
    python3-venv \
    libevent-dev \
    ncurses-dev \
    build-essential \
    bison \
    pkg-config \
    --yes
pip3 install --user --break-system-packages --upgrade pynvim

## set workdir
if [ -z "$WORKDIR" ]; then
    export WORKDIR="$HOME"
fi

## tmux
mkdir -p $WORKDIR/install/tmux && cd $WORKDIR/install/tmux
wget -qO tmux-3.3a.tar.gz https://github.com/tmux/tmux/releases/download/3.3a/tmux-3.3a.tar.gz
tar -zxpf tmux-*.tar.gz
cd tmux-*/
./configure && make && sudo make install

## npm packages
mkdir -p $WORKDIR/install/npm && cd $WORKDIR/install/npm
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
nvm install v20.15.1
nvm use --delete-prefix v20.15.1
nvm alias default v20.15.1
npm install -g neovim
npm install -g tree-sitter-cli

## luarocks
mkdir -p $WORKDIR/install/luarocks && cd $WORKDIR/install/luarocks
wget -qO luarocks-3.11.1.tar.gz https://luarocks.org/releases/luarocks-3.11.1.tar.gz
tar -zxpf luarocks-*.tar.gz
cd luarocks-*/
./configure && make && sudo make install
sudo luarocks install luasocket

cd $REPO_DIR
./setup.sh
source ~/.bashrc
```
