-- PERF: Vim settings.
vim.o.timeout = true
vim.o.rnu = true
vim.o.nu = true
vim.o.cursorline = true
vim.o.timeoutlen = 200
vim.g.mapleader = " "

-- PERF: This checks if i have lazy vim installed and installs it for me if i do not.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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

-- PERF: Defining plugins
local plugins = {

  -- PERF: Colorschemes
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
  { "rose-pine/neovim", name = "rose-pine" },

  -- PERF: For installing dependencies
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },

  -- PERF: For lsp (language support)
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

  -- PERF: Autocomplete
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<Esc>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        })
      })
    end,
  },

  -- PERF: Highlighting
  { "nvim-treesitter/nvim-treesitter" },

  -- PERF: For searching
  { "nvim-telescope/telescope.nvim", tag = "0.1.8"},

  -- PERF: For project wide errors
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
    },
  },

  -- PERF: Popup to teach keybinds to noobs
  {
    "folke/which-key.nvim"
  },

  -- PERF: Auto-closing braces
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- PERF: Status bar
  {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' }
  },

  -- PERF: File tree
  {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      }
  },

  -- PERF: Indent lines
  {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      opts = {},
  },

  -- PERF: Fancy command line
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      }
  },

  -- PERF: These fancy comments
  {
    "folke/todo-comments.nvim",
    config = function()
      require("todo-comments").setup {}
    end
  },
}

-- PERF: UI options
local opts = {
  ui = { border = "rounded" },
}

-- PERF: Actuall installing plugins and options
require("lazy").setup(plugins, opts)

-- PERF: Keymaps
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, {desc = "Rename variable"})
vim.keymap.set("n", "<leader>cg", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>sf", function() vim.cmd [[Telescope fd]] end, {desc = "Find files"})
vim.keymap.set("n", "<leader>sg", function() vim.cmd [[Telescope live_grep]] end, {desc = "Find word"})
vim.keymap.set("n", "<leader>ff", function() vim.cmd [[Neotree position=left toggle]] end, {desc = "File tree"})
vim.keymap.set("n", "<leader>bn", function() vim.cmd([[bnext]]) end, {desc = "Next buffer (tab)"})
vim.keymap.set("n", "<Esc>", function() vim.cmd([[nohlsearch]]) end, {desc = "Clear search highlighting"})


-- PERF: set colorscheme
vim.cmd [[colorscheme catppuccin-mocha]]

-- PERF: setting up indenting and highlighting for lua and python
require("nvim-treesitter.configs").setup {
  ensure_installed = {"lua", "python"},
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
}

-- PERF: Loading statusbar,command line
require("noice").setup({})
require("lualine").setup{}
require("which-key").setup{}

-- PERF: Setting up keybind preview plugin
require("which-key").register({
  ["<leader>s"] = { name = "Search", _ = "which_key_ignore" },
  ["<leader>f"] = { name = "File explorer", _ = "which_key_ignore" },
  ["<leader>c"] = { name = "Code", _ = "which_key_ignore" },
  ["<leader>d"] = { name = "Errors", _ = "which_key_ignore" },
  ["<leader>b"] = { name = "Buffers", _ = "which_key_ignore" },
})

-- PERF: Setting statusbar height
vim.defer_fn(function()
	vim.cmd([[set cmdheight=1]])
end, 100)
