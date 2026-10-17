# PLAN.md — Master Roadmap

Single source of truth for what this config is becoming and how. Phases are ordered by value and dependency. Status legend: `Not started` / `In progress` / `Blocked` / `Done` / `On hold`.

Guiding principles (from `AGENTS.md`):
1. **Standard** — use the mainstream, well-maintained tool for each job (jdtls, nvim-dap, mason, conform, gitsigns, etc.).
2. **Secure** — office usage: pinned dependencies, no telemetry/leaks, explicit review before any network-transmitting plugin.
3. **Modular** — one plugin per file under `lua/yuvan/plugins/`, `pcall`-guarded.
4. **Documented** — every change lands in `docs/IMPLEMENTED.md` + `CHECKPOINTS.md`.

---

## Phase 0 — Removals & security triage
**Status: On hold (awaiting user go-ahead)**

Rationale (already agreed in principle):
- Jupyter notebook stack (`jupyter.lua`) — not needed; also frees `<leader>sm/sv/sr`.
- Copilot (`copilot.lua` + 3 keymaps in `core/keymaps.lua`) — AI integration direction changed to Claude (Phase 6).
- Discord presence (`cord.lua`) — can transmit project/file names externally.
- FireNvim (`firenvim.lua`) — review whether buffer content can leave the machine.

Deliverables:
- Delete `lua/yuvan/plugins/jupyter.lua`, `lua/yuvan/plugins/copilot.lua`.
- Remove Copilot Chat keymaps from `core/keymaps.lua`.
- Decide on `cord.lua` / `firenvim.lua` (keep, disable, or remove).
- Run `:Lazy sync` so orphaned plugins drop from lockfile.
- Update `docs/IMPLEMENTED.md`, `CHECKPOINTS.md`, `docs/SECURITY.md`.

Acceptance: no references to jupyter/copilot remain; lockfile regenerated; config boots clean.

---

## Phase 1 — Java foundation (LSP / JDK)
**Status: Not started** → see `docs/JAVA.md` for full detail

- Adopt a Java LSP driver: **`nvim-java/nvim-java`** (recommended, all-in-one: jdtls + java-debug + java-test + spring-boot-tools, requires nvim ≥ 0.11.5) **or** `mfussenegger/nvim-jdtls` (manual, "keep it simple"). Decision needed.
- JDK strategy: **SDKMAN** already installed; register **multiple JDKs** (8, 11, 17, 21, 25) and wire per-project runtime selection (`vim.lsp.config('jdtls', { settings.java.configuration.runtimes })`).
- Lombok support (`lombok.nvim`) for false-positive-free enterprise code.
- Formatting: `google-java-format` via `conform.nvim`; add to `mason-tool-installer`.
- Treesitter: add `java`, `xml`, `properties`, `gradle`/`groovy` parsers.

Acceptance: open a Java file → jdtls attaches, diagnostics/format/organize-imports work; `:JavaSettingsChangeRuntime` (or equivalent) switches JDK.

---

## Phase 2 — Java debugging & testing
**Status: Not started**

- `nvim-dap` + `nvim-dap-ui` (+ virtual text) as the DAP core.
- Java debug adapter (`com.microsoft.java.debug.plugin`) loaded as jdtls bundle.
- `java-test` (JUnit 4/5) for run/debug from Neovim.
- Breakpoint/step/run keymaps in a `<leader>d` group (collides with existing diagnostics `<leader>d` → remap, see PLAN conflicts).
- Remote/attach debug for running apps (Servlet container, Spring Boot).

Acceptance: set breakpoint → `:JavaTestRunCurrentClass` or DAP debug main; step through and inspect.

---

## Phase 3 — Java build / Spring Boot / Servlet
**Status: Not started**

- Maven + Gradle project integration (build/compile/run from Neovim; `overseer.nvim` or direct `:make` / custom commands).
- **Spring Boot**: `JavaHello/spring-boot.nvim` (STS4 language server) for `application.properties`/`.yml` completion, bean/endpoint search, code actions.
- Spring Initializr project scaffolding (`spring init` CLI or `elmcgill/springboot-nvim`).
- Servlet/Tomcat/Jetty run + remote debug (attach DAP), container configuration.

Acceptance: run/debug a Spring Boot app, navigate properties, run a Servlet, attach debugger to a container.

---

## Phase 4 — JAR handling & decompilation
**Status: Not started**

