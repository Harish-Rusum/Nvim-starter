-- settings
vim.cmd [[set nu]]
vim.cmd [[set rnu]]
vim.g.mapleader = " "

-- plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.keymap.set("n", "<leader>bn", function()
	vim.cmd([[bnext]])
end)
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- load plugins
local plugins = {
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
  { "rose-pine/neovim", name = "rose-pine" },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {"lua_ls", "pyright"}
      })
      require("lspconfig").pyright.setup {}
      require("lspconfig").lua_ls.setup {
        settings = {
          Lua = {
            diagnostics = {
              globals = {"vim"},
            },
          },
        },
      }
    end
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.diagnostics.eslint,
          null_ls.builtins.code_actions.gitsigns,
        },
      })
    end,
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  { "nvim-treesitter/nvim-treesitter" },
  { "nvim-telescope/telescope.nvim", tag = "0.1.8"},
  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
      {
        "<leader>ed",
        "<cmd>Trouble diagnostics<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>ef",
        "<cmd>Trouble diagnostics filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      }
  },
  {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      opts = {},
  },
}

local opts = {
  ui = { border = "rounded" },
}

require("lazy").setup(plugins, opts)

-- keymaps
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, {desc = "Rename variable"})
vim.keymap.set("n", "<leader>cg", vim.lsp.buf.definition, { desc = "go to definition" })
vim.keymap.set("n", "<leader>sf", function() vim.cmd [[Telescope fd]] end, {desc = "Find files"})
vim.keymap.set("n", "<leader>sg", function() vim.cmd [[Telescope live_grep]] end, {desc = "Live grep"})
vim.keymap.set("n", "<leader>ff", function() vim.cmd [[Neotree position=left toggle]] end, {desc = "File tree"})

-- status bar
require("lualine").setup{}

-- colorscheme
vim.cmd [[colorscheme catppuccin-mocha]]
require("nvim-treesitter.configs").setup {
  ensure_installed = {"lua", "python"},
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
}
