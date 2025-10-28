local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
  spec = {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "c", "lua", "python", "javascript", "vim", "vimdoc", "query" },
            auto_install = true,
            highlight = { enable = true },

            incremental_selection = {
                enable = true,
                keymaps = {
                init_selection = "<Leader>ss",
                node_incremental = "<Leader>si",
                scope_incremental = "<Leader>sc",
                node_decremental = "<Leader>sd",
                },
            },

            textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                    ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
                },
                selection_modes = {
                    ['@parameter.outer'] = 'v',
                    ['@function.outer'] = 'V',
                    ['@class.outer'] = '<c-v>',
                },
                include_surrounding_whitespace = true,
            },
        },
        })
      end,
    },

    {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },

    {
      "neanias/everforest-nvim",
      version = false,
      lazy = false,
      priority = 1000,
      opts = { background = "hard" },
      config = function()
        require("everforest").setup({})
        vim.cmd.colorscheme("everforest")
      end,
    },
    {
    "neovim/nvim-lspconfig",
    config = function()
        local lspconfig = require("lspconfig")
        lspconfig.clangd.setup({})
    end,
    },

    {
      'saghen/blink.cmp',
      dependencies = { 'rafamadriz/friendly-snippets' },

      version = '1.*',
      opts = {
        keymap = { preset = 'super-tab' },

        appearance = {
          nerd_font_variant = 'mono'
        },

        completion = { documentation = { auto_show = true} },

        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
            providers = {
              lazydev = {
                name = "LazyDev",
                module = "lazydev.integrations.blink",
                -- make lazydev completions top priority (see `:h blink.cmp`)
                score_offset = 100,
              },
            },
        },

        fuzzy = { implementation = "prefer_rust_with_warning" }
        },
      opts_extend = { "sources.default" }
    },

      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
},

  install = { colorscheme = { "everforest" } },
  checker = { enabled = true },
})
