# Neovim Configuration (yuvan)

A modular, lazy-loaded Neovim config optimized for general development. Primary goal: become a robust, secure, office-appropriate development environment with comprehensive **Java** support (JDK 8 → latest, JARs, decompilation, debugging, Servlets, Spring Boot).

This configuration:
- Uses **lazy.nvim** plugin manager with autoloading and automatic checks
- Organizes plugins under `lua/yuvan/` (core + plugins + lsp)
- Prioritizes security, auditability, and reproducibility for office usage
- Is fully documented so no external context is needed for new sessions

## Environment

- **Path:** `/home/yuvan/Programs/Bash/nvim` (expected to live at or be symlinked to `~/.config/nvim`)
- **Neovim:** `NVIM v0.12.5` (LuaJIT 2.1.1767980792)
- **OS:** Fedora Linux 44 (Workstation Edition)
- **Shell:** `/bin/bash`
- **Java (current):** `Temurin 21.0.12.1` (SDKMAN-managed at `~/.sdkman/candidates/java/21.0.12+1.1-tem`)
- **Build tools:** Maven `3.9.11`, Gradle `8.7`

SDKMAN is present (`~/.sdkman`). Multiple JDK versions can be installed via SDKMAN; the config is designed to support per-project JDK switching (see `docs/JAVA.md`).

## Structure

```text
nvim/
├── init.lua                  # Boot: loads yuvan.core + yuvan.lazy; LuaRocks paths (5.4)
├── lazy-lock.json            # Pinned plugin commits (reproducible, supply-chain friendly)
├── .stylua.toml              # Lua formatting (2 spaces)
├── AGENTS.md                 # Instructions for AI coding agents (self-contained context)
├── README.md                 # This file
├── docs/                     # Documentation (plan, Java, security, checkpoints)
│   ├── PLAN.md
│   ├── IMPLEMENTED.md
│   ├── CHECKPOINTS.md
│   ├── JAVA.md
│   └── SECURITY.md
└── lua/yuvan/
    ├── core/
    │   ├── init.lua           # Loads options + keymaps; adds :Comp command
    │   ├── options.lua        # Neovim options (ui, editing, search, clipboard)
    │   └── keymaps.lua        # Leader=Space keymaps
    ├── lazy.lua                # lazy.nvim bootstrap + plugin imports
    └── plugins/
        ├── init.lua            # Core utilities (plenary)
        ├── alpha.lua           # Dashboard
        ├── autopairs.lua
        ├── barbecue.lua         # Breadcrumbs (navic)
        ├── colorscheme.lua     # cyberdream (theme)
        ├── comment.lua
        ├── firenvim.lua          # Browser <-> nvim (kept; loopback, low risk)
        ├── formatting.lua       # Conform (formatters by FT)
        ├── indent-blankline.lua
        ├── lualine.lua          # Statusline
        ├── markview.lua          # Markdown preview/render
        ├── nvim-cmp.lua         # Completion (nvim-cmp + luasnip)
        ├── nvim-tree.lua         # File explorer
        ├── smart-splits.lua      # Split nav/resize (also tmux)
        ├── surround.lua
        ├── telescope.lua         # Fuzzy finder
        ├── treesitter.lua         # Syntax/indent + autotag
        ├── trouble.lua           # Diagnostics/quickfix UI
        ├── vim-maximizer.lua
        ├── which-key.lua         # Keymap hints
        └── lsp/
            ├── java.lua         # nvim-java: jdtls + debug/test bundles + Spring Boot LS
            ├── mason.lua         # LSP/formatters/lint tools installer
            └── lspconfig.lua     # LSP config + keymaps + per-server setup
```

> **Phase 0:** cleanup/removals. **Phase 1:** Java LSP/JDKs (nvim-java/jdtls, 8/11/17/21/25). **Phase 2:** Java debugging & testing (nvim-dap, java-test). **Phase 3 (in progress):** build/tasks (overseer.nvim) + Spring Boot (STS4 + Initializr). **Phase 4 (in progress):** JAR/decompile (Vineflower pinned). Lockfile: **47** plugins. See `docs/IMPLEMENTED.md`.

## Quick Start

1. Clone/symlink this repo to `~/.config/nvim` (or keep at the current path and symlink).
2. Launch `nvim`. lazy.nvim will bootstrap automatically on first run.
3. Run `:Lazy sync` to install/update plugins (lockfile pins commits for reproducibility).
4. Check installed tools: `:Mason` (LSPs, formatters). Ensure Java/Maven/Gradle available in `$PATH`.
5. For Java: see `docs/JAVA.md` for full setup (JDK switching, jdtls, debugging, Spring Boot).

## Documentation

| Document | Purpose |
|---|---|
| [`AGENTS.md`](AGENTS.md) | Self-contained context for AI coding agents; conventions, scope, policy. Read first in new sessions. |
| [`docs/PLAN.md`](docs/PLAN.md) | Master roadmap: Phases 0–1 done, Java debugging/build/decompile, security hardening, Claude (TBD), DX upgrades. |
| [`docs/IMPLEMENTED.md`](docs/IMPLEMENTED.md) | Baseline inventory of what exists today (with change tracking). |
| [`docs/CHECKPOINTS.md`](docs/CHECKPOINTS.md) | Milestones and phase-by-phase progress checklist. |
| [`docs/JAVA.md`](docs/JAVA.md) | Comprehensive Java support plan: JDKs, jdtls/DAP/tests, Maven/Gradle, JAR/decompilation, Spring Boot/Servlet, formatting/linting. |
| [`docs/SECURITY.md`](docs/SECURITY.md) | Office-usage security posture: supply chain, telemetry, runtime hardening, secrets, SAST/dependency scanning. |

## Conventions

- **Leader:** `Space`
- **Formatting:** Stylua (2 spaces). Config in `.stylua.toml`.
- **Keymaps:** Documented with `which-key`; groups prefixed by `<leader>` (`s` split, `t` tab, `b` buffer, `e` explorer, `f` telescope, `x` trouble, `c` code/LSP, `m` format).
- **Plugins:** Each plugin in its own file under `lua/yuvan/plugins/`. `lsp/` subdir for LSP stack.
- **Safety:** `pcall` guards around optional requires; lockfile pinning; no auto-commits (commit only on explicit request).

## Security Note (Office Usage)

This repo is intended for office/workplace use. Status after Phases 0–1:
- **Removed:** `copilot.lua` (cloud code egress), `jupyter.lua` (unused), `cord.lua` (Discord presence leaked project/file context).
- **Kept (reviewed):** `firenvim.lua` — local loopback by default, no external egress unless reconfigured. Low risk; remove on request.
- **Phase 1 (reviewed):** `nvim-java` downloads versioned jdtls/java-debug/java-test/lombok/spring-boot jars (dev tooling, no telemetry); `spring-boot.nvim` pinned to a commit. Details in `docs/SECURITY.md`.

See [`docs/SECURITY.md`](docs/SECURITY.md) for the full threat model, hardening checklist, dependency scanning, and secrets management.

## Status

Current state documented in [`docs/IMPLEMENTED.md`](docs/IMPLEMENTED.md). Roadmap and active phases tracked in [`docs/PLAN.md`](docs/PLAN.md) and [`docs/CHECKPOINTS.md`](docs/CHECKPOINTS.md).