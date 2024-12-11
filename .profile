## Set WORKDIR
if [ -z "$WORKDIR" ]; then
    export WORKDIR="$HOME"
fi
cd "$WORKDIR"

export PATH="$PATH:/opt/nvim-linux64/bin"
