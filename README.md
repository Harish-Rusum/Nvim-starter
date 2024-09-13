# Neovim Configuration

This repository contains a Neovim configuration built using [Lazy.nvim](https://github.com/folke/lazy.nvim) plugin manager. The configuration is optimized with LSP support, Treesitter, Telescope, and includes various utilities like formatting and linting via `null-ls`.

## Features

- **Plugin Management**: Powered by `Lazy.nvim` for efficient plugin loading.
- **LSP Integration**: Uses `mason.nvim`, `mason-lspconfig.nvim`, and `null-ls.nvim` to handle LSP, linters, and formatters.
- **Treesitter**: Enhanced syntax highlighting and parsing using `nvim-treesitter`.
- **File Search and Navigation**: Quickly find files or search for text using `Telescope`.
- **File Explorer**: Navigate files easily with `Neo-tree`.
- **Status Line**: A minimal and configurable status line using `Lualine`.
- **Autopairs**: Automatically closes pairs like `()`, `{}`, `[]`, and more using `nvim-autopairs`.
- **Diagnostics and Code Actions**: View diagnostics and take code actions with `Trouble.nvim` and LSP key mappings.

## Requirements

- **Neovim**: 0.7 or newer.
- **Git**: For cloning the plugin manager.

## Installation

### 1. Clone this repository

```sh
Mac/Linux
git clone https://github.com/Harish-Rusum/Nvim-starter ~/.config/nvim
```
