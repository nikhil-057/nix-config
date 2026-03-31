# nix-config

Personal portable dev environment managed with [Home Manager](https://github.com/nix-community/home-manager) and [npins](https://github.com/andir/npins). No flakes, no NixOS — runs on any Linux machine with `nix` installed.

---

## Quick Start

### Bootstrap on a fresh machine

```bash
"$(nix-build --quiet --no-out-link -A setupHomeManager \
  https://github.com/nikhil-057/nix-config/archive/refs/tags/v8.6.tar.gz)/bin/setup-home-manager"
```

This downloads the pinned config from the tagged release, builds it, and activates it in one shot.

### Update from local clone

```bash
./setup/hm.sh
```

### Use pinned nixpkgs in a nix-shell

```bash
NIX_PATH="$("$(nix-build --quiet --no-out-link -A echoNixPath \
  https://github.com/nikhil-057/nix-config/archive/refs/tags/v8.6.tar.gz)/bin/echo-nix-path")" \
  nix-shell -p hello --run hello
```

---

## Architecture

```
nix-config/
├── default.nix                  # Builds setupHomeManager script (entry point)
├── home-manager/
│   ├── home.nix                 # All packages, dotfiles, git/ssh/tool configs
│   ├── setup-hook.sh            # Bootstrap: symlinks config, runs nix-shell
│   ├── shell.nix                # nix-shell that runs `home-manager init --switch`
│   └── dotfiles/
│       ├── init.lua             # Neovim config (lazy.nvim, LSP, treesitter, etc.)
│       ├── tmux.conf            # tmux (vi keys, vim-tmux-navigator, pane splits)
│       ├── zshrc                # Zsh + Oh My Zsh (robbyrussell, git plugin)
│       ├── profile              # POSIX env vars, aliases, AWS credentials sourcing
│       └── containers-policy.json  # Podman/skopeo: accept any image
├── npins/
│   ├── default.nix              # npins fetcher logic (auto-generated)
│   └── sources.json             # Pinned: nixpkgs, home-manager fork, nixvim
└── setup/
    ├── hm.sh                    # Local install/update shortcut
    └── npins.sh                 # Re-initialize all npins pins
```

### Bootstrap flow

1. `default.nix` builds a `setup-home-manager` script with a pinned `NIX_PATH`.
2. The script runs `home-manager/setup-hook.sh`:
   - Symlinks `~/.config/home-manager` → the `home-manager/` dir in this repo
   - Removes `~/.gitconfig` so Home Manager can own it
   - Invokes `nix-shell` via `shell.nix`
3. `shell.nix` activates the config: `home-manager init --switch --no-flake -b backup`

### Dependency pinning (npins)

Three sources are pinned in `npins/sources.json`:

| Pin | Source | Branch |
|-----|--------|--------|
| `nixpkgs` | `nixos/nixpkgs` | `nixos-unstable` |
| `home-manager` | `nikhil-057/home-manager` | `customizable-shellhook` |
| `nixvim` | `nix-community/nixvim` | `main` (reserved) |

The `home-manager` pin is a personal fork that enables a configurable `shellHook` in the installer.

---

## Installed Packages

### Shell & Terminal
- `zsh` + `oh-my-zsh` (robbyrussell theme, git plugin)
- `tmux`

### Editor
- `neovim` + `tree-sitter`

### Build Tools
- `gcc`, `gnumake`, `cmake`, `pkg-config`

### Languages & Runtimes
- `python311`, `nodejs_22`, `jdk17`, `typescript`

### Python Dev
- `poetry`, `uv`, `black`, `isort`, `ruff`, `basedpyright`

### LSP / Linting
- `typescript-language-server`
- `sonarlint-ls` + `vimPlugins.sonarlint-nvim`
- `taplo` (TOML)

### Cloud & Containers
- `awscli2`, `docker-client`

### Databases
- `mysql84`, `neo4j`

### Utilities
- `ripgrep`, `fd`, `jq`, `wget`, `unzip`, `coreutils`, `gnused`, `procps`
- `openssl.dev`, `curlFull.dev`, `openssh`, `xauth`, `groff`, `glibc`

### AI
- `opencode` (configured to use AWS Bedrock / Claude Sonnet)

---

## Dotfiles & Config

### Shell (`dotfiles/profile`)
- `LANG=C.UTF-8`, `LC_ALL=C.UTF-8`
- `XAUTHORITY=$HOME/.Xauthority` (X11 over SSH fix)
- `alias vim=nvim`
- Auto-cd to `$HOME` if started outside it
- Sources `hm-session-vars.sh` and `~/.profile.d/aws-config.sh`

### AWS credentials (`home.nix` — generated at `~/.profile.d/aws-config.sh`)
Place credentials at `~/.aws/credentials.json`:
```json
{
  "AccessKeyId": "...",
  "SecretAccessKey": "...",
  "SessionToken": "..."
}
```
`AWS_DEFAULT_REGION` is set to `us-west-2`.

### Session variables (from `home.nix`)
| Variable | Purpose |
|----------|---------|
| `PKG_CONFIG_PATH` | OpenSSL pkg-config path |
| `CFLAGS` | OpenSSL include flags |
| `LDFLAGS` | OpenSSL lib flags |
| `LD_LIBRARY_PATH` | GCC shared libs |
| `SONARLINT_PLUGINS` | SonarLint plugin jar directory |

### Git (`home.nix`)
- `user.name`: `nikhil`, `core.editor`: `nvim`
- 3-way merge with `nvim -d $LOCAL $BASE $REMOTE $MERGED`
- `safe.directory = ["*"]` (trusts all dirs, useful in containers)

### SSH (`home.nix`)
- ControlMaster + ControlPersist 10 minutes for all hosts
- `git.blackhawknetwork.com`: StrictHostKeyChecking disabled

### Poetry
- `virtualenvs.in-project = true` — venvs live inside project dirs

### OpenCode (`~/.config/opencode/`)
- Model: `bedrock/anthropic.claude-sonnet-4-5-20250929-v1:0`
- TUI split: disabled

---

## Neovim

Config lives at `dotfiles/init.lua`. Plugin manager: [lazy.nvim](https://github.com/folke/lazy.nvim) (auto-bootstrapped).

### Plugins
| Plugin | Role |
|--------|------|
| `tokyonight.nvim` | Colorscheme (moon style) |
| `nvim-treesitter` | Syntax highlighting + indentation |
| `neogen` | Docstring generator |
| `Comment.nvim` | Toggle comments |
| `vim-tmux-navigator` | Seamless vim/tmux pane navigation |
| `vimux` | Run commands in tmux pane from vim |
| `telescope.nvim` | Fuzzy file/text finder |
| `nvim-cmp` | Autocomplete (LSP + buffer + path) |
| `codediff.nvim` | Git diff viewer |
| `nvim-tree.lua` | File explorer sidebar |
| `sonarlint.nvim` | SonarLint diagnostics (Python) |

### LSP
- `basedpyright` — Python type checking
- `tsserver` — TypeScript/JavaScript
- `ruff` — Python linting (hover disabled to avoid conflict)
- `sonarlint-ls` — Python rules S1481 (unused vars), S1523 (eval)

### Key mappings

| Key | Action |
|-----|--------|
| `<leader>a` | Generate docstring |
| `<leader>e` | Toggle file explorer |
| `<leader>ff` | Telescope: find files |
| `<leader>fg` | Telescope: live grep |
| `<leader>df` | Diff current file vs HEAD |
| `<leader>dr` | Diff HEAD vs working tree |
| `<leader>dc` | Diff HEAD~1 vs HEAD |
| `<leader>vp` | Vimux: prompt command |
| `<leader>vl` | Vimux: run last command |
| `<leader>vs` | Vimux: run selection/paragraph |
| `<leader>vi/vq/vx/vz` | Vimux: inspect/close/interrupt/zoom |
| `gd` | Go to definition (LSP) |
| `[d` / `]d` | Prev/next diagnostic |
| `Ctrl+H/J/K/L` | Navigate vim/tmux panes |

---

## tmux

Config at `dotfiles/tmux.conf`.

- Vi mode keys, 256-color, 10ms escape time
- Shell: `~/.nix-profile/bin/zsh`
- `|` → horizontal split (current path), `_` → 40% vertical split
- `[` / `]` → copy mode / paste buffer
- Vi copy: `v` select, `y` copy, `q` cancel
- `Ctrl+H/J/K/L` → smart pane switch (vim-aware)
- `Ctrl+G` in OpenCode panes → sends `Ctrl+J` (submit line)

---

## Updating pins

```bash
./setup/npins.sh   # re-initialize all pins from scratch
```

Or update individual pins manually:
```bash
npins update nixpkgs
npins update home-manager
```

---

## Tagging a release

Tags are used in the remote bootstrap URL. After testing:
```bash
git tag v<X.Y>
git push origin v<X.Y>
```

Then update the tag in this README's bootstrap commands.
