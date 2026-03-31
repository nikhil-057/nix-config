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
-- vim.lsp.set_log_level("debug")

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

    -----------------------------------------------------------------------------
    -- SYNTAX HIGHLIGHTING & COLORSCHEME

    -- treesitter for syntax highlighting
    -- - auto-installs required parsers
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.config").setup({
                -- enable syntax highlighting
                highlight = { enable = true },
                -- enable automatic indentation
                indent = { enable = true },
                -- automatically install missing parsers when entering buffer
                auto_install = true,
                -- list of parsers to always ensure are installed
                ensure_installed = {
                    "python",
                    "toml",
                    "rst",
                    "ninja",
                    "markdown",
                    "markdown_inline",
                    "vimdoc",
                    "bash",
                    "nix",
                    "lua",
                    "javascript",
                    "typescript",
                    "tsx",
                    "java",
                    "dockerfile",
                    "json",
                    "yaml",
                    "regex",
                    "gitignore",
                },
            })
        end,
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
        init = function()
            vim.g.VimuxRunnerQuery = { pane = "{right-of}" }
        end,
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

    -- fuzzy finder for files, text search, etc
    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" }
    },

    -- nvim-cmp: completion engine providing autocomplete suggestions
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
      config = function()
        local cmp = require("cmp")
        cmp.setup({
          completion = {
            autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping.select_next_item(),
            ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          }),
          sources = {
            { name = "nvim_lsp" },
            { name = "buffer" },
            { name = "path" },
          }
        })
      end
    },

    -- side-by-side diff viewer with git revision comparison and merge tool support
    {
      "esmuellert/codediff.nvim",
      dependencies = { "MunifTanjim/nui.nvim" },
      cmd = "CodeDiff",
    },

    -- File explorer sidebar for navigating the project directory tree
    {
      "nvim-tree/nvim-tree.lua",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("nvim-tree").setup()
      end
    },

    -- enable sonarlint for python
    {
        "schrieveslaach/sonarlint.nvim",
        url = "https://gitlab.com/schrieveslaach/sonarlint.nvim",
        ft = { "python", },
        dependencies = {
            "neovim/nvim-lspconfig",
            "mfussenegger/nvim-jdtls",
            "williamboman/mason.nvim",
        },
        config = function()
            require("sonarlint").setup({
                server = {
                    cmd = {
                        "sonarlint-ls",
                        "-stdio",
                        "-analyzers",
                        vim.fn.getenv("SONARLINT_PLUGINS") .. "/sonarpython.jar",
                    },
                    settings = {
                        sonarlint = {
                            rules = {
                                ["python:S1481"] = { level = "on" },
                                ["python:S1523"] = { level = "on" },
                            },
                        },
                    },
                    on_attach = function(_, bufnr)
                        local opts = { noremap = true, silent = true, buffer = bufnr }
                        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
                        vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
                        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
                    end
                },
                filetypes = { "python", },
            })
        end,
        lazy = false,
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

-- Diff current file against HEAD
vim.keymap.set("n", "<leader>df", function()
  vim.cmd("CodeDiff HEAD -- " .. vim.fn.expand("%"))
end, { desc = "Diff current file vs HEAD" })

-- Diff last commit (HEAD) vs current working tree
vim.keymap.set("n", "<leader>dr", function()
  vim.cmd("CodeDiff")
end, { desc = "Diff HEAD vs working tree" })

-- Diff previous commit vs current commit (HEAD~1 vs HEAD)
vim.keymap.set("n", "<leader>dc", function()
  vim.cmd("CodeDiff HEAD~1 HEAD")
end, { desc = "Diff HEAD~1 vs HEAD" })

-- Toggle the file explorer sidebar
vim.keymap.set("n", "<leader>e",
  "<cmd>NvimTreeToggle<CR>",
  { desc = "File explorer" })

-- LSP navigation: jump to the definition of the symbol under the cursor
vim.keymap.set("n", "gd",
  vim.lsp.buf.definition,
  { desc = "Go to definition" })

-- Project-wide text search using Telescope
vim.keymap.set("n", "<leader>ff",
  require("telescope.builtin").find_files,
  { desc = "Find files by name" })
vim.keymap.set("n", "<leader>fg",
  require("telescope.builtin").live_grep,
  { desc = "Live grep: search text inside files" })

-- Extend LSP capabilities so completion works with nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Python language server (type checking, navigation, diagnostics)
vim.lsp.config("basedpyright", {
  capabilities = capabilities,
})

-- TypeScript / JavaScript / TSX language server
vim.lsp.config("tsserver", {
  cmd = { "typescript-language-server", "--stdio" },
  capabilities = capabilities,
})

-- Ruff linter server for Python (fast diagnostics + formatting)
-- Hover disabled to avoid conflicts with basedpyright hover
vim.lsp.config("ruff", {
  init_options = {
    settings = {
      hover = false,
    },
  },
})

-- Activate configured language servers
vim.lsp.enable("basedpyright")
vim.lsp.enable("tsserver")
vim.lsp.enable("ruff")
