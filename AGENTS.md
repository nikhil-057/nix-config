# agents.md — AI Agent Context for nix-config

This file gives AI coding agents everything they need to work effectively in this repository without re-exploring the codebase from scratch.

---

## What this repo is

A **personal portable developer environment** managed with [Home Manager](https://github.com/nix-community/home-manager) and [npins](https://github.com/andir/npins). It is **not** a NixOS system configuration — it is purely user-space and runs on any Linux machine with `nix` installed. No flakes are used.

The entire environment (shell, editor, tools, dotfiles) is reproducibly defined in Nix and can be bootstrapped on a fresh machine with a single command.

---

## Repository layout

```
nix-config/
├── default.nix                  # Top-level build: exposes setupHomeManager script
├── home-manager/
│   ├── home.nix                 # THE main config: packages, dotfiles, programs
│   ├── setup-hook.sh            # Bootstrap script: symlinks config, calls nix-shell
│   ├── shell.nix                # nix-shell entrypoint: runs home-manager init --switch
│   └── dotfiles/
│       ├── init.lua             # Full Neovim config (lazy.nvim)
│       ├── tmux.conf            # tmux config
│       ├── zshrc                # Zsh + Oh My Zsh
│       ├── profile              # POSIX env vars, aliases, AWS sourcing
│       └── containers-policy.json
├── npins/
│   ├── default.nix              # Auto-generated npins fetcher (DO NOT EDIT)
│   └── sources.json             # Pinned nixpkgs, home-manager, nixvim
└── setup/
    ├── hm.sh                    # Local install/update: runs nix-build + activates
    └── npins.sh                 # Re-initialize all npins pins
```

---

## Key files and their roles

### `home-manager/home.nix`
The single source of truth for the environment. Everything lives here:
- `home.packages` — all installed tools and languages
- `home.file` — dotfile symlinks (nvim, tmux, zsh, profile, containers policy)
- `home.sessionVariables` — env vars (OpenSSL flags, SonarLint plugins path)
- `home.file.".profile.d/aws-config.sh"` — inline AWS credential loader
- `programs.git` — git config (name, editor, mergetool)
- `programs.ssh` — SSH client config (ControlMaster, host-specific rules)
- `xdg.configFile."pypoetry/config.toml"` — Poetry: in-project venvs
- `xdg.configFile."opencode/opencode.json"` — OpenCode: AWS Bedrock model
- `xdg.configFile."opencode/tui.json"` — OpenCode: split disabled

### `home-manager/dotfiles/init.lua`
Full Neovim configuration. Uses `lazy.nvim` (auto-bootstrapped on first run). Defines all plugins, LSP servers, and key mappings.

### `home-manager/dotfiles/tmux.conf`
tmux config with vi keys, vim-tmux-navigator integration, custom pane splits, and an `opencode`-aware `Ctrl+G` binding.

### `home-manager/dotfiles/profile`
POSIX shell profile sourced by zsh. Sets locale, `XAUTHORITY`, `alias vim=nvim`, re-sources `hm-session-vars.sh`, and loads AWS credentials.

### `npins/sources.json`
Pinned dependency versions. Three pins:
- `nixpkgs` → `nixos/nixpkgs` on `nixos-unstable`
- `home-manager` → `nikhil-057/home-manager` fork on `customizable-shellhook`
- `nixvim` → `nix-community/nixvim` on `main` (pinned but not yet wired in)

---

## Common tasks and how to do them

### Add a new package
Edit `home-manager/home.nix`, add to `home.packages`:
```nix
home.packages = [
  # ... existing packages ...
  pkgs.your-new-package
];
```
Then run `./setup/hm.sh` to activate.

### Add a new dotfile
1. Create the file at `home-manager/dotfiles/your-file`
2. Add a symlink in `home.nix`:
```nix
home.file = {
  # ... existing ...
  ".your-file".source = dotfiles/your-file;
};
```

### Add an inline config file
Use `home.file."path".text` for simple text or `xdg.configFile."path".text` for XDG config:
```nix
home.file.".myconfig".text = ''
  key = value
'';
```

### Add a session environment variable
```nix
home.sessionVariables = {
  MY_VAR = "value";
};
```

### Add a new Neovim plugin
Edit `home-manager/dotfiles/init.lua`. Add an entry to the `plugins` list following lazy.nvim spec:
```lua
{
  "author/plugin-name",
  config = function()
    require("plugin-name").setup({})
  end
}
```

### Add a new LSP server
1. Add the LSP binary to `home.packages` in `home.nix`
2. In `init.lua`, configure and enable:
```lua
vim.lsp.config("server-name", {
  cmd = { "server-binary", "--stdio" },
  capabilities = capabilities,
})
vim.lsp.enable("server-name")
```

### Update a pinned dependency
```bash
# Update a single pin
npins update nixpkgs

# Re-initialize all pins from scratch
./setup/npins.sh
```

### Tag a release (used in remote bootstrap URL)
```bash
git tag v<X.Y>
git push origin v<X.Y>
```

---

## Design constraints and conventions

1. **No flakes** — the repo intentionally avoids flakes for compatibility with plain `nix-shell` / `nix-build` workflows. All pinning is done via npins.

2. **No NixOS** — this is user-space only via Home Manager. There are no `configuration.nix` or NixOS module files.

3. **Single host, single user** — `home.username` and `home.homeDirectory` are read from `$USER` and `$HOME` env vars at build time, making it machine-agnostic.

4. **Forked home-manager** — the `home-manager` pin points to `nikhil-057/home-manager` on the `customizable-shellhook` branch. This fork enables a configurable `shellHook` in the installer (used in `shell.nix`). Do NOT change this to the upstream repo without adapting `shell.nix`.

5. **npins/default.nix is auto-generated** — never edit it manually. Use `npins` CLI to update `sources.json`.

6. **Dotfiles are symlinked from the Nix store** — after activation, files like `~/.config/nvim/init.lua` are read-only symlinks into `/nix/store/`. To edit them, edit the source in `home-manager/dotfiles/` and re-run `./setup/hm.sh`.

7. **One config file for everything** — resist splitting `home.nix` into modules unless the file becomes unmanageable. Simplicity is intentional.

---

## Installed toolchain summary

| Category | Tools |
|----------|-------|
| Shell | zsh, oh-my-zsh (robbyrussell, git plugin), tmux |
| Editor | neovim (lazy.nvim, full LSP setup) |
| Python | python311, poetry, uv, black, isort, ruff, basedpyright, sonarlint-ls |
| TypeScript/JS | nodejs_22, typescript, typescript-language-server |
| Java | jdk17 |
| Build | gcc, gnumake, cmake, pkg-config |
| Search | ripgrep, fd |
| Cloud | awscli2 (credentials via `~/.aws/credentials.json`) |
| Containers | docker-client (no daemon), podman policy: accept any image |
| Databases | mysql84, neo4j |
| AI | opencode (AWS Bedrock, Claude Sonnet) |
| Misc | jq, wget, unzip, curl, openssl, openssh, coreutils |

---

## Environment variables set by Home Manager

| Variable | Value / Purpose |
|----------|----------------|
| `PKG_CONFIG_PATH` | `${openssl.dev}/lib/pkgconfig` |
| `CFLAGS` | `-I${openssl.dev}/include` |
| `LDFLAGS` | `-L${openssl.out}/lib` |
| `LD_LIBRARY_PATH` | `${gcc.cc.lib}/lib` |
| `SONARLINT_PLUGINS` | Path to SonarLint plugin jars (used in `init.lua`) |
| `AWS_DEFAULT_REGION` | `us-west-2` (set in aws-config.sh) |
| `LANG` / `LC_ALL` | `C.UTF-8` (set in profile) |
| `XAUTHORITY` | `~/.Xauthority` (X11 over SSH) |

---

## Neovim key bindings reference

| Key | Action |
|-----|--------|
| `<leader>a` | Generate docstring (neogen) |
| `<leader>e` | Toggle file explorer (nvim-tree) |
| `<leader>ff` | Find files (telescope) |
| `<leader>fg` | Live grep (telescope) |
| `<leader>df` | Diff file vs HEAD (codediff) |
| `<leader>dr` | Diff HEAD vs working tree (codediff) |
| `[n]<leader>dc` | Diff HEAD~n vs HEAD (default n=1) (codediff) |
| `<leader>vp` | Vimux: prompt command |
| `<leader>vl` | Vimux: run last command |
| `<leader>vs` | Vimux: run visual selection or paragraph |
| `<leader>vi` | Vimux: inspect runner |
| `<leader>vq` | Vimux: close runner |
| `<leader>vx` | Vimux: interrupt runner |
| `<leader>vz` | Vimux: zoom runner |
| `gd` | Go to definition (LSP) |
| `Ctrl+I` | Jump back in jumplist (e.g. return from `gd`) |
| `Ctrl+O` | Jump forward in jumplist |
| `[d` / `]d` | Prev/next diagnostic |
| `<leader>e` | Open diagnostic float (in Python buffers: SonarLint) |
| `<leader>q` | Set diagnostic loclist |
| `gcc` | Toggle line comment |
| `gc` (visual) | Toggle comment on selection |
| `Ctrl+H/J/K/L` | Navigate vim/tmux panes |
| `Ctrl+Space` | Trigger autocomplete |
| `Tab` / `S-Tab` | Next/prev completion item |
| `Enter` | Confirm completion |

---

## tmux key bindings reference

| Key | Action |
|-----|--------|
| `prefix + \|` | Horizontal split (current path) |
| `prefix + _` | Vertical split 40% (current path) |
| `prefix + [` | Enter copy mode |
| `prefix + ]` | Paste buffer |
| `v` (copy mode) | Begin selection |
| `V` (copy mode) | Select line |
| `y` (copy mode) | Copy and exit |
| `q` (copy mode) | Cancel |
| `Ctrl+H/J/K/L` | Smart pane navigation (vim-aware) |
| `Ctrl+G` | In OpenCode panes: send newline (Ctrl+J); elsewhere: normal Ctrl+G |

---

## AWS credentials

AWS credentials are NOT stored in this repo. Place a JSON file at `~/.aws/credentials.json`:
```json
{
  "AccessKeyId": "ASIA...",
  "SecretAccessKey": "...",
  "SessionToken": "..."
}
```
The generated `~/.profile.d/aws-config.sh` exports these as `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`, and sets `AWS_DEFAULT_REGION=us-west-2`.

---

## What NOT to do

- Do not edit `npins/default.nix` — it is auto-generated by npins.
- Do not edit files in `~/.config/nvim/`, `~/.tmux.conf`, etc. directly — they are Nix store symlinks. Edit the sources in `home-manager/dotfiles/`.
- Do not add system-level NixOS configuration — this repo is user-space only.
- Do not switch to flakes without understanding the full bootstrap chain (especially the forked home-manager dependency).
- Do not commit `~/.aws/credentials.json` or any credentials to this repo.
