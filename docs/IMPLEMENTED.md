# IMPLEMENTED.md — Current State Inventory

Baseline snapshot of the config as of the initial documentation pass (2025). Future changes must be appended to the **Changelog** at the bottom and reflected in [`CHECKPOINTS.md`](CHECKPOINTS.md).

## Boot sequence

- `init.lua` → `require("yuvan.core")` then `require("yuvan.lazy")`; appends Lua 5.4 LuaRocks paths.
- `lua/yuvan/lazy.lua` → bootstraps lazy.nvim, imports `yuvan.plugins` and `yuvan.plugins.lsp`; auto-checker enabled, notifications silent.

## Core (`lua/yuvan/core/`)

| File | Contents |
|---|---|
| `options.lua` | relative+absolute numbers, 2-space indent, no wrap, ignorecase+smartcase, cursorline, `termguicolors`/dark, signcolumn=yes, `unnamedplus` clipboard, splitright/below, `swapfile=false`, netrw liststyle=3, `vim.deprecate` stubbed (tech-debt), CopilotChat highlight tweaks |
| `keymaps.lua` | leader=`Space`; `jk`→ESC; `<leader>nh`; `x`→no-register delete; window (`sv/sh/se/sx`), tab (`to/tx/tn/tp/tf`), buffer (`bp/bn`); Copilot Chat (`cc`, `<C-Enter>`, `<C-c>`) |
| `init.lua` | loads options+keymaps; defines `:Comp` (`g++ -std=c++17 main.cxx -o main && ./main`) |

## Plugins installed (`lazy-lock.json` pins these)

**Core/UX:** plenary, vim-tmux-navigator, which-key, alpha (dashboard), lualine (theme `nightfly`), barbecue (breadcrumbs), indent-blankline, markview, smart-splits, vim-maximizer.

**Editing:** Comment.nvim (+ts-context-commentstring), nvim-autopairs, nvim-surround, nvim-ts-autotag, treesitter (many parsers), nvim-tree.

**Search/Nav:** telescope (+fzf-native, web-devicons).

**LSP/Completion:** mason, mason-lspconfig, mason-tool-installer, nvim-lspconfig, nvim-lsp-file-operations, neodev, cmp-nvim-lsp, nvim-cmp (+buffer/path/luasnip/lspkind/friendly-snippets), trouble.

**Formatting:** conform.nvim (prettier/prettierd, stylua, isort, clang-format, gofmt).

**Colorscheme:** cyberdream.

**On-hold / flagged:** copilot.vim + CopilotChat.nvim, jupyter stack (jupytext, iron.nvim, NotebookNavigator, mini.comment), cord.nvim (Discord), firenvim.

## LSP servers configured (via `lsp/lspconfig.lua`)

`html`, `cssls`, `tailwindcss`, `pyright`, `clangd`, `sqlls`, `bashls`, `yamlls`, `gopls`, `svelte`, `emmet_ls`, `lua_ls`, `denols`, `ts_ls`.

**Java: none configured yet** (planned — `docs/JAVA.md`).

## Mason ensure_installed (tools)

Servers: ts_ls, html, cssls, tailwindcss, svelte, lua_ls, pyright, clangd, denols, sqlls, bashls, gopls, yamlls.
Tools: prettier, stylua, isort, clang-format, prettierd, golangci-lint.

## Notable issues observed (tracked in PLAN)

- `vim.deprecate = function() end` global suppression (tech-debt).
- lualine theme `nightfly` ≠ active colorscheme `cyberdream`.
- Keymap conflicts: `<leader>sm`, `<leader>sv`, `<C-hjkl>` (smart-splits vs tmux-navigator), insert `<C-j>` (cmp vs Copilot).
- Dead commented code in `colorscheme.lua` and `lualine.lua`.
- `neodev.nvim` deprecated upstream.
- Python formatting only runs `isort` (no formatter).

## Environment recorded

- Neovim 0.12.5, Fedora 44, Temurin 21.0.12.1 (SDKMAN), Maven 3.9.11, Gradle 8.7.
- Config path `/home/yuvan/Programs/Bash/nvim`.

---

## Changelog

| Date | Change | Files |
|---|---|---|
| 2025 (baseline) | Documentation created (README, AGENTS, docs/PLAN, docs/JAVA, docs/SECURITY, docs/IMPLEMENTED, docs/CHECKPOINTS). No behavior change. | new md files only |