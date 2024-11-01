-- Vim settings.
vim.o.timeout = true
vim.o.rnu = true
vim.o.nu = true
vim.o.cursorline = true
vim.o.timeoutlen = 200
vim.g.mapleader = " "
vim.o.fillchars = "eob: "
vim.o.laststatus = 3

-- This checks if i have lazy vim installed and installs it for me if i do not.
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

-- Defining plugins
local plugins = {

	-- Colorschemes
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{ "folke/tokyonight.nvim", lazy = false, priority = 1000 },
	{ "rose-pine/neovim", name = "rose-pine" },

	-- For installing dependencies
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end
	},

	-- For lsp (language support)
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

	-- Autocomplete
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

	-- Highlighting
	{ "nvim-treesitter/nvim-treesitter" },

	-- For searching
	{ "nvim-telescope/telescope.nvim", tag = "0.1.8"},

	-- For project wide errors
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

	-- Popup to teach keybinds to noobs
	{
		"folke/which-key.nvim"
	},

	-- Buffer's (on the top)
	{'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},

	-- Auto-closing braces
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},

	-- Status bar
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' }
	},

	-- File tree
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		}
	},

	-- Indent lines
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
	},

	-- Terminal
	{
		"akinsho/toggleterm.nvim",
	},

	-- Fancy command line
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

}

-- UI options
local opts = {
	ui = { border = "rounded" },
}

-- Actuall installing plugins and options
require("lazy").setup(plugins, opts)

-- Keymaps
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, {desc = "Rename variable"})
vim.keymap.set("n", "<leader>cg", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>sf", function() vim.cmd [[Telescope fd]] end, {desc = "Find files"})
vim.keymap.set("n", "<leader>sg", function() vim.cmd [[Telescope live_grep]] end, {desc = "Find word"})
vim.keymap.set("n", "<leader>tv", function() vim.cmd [[ToggleTerm direction=vertical]] end, {desc = "Vertical split terminal"})
vim.keymap.set("n", "<leader>th", function() vim.cmd [[ToggleTerm direction=horizontal]] end, {desc = "Horizontal split terminal"})
vim.keymap.set("n", "<leader>tf", function() vim.cmd [[ToggleTerm direction=float]] end, {desc = "FLoating terminal"})
vim.keymap.set("n", "<leader>ff", function() vim.cmd [[Neotree position=left toggle]] end, {desc = "File tree"})
vim.keymap.set("n", "<leader>rc", function() vim.cmd [[RunCpp]] end, {desc = "Run current c++ file"})
vim.keymap.set("n", "<Tab>", function() vim.cmd([[bnext]]) end, {desc = "Next buffer (tab)"})
vim.keymap.set("n", "<Esc>", function() vim.cmd([[nohlsearch]]) end, {desc = "Clear search highlighting"})


-- set colorscheme
vim.cmd [[colorscheme catppuccin-mocha]]

-- setting up indenting and highlighting for lua and python
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

-- Loading statusbar,command line
require("noice").setup({})
require("lualine").setup{}
require("which-key").setup{}

-- Setting up keybind preview plugin
require("which-key").register({
	["<leader>s"] = { name = "Search", _ = "which_key_ignore" },
	["<leader>f"] = { name = "File explorer", _ = "which_key_ignore" },
	["<leader>c"] = { name = "Code", _ = "which_key_ignore" },
	["<leader>d"] = { name = "Errors", _ = "which_key_ignore" },
	["<leader>t"] = { name = "Terminal", _ = "which_key_ignore" },
	["<leader>r"] = { name = "Run", _ = "which_key_ignore" },
})

-- Setting up bufferline
vim.opt.termguicolors = true
require("bufferline").setup{}

-- Setting statusbar height
vim.defer_fn(function()
	vim.cmd([[set cmdheight=1]])
end, 100)

-- Custom indent width
local IndentGroup = vim.api.nvim_create_augroup("CustomIndent", { clear = true })
local function setIndent(filetype, shiftwidth, tabstop)
	vim.api.nvim_create_autocmd("FileType", {
		group = IndentGroup,
		pattern = filetype,
		callback = function()
			vim.opt_local.shiftwidth = shiftwidth
			vim.opt_local.tabstop = tabstop
		end,
	})
end
setIndent("lua", 2, 2)
setIndent("python", 4, 4)
setIndent("cpp", 4, 4)

-- Global clipboard
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- Terminal
require("toggleterm").setup({
    direction = 'float',
    float_opts = {
        border = 'rounded',
        winblend = 0,
        highlights = {
            border = "Normal",
            background = "Normal",
        },
    },
  highlights = {
    Normal = {
      guifg = "#789edb",
      guibg = "none",
    },
    NormalFloat = {
      guifg = "#789edb",
      guibg = "none",
    },
	},
	shade_terminal = false,
	shading_factor = 0,
	shell = vim.o.shell,
})


-- C++ running support
local function compile_and_run_cpp()
  local file = vim.fn.expand("%")
  local output = "output"

  local compile_cmd = string.format("g++ %s -o %s && clear && ./%s", file, output, output)

  require("toggleterm").exec(compile_cmd, 1)
end

vim.api.nvim_create_user_command("RunCpp", compile_and_run_cpp, {})
