# AGENTS.md — Instructions for AI Coding Agents

This document gives any new AI coding session full context for this repo. Read this first. No prior conversation is needed.

## Purpose

This is a personal Neovim configuration (namespace `yuvan`) being evolved into a robust, secure, office-appropriate development environment with **comprehensive Java support** (JDK 8 through latest, JAR handling, decompilation, debugging, Servlets, Spring Boot).

**Primary goal for upcoming work:** Java support in every aspect + security hardening for office usage. A secondary, undecided future item is Claude AI integration (decision deferred).

## Critical Rules

1. **Never commit, push, or create PRs unless the user explicitly asks.**
2. **Never delete or change files without updating the relevant `docs/` files** (`IMPLEMENTED.md`, `CHECKPOINTS.md`, `PLAN.md`).
3. **Do not remove or disable security-relevant plugins without an entry in `docs/SECURITY.md`.**
4. **Do not override or stub `vim.deprecate`** (currently done in `core/options.lua`; treat as a known debt item, do not worsen).
5. **Keep the lockfile (`lazy-lock.json`) honest** — after plugin add/remove, run or document `:Lazy sync`; commit only on request.
6. **Prefer adding to existing modular files** (one plugin = one file under `lua/yuvan/plugins/`).
7. **Use `pcall` guards** for optional `require` calls so the config still loads if a plugin is missing.
8. **No telemetry/cloud plugins without explicit security review.**

## Environment

- OS: Fedora Linux 44
- Neovim: 0.12.5 (LuaJIT 2.1)
- Shell: bash
- Java: Temurin 21.0.12.1 (SDKMAN: `~/.sdkman`)
- Maven 3.9.11, Gradle 8.7
- Config path: `/home/yuvan/Programs/Bash/nvim` (symlinked/deployed to `~/.config/nvim`)
- Plugin manager: lazy.nvim (lockfile pins commits)

## Conventions

- **Namespace:** `yuvan` (`lua/yuvan/...`). Core loaded first (`require("yuvan.core")`), then plugins (`require("yuvan.lazy")`).
- **Leader:** `Space` (set in `core/keymaps.lua`).
- **Formatting:** Stylua, 2-space indent. Config: `.stylua.toml`.
- **Files:** `core/` = core behavior; `plugins/` = one plugin spec per file; `plugins/lsp/` = LSP stack.
- **Naming:** plugin file named after the plugin.
- **Keymaps:** use `vim.keymap.set` with `desc` for discoverability.
- **Options:** set via `vim.opt` alias in `core/options.lua`.

## Documentation Policy (mandatory)

Every meaningful change must update these files as appropriate:

| File | Update when |
|---|---|
| `docs/IMPLEMENTED.md` | Adding/removing/changing a plugin, option, or keymap (baseline changes + changelog) |
| `docs/CHECKPOINTS.md` | Completing or starting a milestone/phase |
| `docs/PLAN.md` | Changing roadmap scope, decisions, or phase definitions |
| `docs/JAVA.md` | Any Java tooling change (LSP, JDK, DAP, build, decompile, Spring Boot) |
| `docs/SECURITY.md` | Any security-relevant change or new threat/hardening item |
| `README.md` | Structure, environment, or high-level status changes |

Keep documents **concise but complete** — a future session must understand context from `README.md` + `AGENTS.md` + `docs/` alone.

## Current Decisions / State

- **Phase 0 cleanup: DONE.** Removed `jupyter.lua`, `copilot.lua` (+Copilot keymaps), `cord.lua` (Discord leak), `vim-tmux-navigator` (conflicted with smart-splits), `neodev.nvim` (deprecated). Lockfile pruned to 38 plugins. See `docs/IMPLEMENTED.md`.
- **FireNvim** (`plugins/firenvim.lua`): kept after review (local loopback, low risk). Remove only with user confirmation.
- **Claude integration:** deferred decision (`coder/claudecode.nvim` vs `greggh/claude-code.nvim` vs `olimorris/codecompanion.nvim` vs `folke/sidekick.nvim`). See `docs/PLAN.md` Phase 6.
- **Next focus:** comprehensive Java support (see `docs/JAVA.md`) + office security hardening (`docs/SECURITY.md`).
- **Deployment note:** `~/.config/nvim` is a **symlink** to this repo — edits here are live immediately (no copy step). Keep `lazy-lock.json` in sync with `:Lazy sync`.

## How to Verify Changes

- Format Lua: `stylua --check .` (or `stylua .`) — must pass.
- Headless smoke test (plugin sync): `nvim --headless "+Lazy! sync" +qa` (run only if intended).
- Linting (if added later): `luacheck` / `selene` (planned in `docs/PLAN.md` Phase 7).
- Open editor and confirm config loads without errors: `nvim` (check `:messages` / `:checkhealth`).

## Scope Boundaries

- Do not add large unrelated features (e.g., other languages, themes) unless requested.
- Do not modify `lazy-lock.json` manually; let lazy.nvim manage it.
- Do not add network calls that transmit code/file content without user approval (office policy).