- Inspect/list JAR contents; open class sources.
- Decompilers: **CFR** and/or **Vineflower** (JDK 17+); wire a Neovim command/keymap to decompile class/JAR.
- Candidates: `alienman5k/jdecomp.nvim` (dedicated plugin) or a thin custom command using `java -jar vineflower.jar`.
- Attach sources for libraries (Maven `sources` / `javap` for bytecode via jdtls).
- `referencedLibraries` config for external JARs in projects.

Acceptance: `:Decompile` (or plugin equivalent) opens decompiled source of a `.class`/`.jar` in a scratch buffer with highlighting.

---

## Phase 5 — Security hardening (office)
**Status: Not started** → see `docs/SECURITY.md`

- Enforce **lockfile pinning** and review each new plugin's maintainer/trust.
- Neovim runtime hardening: disable `exrc`/external config execution, modeline safety, `shada` hygiene, review `autoindent`/`clipboard`.
- Secrets: `gitleaks` / `git-secrets` pre-commit (opt-in), never store tokens in config.
- Dependency scanning: OWASP Dependency-Check / Trivy / Grype on project deps.
- SAST: SpotBugs + FindSecBugs (Java), Semgrep, optional SonarLint/Local.
- Remove/neutralize telemetry (`cord`, `firenvim`) pending decision.

Acceptance: documented checklist in `docs/SECURITY.md` marked done; no unscreened network plugins.

---

## Phase 6 — AI integration (Claude) — deferred
**Status: Blocked (decision deferred by user)**

Candidates (from research, choose one as primary):
| Plugin | Approach | Notes |
|---|---|---|
| `coder/claudecode.nvim` | Native IDE bridge (WebSocket/MCP protocol), inline diff accept/deny | Pure Lua; needs `folke/snacks.nvim`; closest to official VS Code/Claude Code experience. |
| `greggh/claude-code.nvim` | Floating terminal, auto file-reload, git root | Simple; uses `plenary.nvim` (already present). |
| `olimorris/codecompanion.nvim` | Chat/agent, multi-backend (Claude + others), slash commands | Provider-agnostic; heavier. |
| `folke/sidekick.nvim` | Lightweight CLI-agent bridge | Minimal. |

Reserved namespace: `<leader>a` (AI). Only one completion + one chat/agent tool at a time to avoid virtual-text conflicts.

Acceptance: chosen plugin added under `lua/yuvan/plugins/`, lazy-loaded, `<leader>a*` keymaps, documented in `IMPLEMENTED.md` + `PLAN.md`.

---

## Phase 7 — DX polish & maintenance
**Status: Not started**

- Lint Lua (`luacheck`/`selene`) + CI-style `stylua --check` gate.
- Git UX: `gitsigns.nvim` (+ optional `lazygit.nvim`).
- Replace deprecated `neodev.nvim` with lua_ls built-in; migrate `vim.lsp.config`/`vim.lsp.enable` to drop `vim.deprecate` shim.
- Consistent theme: lualine `theme = "auto"` (or cyberdream match) instead of hardcoded `nightfly`.
- Consolidate keymaps into `which-key` groups; remove dead commented code (`colorscheme.lua`, `lualine.lua`).
- Consider `mini.nvim`/`snacks.nvim` modules to reduce plugin count.

---

## Cross-cutting concerns

### Keymap conflict inventory (resolve during Phases 1–2)
| Binding | Current owner(s) | Resolution |
|---|---|---|
| `<leader>sm` | vim-maximizer, iron.nvim (jupyter) | Remove jupyter → maximizer wins |
| `<leader>sv` | window split, iron.nvim | Remove jupyter → split wins |
| `<leader>sr` | iron.nvim | Remove jupyter |
| `<C-h/j/k/l>` | smart-splits, vim-tmux-navigator | Decide one (smart-splits is richer) |
| `<leader>d` / `<leader>rn` | LSP diagnostics/rename | Reserve `<leader>d` for diagnostics; use `<leader>b` or `<leader>D` for DAP, or a `<leader>g` debug group |
| Insert `<C-j>` | nvim-cmp next item, Copilot accept | Remove Copilot → cmp wins |
| `<leader>cc` | Copilot chat (freed on removal) | Available for Claude (Phase 6) |

### Backlog (low priority)
- Markdown: keep `markview.nvim`; add `mkdnflow`/`render-markdown` only if needed.
- Split management: keep `smart-splits`; drop `vim-maximizer` if superseded.
- Performance: measure startup (`nvim --startuptime`) after big plugin additions.

### Documentation cadence
After every phase: update `IMPLEMENTED.md` (what changed), `CHECKPOINTS.md` (tick box), and `README.md` (if structure changed).