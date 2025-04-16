--------------------------------------------------------------------------------
-- Inspired by https://github.com/chrisgrieser/nvim-kickstart-python/blob/main/kickstart-python.lua

vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.number = true

-- https://stackoverflow.com/questions/1878974/redefine-tab-as-4-spaces
vim.opt_local.shiftwidth = 4
vim.opt_local.smarttab = true
vim.opt_local.expandtab = true
vim.opt_local.tabstop = 8
vim.opt_local.softtabstop = 0

-- remove \r after pasting from clipboard
-- https://neovim.io/doc/user/api.html#nvim_set_keymap()
vim.api.nvim_set_keymap("n", "\"+p", ("\"+p<cmd>%s/\\r//g<cr>"), {})
vim.api.nvim_set_keymap("n", "\"+P", ("\"+P<cmd>%s/\\r//g<cr>"), {})

-- BOOTSTRAP the plugin manager `lazy.nvim`
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim"
    vim.system({ "git", "clone", "--filter=blob:none", lazyrepo, "--branch=stable", lazypath }):wait()
end
vim.opt.runtimepath:prepend(lazypath)

--------------------------------------------------------------------------------

local plugins = {
    -- TOOLING: COMPLETION, DIAGNOSTICS, FORMATTING

    -- Colorscheme
    -- In neovim, the choice of color schemes is unfortunately not purely
    -- aesthetic – treesitter-based highlighting or newer features like semantic
    -- highlighting are not always supported by a color scheme. It's therefore
    -- recommended to use one of the popular, and actively maintained ones to get
    -- the best syntax highlighting experience:
    -- https://dotfyle.com/neovim/colorscheme/top
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                style = "moon", -- or "night", "storm", "day"
                transparent = false,
                styles = {
                    comments = { italic = false },
                    keywords = { italic = false },
                    functions = {},
                    variables = {},
                },
                on_highlights = function(hl, c)
                    -- Override 'Special' group to match 'Normal' to disable red highlighting
                    hl.Special = { fg = c.fg, bg = c.bg }
                end,
            })
            vim.cmd.colorscheme("tokyonight")
        end,
    },

    -- Manager for external tools (LSPs, linters, debuggers, formatters)
    -- auto-install of those external tools
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = {
            { "williamboman/mason.nvim", opts = true },
            { "williamboman/mason-lspconfig.nvim", opts = true },
        },
        opts = {
            ensure_installed = {
                "basedpyright", -- LSP for python
                "ruff-lsp", -- linter for python (includes flake8, pep8, etc.)
                "debugpy", -- debugger
                "black", -- formatter
                "isort", -- organize imports
                "taplo", -- LSP for toml (for pyproject.toml files)
            },
        },
    },

    -----------------------------------------------------------------------------
    -- SYNTAX HIGHLIGHTING & COLORSCHEME

    -- treesitter for syntax highlighting
    -- - auto-installs the parser for python
    {
        "nvim-treesitter/nvim-treesitter",
        -- automatically update the parsers with every new release of treesitter
        build = ":TSUpdate",

        -- since treesitter's setup call is `require("nvim-treesitter.configs").setup`,
        -- instead of `require("nvim-treesitter").setup` like other plugins do, we
        -- need to tell lazy.nvim which module to via the `main` key
        main = "nvim-treesitter.configs",

        opts = {
            highlight = { enable = true }, -- enable treesitter syntax highlighting
            indent = { enable = true }, -- better indentation behavior
            ensure_installed = {
                -- auto-install the Treesitter parser for required languages
                "python",
                "toml",
                "rst",
                "ninja",
                "markdown",
                "markdown_inline",
                "vimdoc",
                "bash",
                "nix",
            },
        },
    },

    -----------------------------------------------------------------------------
    -- EDITING SUPPORT PLUGINS
    -- some plugins that help with python-specific editing operations

    -- Support for docstring creation
    -- - quickly create docstrings via `<leader>a`
    {
        "danymat/neogen",
        opts = true,
        keys = {
            {
                "<leader>a",
                function() require("neogen").generate() end,
                desc = "Add Docstring",
            },
        },
    },

    -- Support for comments
    -- - Visual mode: select the lines and press gc to toggle comments.
    -- - Normal mode: gcc to comment a line; gcip to comment a paragraph.
    {
      "numToStr/Comment.nvim",
      lazy = false,
      config = function()
          require("Comment").setup()
      end
    },

    -- navigate seamlessly between vim and tmux splits using a consistent set of hotkeys
    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
        },
        keys = {
            { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
            { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
        },
        init = function()
            -- write all buffers before navigating from vim to tmux pane
            vim.g.tmux_navigator_save_on_switch = 2
        end,
    },

    -- easily interact with tmux from vim
    {
        "preservim/vimux",
        cmd = {
            "VimuxPromptCommand",
            "VimuxRunLastCommand",
            "VimuxInspectRunner",
            "VimuxCloseRunner",
            "VimuxInterruptRunner",
            "VimuxZoomRunner",
            "VimuxClearTerminalScreen",
            "VimuxRunCommand",
        },
        keys = {
            -- reference: https://raw.githubusercontent.com/preservim/vimux/master/doc/vimux.txt
            { "<leader>vp", "<cmd>VimuxPromptCommand<cr>", mode = "" },
            { "<leader>vl", "<cmd>VimuxRunLastCommand<cr>", mode = "" },
            { "<leader>vi", "<cmd>VimuxInspectRunner<cr>", mode = "" },
            { "<leader>vq", "<cmd>VimuxCloseRunner<cr>", mode = "" },
            { "<leader>vx", "<cmd>VimuxInterruptRunner<cr>", mode = "" },
            { "<leader>vz", "<cmd>call VimuxZoomRunner()<cr>", mode = "" },
            { "<leader>v<C-l>", "<cmd>VimuxClearTerminalScreen<cr>", mode = "" },
            { "<leader>vs", "\"vy<cmd>call VimuxRunCommand(@v)<cr>", mode = "v" },
            { "<leader>vs", "vip\"vy<cmd>call VimuxRunCommand(@v)<cr>", mode = "n" },
        },
    },
}

--------------------------------------------------------------------------------

-- tell lazy.nvim to load and configure all the plugins
require("lazy").setup({
    spec = plugins,
    rocks = {
        enabled = false,
    },
})
