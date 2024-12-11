## nvim setup

```
sudo apt-get update
sudo apt-get install fd-find --yes
sudo apt-get install ripgrep --yes
sudo apt-get install unzip --yes

sudo apt-get install lua5.3 --yes
sudo apt-get install liblua5.3-dev --yes
sudo apt-get install python3-pip --yes
sudo apt-get install python3-venv --yes
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
