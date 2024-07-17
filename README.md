## nvim setup

sudo apt update
sudo apt install fd-find --yes
sudo apt install ripgrep --yes
sudo apt install lua5.3 --yes

sudo apt install python3-pip --yes
sudo apt install python3-venv --yes
pip3 install --user --break-system-packages --upgrade pynvim

wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
nvm install v20.15.1
nvm use --delete-prefix v20.15.1
nvm alias default v20.15.1
npm install -g neovim
npm install -g tree-sitter-cli

./setup.sh
source ~/.bashrc
