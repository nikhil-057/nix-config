## Set WORKDIR
if [ -z "$WORKDIR" ]; then
    export WORKDIR="$HOME"
fi
cd "$WORKDIR"

alias vim=nvim
