# IMPLEMENTED.md — Current State Inventory

Baseline snapshot of the config as of the initial documentation pass (2025). Future changes must be appended to the **Changelog** at the bottom and reflected in [`CHECKPOINTS.md`](CHECKPOINTS.md).

## Boot sequence

- `init.lua` → `require("yuvan.core")` then `require("yuvan.lazy")`; appends Lua 5.4 LuaRocks paths.
- `lua/yuvan/lazy.lua` → bootstraps lazy.nvim, imports `yuvan.plugins` and `yuvan.plugins.lsp`; auto-checker enabled, notifications silent.

## Core (`lua/yuvan/core/`)

| File | Contents |
|---|---|
| `options.lua` | relative+absolute numbers, 2-space indent, no wrap, ignorecase+smartcase, cursorline, `termguicolors`/dark, signcolumn=yes, `unnamedplus` clipboard, splitright/below, `swapfile=false`, netrw liststyle=3 |
| `keymaps.lua` | leader=`Space`; `jk`→ESC; `<leader>nh`; `x`→no-register delete; window (`sv/sh/se/sx`), tab (`to/tx/tn/tp/tf`), buffer (`bp/bn`) |
| `init.lua` | loads options+keymaps; defines `:Comp` (`g++ -std=c++17 main.cxx -o main && ./main`) |

## Plugins installed (`lazy-lock.json` pins these)

**Core/UX:** plenary, which-key, alpha (dashboard), lualine (theme `auto`), barbecue (breadcrumbs), indent-blankline, markview, smart-splits (handles tmux + window nav), vim-maximizer.

**Editing:** Comment.nvim (+ts-context-commentstring), nvim-autopairs, nvim-surround, nvim-ts-autotag, treesitter (many parsers), nvim-tree.

**Search/Nav:** telescope (+fzf-native, web-devicons).

**LSP/Completion:** mason, mason-lspconfig, mason-tool-installer, nvim-lspconfig, nvim-lsp-file-operations, neodev, cmp-nvim-lsp, nvim-cmp (+buffer/path/luasnip/lspkind/friendly-snippets), trouble.

**Formatting:** conform.nvim (prettier/prettierd, stylua, isort, clang-format, gofmt).

**Colorscheme:** cyberdream.

**FireNvim:** kept after security review (local loopback, low risk). See `SECURITY.md`.

**Removed in Phase 0:** copilot.vim + CopilotChat.nvim, jupyter stack (jupytext, iron.nvim, NotebookNavigator, mini.comment), cord.nvim, vim-tmux-navigator, neodev.nvim. Lockfile: **38** entries (was 47).

## LSP servers configured (via `lsp/lspconfig.lua`)

`html`, `cssls`, `tailwindcss`, `pyright`, `clangd`, `sqlls`, `bashls`, `yamlls`, `gopls`, `svelte`, `emmet_ls`, `lua_ls`, `denols`, `ts_ls`.

**Java: none configured yet** (planned — `docs/JAVA.md`).

## Mason ensure_installed (tools)

Servers: ts_ls, html, cssls, tailwindcss, svelte, lua_ls, pyright, clangd, denols, sqlls, bashls, gopls, yamlls.
Tools: prettier, stylua, isort, clang-format, prettierd, golangci-lint.

## Issues — status after Phase 0

**Resolved:**
- `vim.deprecate` global stub — removed (0 deprecation warnings surface now).
- lualine theme `nightfly` ≠ `cyberdream` — now `theme = "auto"`.
- `<C-h/j/k/l>` conflict (smart-splits vs vim-tmux-navigator) — vim-tmux-navigator removed; smart-splits owns them.
- `<leader>sm/sv/sr` conflicts (iron.nvim) — jupyter removed.
- Insert `<C-j>` conflict (cmp vs Copilot) — Copilot removed.
- Dead commented code — cleaned (colorscheme, lualine, nvim-tree, alpha).
- `neodev.nvim` deprecated — removed.

**Remaining / accepted:**
- Python formatting runs only `isort` (no formatter) — future DX (PLAN Phase 7).
- `stylua` not installed in this environment — formatting check done via `luajit -bl` (syntax) instead.

## Environment recorded

- Neovim 0.12.5, Fedora 44, Temurin 21.0.12.1 (SDKMAN), Maven 3.9.11, Gradle 8.7.
- Config path `/home/yuvan/Programs/Bash/nvim`.

---

## Changelog

| Date | Change | Files |
|---|---|---|
| Phase 0 | **Removed** jupyter.lua (jupytext/iron/NotebookNavigator), copilot.lua (+CopilotChat keymaps), cord.lua (Discord leak), vim-tmux-navigator (`<C-hjkl>` conflict), neodev.nvim (deprecated) | deleted: jupyter.lua, copilot.lua, cord.lua; edited: plugins/init.lua, lsp/lspconfig.lua |
| Phase 0 | **Bug fixes:** removed `vim.deprecate` stub; lualine theme `nightfly`→`auto`; resolved `<C-hjkl>` / `<leader>s*` / insert `<C-j>` conflicts. Also fixed the `iron.nvim` `restart` key error by removing the jupyter stack. | core/options.lua, lualine.lua |
| Phase 0 | **Dead code:** cleaned commented blocks in colorscheme.lua, lualine.lua, nvim-tree.lua, alpha.lua (unused headers); removed CopilotChat highlights | those files + core/options.lua |
| Phase 0 | **Lockfile** pruned 47 → 38 entries via `:Lazy clean` (offline) | lazy-lock.json |
| Phase 0 | **Deployed** cleaned repo → `~/.config/nvim` (they are separate copies); live config now in sync (38 plugins) | `~/.config/nvim/lua`, `lazy-lock.json` |
| Baseline | Documentation created (README, AGENTS, docs/*). No behavior change. | new md files |