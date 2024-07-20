## Set WORKDIR
if [ -z "$WORKDIR" ]; then
    export WORKDIR="$HOME"
fi
cd "$WORKDIR"

alias python=python3
export PATH="$PATH:/opt/nvim-linux64/bin"
alias vim=nvim

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
