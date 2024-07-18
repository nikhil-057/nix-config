## nvim setup

```
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

wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
nvm install v20.15.1
nvm use --delete-prefix v20.15.1
nvm alias default v20.15.1
npm install -g neovim
npm install -g tree-sitter-cli

wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz
tar -zxpf luarocks-3.11.1.tar.gz
cd luarocks-3.11.1
./configure && make && sudo make install
sudo luarocks install luasocket

./setup.sh
source ~/.bashrc
```
