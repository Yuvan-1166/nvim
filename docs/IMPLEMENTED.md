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

**LSP/Completion:** mason, mason-lspconfig, mason-tool-installer, nvim-lspconfig (wired via `vim.lsp.config`/`vim.lsp.enable`), nvim-lsp-file-operations, cmp-nvim-lsp, nvim-cmp (+buffer/path/luasnip/lspkind/friendly-snippets), trouble.

**Java:** nvim-java (jdtls driver), spring-boot.nvim (STS4, pinned commit), springboot-nvim (Initializr, Phase 3), nui.nvim, nvim-dap, nvim-dap-ui, nvim-dap-virtual-text, nvim-nio (Phase 2); **overseer.nvim** (Phase 3). Vineflower pinned for decompile (Phase 4).

**Formatting:** conform.nvim (prettier/prettierd, stylua, isort, clang-format, gofmt).

**Colorscheme:** cyberdream.

**FireNvim:** kept after security review (local loopback, low risk). See `SECURITY.md`.

**Removed in Phase 0:** copilot.vim + CopilotChat.nvim, jupyter stack (jupytext, iron.nvim, NotebookNavigator, mini.comment), cord.nvim, vim-tmux-navigator, neodev.nvim. Lockfile: **47** entries (47 → 38 after Phase 0 → 42 after Phase 1 → 45 after Phase 2 → 46 after Phase 3 → 47).

## LSP servers configured (via `lsp/lspconfig.lua`)

`html`, `cssls`, `tailwindcss`, `pyright`, `clangd`, `sqlls`, `bashls`, `yamlls`, `gopls`, `svelte`, `emmet_ls`, `lua_ls`, `denols`, `ts_ls`.

**Java (Phase 1):** `jdtls` via `nvim-java` (`lsp/java.lua`) — 5 SDKMAN runtimes registered (8/11/17/21/**25**, **21 = default**). jdtls attach, diagnostics and formatting verified.

## Mason ensure_installed (tools)

Servers: ts_ls, html, cssls, tailwindcss, svelte, lua_ls, pyright, clangd, denols, sqlls, bashls, gopls, yamlls. (jdtls is **not** mason-managed — nvim-java owns it.)
Tools: prettier, stylua, isort, clang-format, prettierd, golangci-lint, google-java-format.

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
- Cosmetic on Java buffers: `nvim-navic` warns "Already attached to spring-boot" (spring-boot LS attaches as a second client) — revisit in Phase 3.

## Environment recorded

- Neovim 0.12.5, Fedora 44, Temurin 21.0.12.1 (SDKMAN, default) **plus** 8.0.504 / 11.0.32 / 17.0.20 / 25.0.4.1 via SDKMAN, Maven 3.9.11, Gradle 8.7.
- Config path `/home/yuvan/Programs/Bash/nvim`.

---

## Changelog

| Date | Change | Files |
|---|---|---|
| Phase 1 | **Java foundation:** new `plugins/lsp/java.lua` (nvim-java + spring-boot.nvim/nui.nvim/nvim-dap), 5 JDK runtimes in jdtls (21 default), `google-java-format` in conform + mason, treesitter `java/xml/properties/groovy`. jdtls attach + diagnostics + format verified | new: lsp/java.lua; edited: mason.lua, formatting.lua, treesitter.lua |
| Phase 7 | **DX groups:** added which-key groups for debug/git/java/tasks/spring/tomcat/decompile; added `gitsigns.nvim` with hunk keymaps. | plugins/gitsigns.lua, plugins/which-key.lua |
| Phase 5 (in progress) | **Runtime hardening:** `exrc` off, `modelines=0`, `secure`, shada tightened in `core/options.lua`. | core/options.lua |
| Phase 4 | **JAR/decompile:** pinned Vineflower in `~/.local/share/nvim/decompilers/` (sha256 recorded). | ~/.local/share/nvim/decompilers/ |
| Phase 3 | **Build/tasks + Spring Boot:** new `plugins/overseer.lua`, user templates `overseer/template/user/{maven,gradle}.lua`, `<leader>o*` tasks; `plugins/spring-init.lua` (`springboot-nvim`), `<leader>jsb/jsa/si`; `plugins/attach-debug.lua` JDWP attach `<leader>ga`; `<leader>o/s/t` groups in which-key. | overseer.lua, overseer/template/*, spring-init.lua, attach-debug.lua, lsp/java.lua, which-key.lua |
| Phase 2 | **Debugging & testing:** new `plugins/dap.lua` (`nvim-dap` + UI + virtual text + nvim-nio), attach config for JDWP :5005, DAP keymaps under `<leader>g`; expanded Java keymaps (`<leader>jr/js/jl/jp/jV/jc/jv/jo/jt/jd/jm/jM/jT/jR`) in `plugins/lsp/java.lua`. Verified breakpoint → frame resolution → continue/exit; Java test run/debug via nvim-java. | dap.lua, lsp/java.lua, which-key.lua |
| Phase 1 | **JDKs installed** via SDKMAN (Temurin 8 / 11 / 17 / 21 / 25) | `~/.sdkman/candidates/java/` |
| Phase 1 | **Deprecations fixed:** `require('lspconfig')` → `vim.lsp.config`/`vim.lsp.enable`; smart-splits `default_amount` → `resize.amount`; nvim-treesitter migrated to `main` branch API (old `configs` was silently skipped, breaking Lua parsing) | lspconfig.lua, smart-splits.lua, treesitter.lua |
| Phase 1 | **Lockfile** 38 → 42 entries (nvim-java, spring-boot.nvim, nui.nvim, nvim-dap); 42 → 45 (nvim-dap-ui, nvim-dap-virtual-text, nvim-nio) | lazy-lock.json |
| Phase 1 | **Deployment:** `~/.config/nvim` is now a **symlink** to this repo — no copy step | AGENTS.md |
| Phase 0 | **Removed** jupyter.lua (jupytext/iron/NotebookNavigator), copilot.lua (+CopilotChat keymaps), cord.lua (Discord leak), vim-tmux-navigator (`<C-hjkl>` conflict), neodev.nvim (deprecated) | deleted: jupyter.lua, copilot.lua, cord.lua; edited: plugins/init.lua, lsp/lspconfig.lua |
| Phase 0 | **Bug fixes:** removed `vim.deprecate` stub; lualine theme `nightfly`→`auto`; resolved `<C-hjkl>` / `<leader>s*` / insert `<C-j>` conflicts. Also fixed the `iron.nvim` `restart` key error by removing the jupyter stack. | core/options.lua, lualine.lua |
| Phase 0 | **Dead code:** cleaned commented blocks in colorscheme.lua, lualine.lua, nvim-tree.lua, alpha.lua (unused headers); removed CopilotChat highlights | those files + core/options.lua |
| Phase 0 | **Lockfile** pruned 47 → 38 entries via `:Lazy clean` (offline) | lazy-lock.json |
| Phase 0 | **Deployed** cleaned repo → `~/.config/nvim` (they are separate copies); live config now in sync (38 plugins) | `~/.config/nvim/lua`, `lazy-lock.json` |
| Baseline | Documentation created (README, AGENTS, docs/*). No behavior change. | new md files |