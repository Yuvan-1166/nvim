# CHECKPOINTS.md — Progress Tracker

Checklist of milestones. Tick items as they complete; add the date and a short note. Keep in sync with [`PLAN.md`](PLAN.md) and [`IMPLEMENTED.md`](IMPLEMENTED.md).

Legend: `[ ]` not done · `[x]` done · `[~]` in progress · `[!]` blocked/on-hold

---

## Phase 0 — Removals & security triage  `[x] Done`

- [x] Delete `lua/yuvan/plugins/jupyter.lua` (jupytext, iron.nvim, NotebookNavigator, mini.comment)
- [x] Delete `lua/yuvan/plugins/copilot.lua` (copilot.vim, CopilotChat.nvim)
- [x] Remove Copilot Chat keymaps from `core/keymaps.lua`
- [x] Delete `cord.lua` (Discord) — external leak removed
- [x] `firenvim.lua` — reviewed, **kept** (local loopback, low risk); flagged in SECURITY.md
- [x] Run `:Lazy clean` — lockfile pruned 47 → 38 entries
- [x] Bug fixes: `<C-hjkl>` conflict (removed vim-tmux-navigator), `vim.deprecate` stub removed, lualine theme → auto
- [x] Dead-code cleanup (colorscheme/lualine/nvim-tree/alpha/options)
- [x] Update `IMPLEMENTED.md` + `SECURITY.md` (flagged → resolved)

---

## Phase 1 — Java foundation (LSP / JDK)  `[x] Done 2026-10-19`

- [x] Decide driver: **`nvim-java`** (chosen; `nvim-jdtls` not used)
- [x] Install JDKs 8, 11, 17, 21, 25 via SDKMAN (Temurin 8.0.504 / 11.0.32 / 17.0.20 / 21.0.12 / 25.0.4.1)
- [x] Add `lua/yuvan/plugins/lsp/java.lua` (nvim-java + spring-boot.nvim, nui.nvim, nvim-dap)
- [x] Register JDK runtimes in jdtls settings (5 runtimes, **21 = default**)
- [x] Lombok via nvim-java built-in (`lombok.enable`) — no separate `lombok.nvim`
- [x] Add treesitter parsers: `java`, `xml`, `properties`, `groovy`
- [x] Add `google-java-format` to conform + mason-tool-installer (v1.37.0)
- [x] Verify: jdtls attaches (root detected), 5 runtimes, diagnostics + format work
- [ ] Confirm organize-imports + `:JavaSettingsChangeRuntime` against a real project

---

## Phase 2 — Java debugging & testing  `[x] Done 2026-10-24`

- [x] Add `nvim-dap` + `nvim-dap-ui` (+ virtual text)
- [x] Wire Java debug adapter (via nvim-java bundles)
- [x] Wire `java-test` (JUnit run/debug)
- [x] Add DAP keymaps (`<leader>g`) with `<leader>d` reserved for LSP diagnostics
- [x] Configure attach/remote debug (JDWP :5005)
- [x] Verify: breakpoint + step + inspect; test run/debug session verified

---

## Phase 3 — Java build / Spring Boot / Servlet  `[ ]`

- [x] Maven/Gradle task runner (`overseer.nvim` + user templates)
- [x] `JavaHello/spring-boot.nvim` (STS4) present + helpers `<leader>jsb/<leader>jsa`
- [ ] Spring Initializr scaffolding (spring CLI / springboot-nvim)
- [ ] Servlet container run + debug-attach config (Tomcat/Jetty)
- [ ] Verify: run/debug a Spring Boot app; complete `application.yml`; run a Servlet

---

## Phase 4 — JAR handling & decompilation  `[ ]`

- [ ] Choose decompiler: CFR and/or Vineflower
- [ ] Add decompiler JARs (pinned) + record hashes in `SECURITY.md`
- [ ] Add decompile command/keymap (`jdecomp.nvim` or custom `:JavaDecompile`)
- [ ] Configure `referencedLibraries` for external JARs
- [ ] Verify: decompile a `.class`/`.jar` into a scratch buffer; LSP disabled on it

---

## Phase 5 — Security hardening (office)  `[ ]`

- [ ] Runtime hardening: `exrc` off, modeline hygiene, shada review
- [ ] Secrets scanning: `gitleaks`/`git-secrets` (opt-in pre-commit)
- [ ] Dependency scanning: OWASP Dependency-Check / Trivy / Grype
- [ ] SAST: SpotBugs + FindSecBugs / Semgrep
- [ ] Document mirror/proxy config for Maven/Gradle/mason (air-gapped)
- [ ] Re-review every plugin in lockfile; remove anything untrusted

---

## Phase 6 — Claude AI integration  `[!] Blocked (decision deferred)`

- [ ] Choose plugin (`coder/claudecode.nvim` | `greggh/claude-code.nvim` | `codecompanion` | `sidekick`)
- [ ] Add plugin spec under `lua/yuvan/plugins/` (lazy-loaded)
- [ ] Add `<leader>a*` keymaps
- [ ] Verify + document

---

## Phase 7 — DX polish & maintenance  `[ ]`

- [ ] Lua linting (`luacheck`/`selene`) + `stylua --check` gate
- [ ] Add `gitsigns.nvim` (+ optional `lazygit.nvim`)
- [ ] Replace `neodev.nvim`; migrate to `vim.lsp.config`/`vim.lsp.enable`; drop `vim.deprecate` stub
- [ ] lualine theme → `auto` (or cyberdream match)
- [ ] Consolidate which-key groups; remove dead commented code
- [ ] Startup perf check (`nvim --startuptime`)

---

## Maintenance cadence

- [ ] After every phase: update `IMPLEMENTED.md` (changelog), this file (tick), `README.md` (if structure changed)
- [ ] Monthly: review `:Lazy` updates, re-run `:checkhealth`, audit lockfile diff
- [ ] After any Java project work: confirm JDK switching, debugging, Spring Boot still function against real projects