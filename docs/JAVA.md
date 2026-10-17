# JAVA.md — Comprehensive Java Support Plan

Goal: first-class Java development in Neovim for **JDK 8 through latest (21/25)**, covering JAR handling, source decompilation, debugging, Servlets, and Spring Boot, with enterprise/office-grade rigor.

Companion docs: [`PLAN.md`](PLAN.md) (phases), [`SECURITY.md`](SECURITY.md) (scanning/dependency policy), [`../AGENTS.md`](../AGENTS.md) (context/conventions).

---

## 1. Environment (current)

| Item | Value |
|---|---|
| Neovim | 0.12.5 (≥ 0.11.5 required for `nvim-java`; ≥ 0.12 for latest `spring-boot.nvim`) |
| Default JDK | Temurin `21.0.12.1` (SDKMAN: `~/.sdkman/candidates/java/21.0.12+1.1-tem`) |
| JDK manager | **SDKMAN** (installed). Candidates dir: `~/.sdkman/candidates/java/` |
| Maven | `3.9.11` |
| Gradle | `8.7` |
| LSP | none for Java yet (see Phase 1) |

Notes:
- `eclipse.jdt.ls` (jdtls) **itself runs on Java 21**, but it can compile/analyze projects targeting **Java ≥ 8** by configuring `java.configuration.runtimes`.
- SDKMAN (`sdk install java 8.0.x-tem`, `sdk install java 11...`, `17`, `21`, `25`) lets you keep several JDKs; Neovim must be pointed at the right one per project (below).
- Shell may not have `sdk` on non-interactive `$PATH`; ensure `~/.sdkman/bin/sdkman-init.sh` is sourced in bashrc so Neovim/lspconfig sees candidates.

---

## 2. Language Server (LSP) — jdtls

### 2.1 Recommended driver: `nvim-java/nvim-java`
All-in-one, "painless Java", actively maintained. It:
- Starts jdtls and loads **`java-debug`**, **`java-test`**, and **`spring-boot-tools`** as jdtls bundles (via mason).
- Auto-configures **nvim-dap** for Java.
- Provides run/test/refactor commands (see §6).
- Requires **Neovim 0.11.5+** (we have 0.12.5).

lazy.nvim spec (to add as `lua/yuvan/plugins/java.lua` in Phase 1):

```lua
return {
  "nvim-java/nvim-java",
  ft = { "java", "xml", "jproperties" },
  dependencies = {
    "nvim-java/lua-async-await",
    "nvim-java/nvim-java-dap",
    "MunifTanjim/nui.nvim",
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
  },
  config = function()
    require("java").setup()
    -- LSP enable via vim.lsp (jdtls)
    vim.lsp.enable("jdtls")
  end,
}
```

### 2.2 Alternative (manual, KISS): `mfussenegger/nvim-jdtls`
Choose this if you want full control and a smaller surface. Provides:
`organize_imports`, `extract_variable/field/method`, `JdtCompile`, `JdtSetRuntime`, `JdtBytecode`, `JdtJshell`, `JdtRestart`, plus DAP integration when `java-debug`/`java-test` bundles are supplied.
Requires explicit `bundles = { java-debug-*.jar, java-test/*.jar }` and `init_options`.

**Decision (pending):** default to `nvim-java`; fall back to `nvim-jdtls` if it conflicts with the existing `mason`/`lspconfig` setup (nvim-java even checks `nvim_jdtls_conflict`).

### 2.3 Multi-JDK configuration (JDK 8 → latest)
Register every installed JDK so jdtls can build against any of them, and set the default:

```lua
vim.lsp.config("jdtls", {
  settings = {
    java = {
      configuration = {
        runtimes = {
          { name = "JavaSE-1.8", path = vim.fn.expand("~/.sdkman/candidates/java/8.0.x-tem"), default = false },
          { name = "JavaSE-11",  path = vim.fn.expand("~/.sdkman/candidates/java/11.0.x-tem"), default = false },
          { name = "JavaSE-17",  path = vim.fn.expand("~/.sdkman/candidates/java/17.0.x-tem"), default = false },
          { name = "JavaSE-21",  path = vim.fn.expand("~/.sdkman/candidates/java/21.0.12+1.1-tem"), default = true },
          { name = "JavaSE-25",  path = vim.fn.expand("~/.sdkman/candidates/java/25.0.x-tem"), default = false },
        },
      },
      -- enterprise defaults often need this:
      -- eclipse = { downloadSources = true },
    },
  },
})
```

Runtime switching at runtime: `nvim-java` → `:JavaSettingsChangeRuntime`; jdtls → `JdtSetRuntime`. Auto-detect per project via `.sdkmanrc` / `.java-version` (SDKMAN `sdk env`) is a Phase-1 nice-to-have.

### 2.4 Lombok
`lombok.nvim` (mfussenegger) — attaches the lombok agent to jdtls to eliminate `@Slf4j`/`@Data` false diagnostics and broken getters/setters. Essential for Spring projects.

### 2.5 Treesitter parsers to add
`java`, `xml`, `properties`, `groovy` / `gradle` (build files), `sql` (already present).

---

## 3. JAR handling & decompilation

JARs are ZIPs → open/list with built-in zip support; richer tooling:

| Need | Tool |
|---|---|
| List/extract contents | `jar tf` / `unzip`; nvim-tree can browse zip |
| Bytecode view | jdtls `JdtBytecode` / `javap -c` |
| Decompile `.class`/`.jar` → Java source | **CFR** (`cfr.jar`) or **Vineflower** (`vineflower.jar`, JDK 17+) |
| In-editor decompile | `alienman5k/jdecomp.nvim` (uses CFR by default) or a thin custom command |

Decompile command (thin custom, Phase 4):
```vim
" :JavaDecompile <file-or-jar>
java -jar ~/.local/share/java/vineflower.jar <in> <out-dir>
" or for a single class:
java -jar ~/.local/share/java/cfr.jar <class-or-jar> --outputdir /tmp/decomp
```
- Keep decompiler JARs pinned (versioned) under `~/.local/share/java/` or a local dir; record hashes in `docs/SECURITY.md`.
- Disable LSP/syntax-on for decompiled buffers (avoid jdtls running on generated source), as `jdecomp.nvim` does.

Referenced libraries (external JARs in a project):
```lua
vim.lsp.config("jdtls", {
  settings = { java = { project = { referencedLibraries = { "lib/*.jar" } } } },
})
```

---

## 4. Debugging (DAP)

- Core: `mfussenegger/nvim-dap` (+ `nvim-dap-ui`, optional `nvim-dap-virtual-text`).
- Java adapter: `com.microsoft.java.debug.plugin` (loaded as a jdtls bundle by `nvim-java`, or manual `bundles` with `nvim-jdtls`).
- Debug flows:
  - **Application**: `:JavaRunnerRunMain` / DAP launch config for main class.
  - **Unit tests**: `:JavaTestDebugCurrentClass` / `:JavaTestDebugCurrentMethod`.
  - **Servlet / container (Tomcat/Jetty)**: run with agent (`-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005`) and **attach** DAP to port 5005.
  - **Remote/attach** config for running Spring Boot (`spring-boot.run.jvmArguments` with debug agent).

Keymaps (tentative; resolve `<leader>d` conflict in PLAN):
- `<leader>db` toggle breakpoint, `<leader>dc` continue, `<leader>di` step into, `<leader>do` step over, `<leader>dr` REPL, `<leader>du` toggle UI.
- Suggest shifting existing LSP diagnostics `<leader>d` → keep; use `<leader>D` is taken (buffer diagnostics); consider `<leader>g` for debug group or use `<leader>db`+ style which is free.

---

## 5. Testing

- `java-test` (vscode-java-test) via jdtls bundle → JUnit 4/5 run + debug from Neovim.
- Commands (`nvim-java`): `:JavaTestRunCurrentClass`, `:JavaTestDebugCurrentClass`, `:JavaTestRunCurrentMethod`, `:JavaTestDebugCurrentMethod`, `:JavaTestRunAllTests`, `:JavaTestDebugAllTests`, `:JavaTestViewLastReport`.
- Alternative lightweight: run `mvn test` / `gradle test` via terminal/`overseer.nvim` and parse output; but jdtls test integration is the standard.

---

## 6. Build tools (Maven / Gradle)

- Compile/run/test via Neovim without leaving the editor:
  - **`stevearc/overseer.nvim`** — run `mvn/gradle` tasks as structured tasks with quickfix integration (recommended).
  - Simpler: custom commands + `:make` with `makeprg`/`errorformat`.
- `nvim-java` runner commands: `:JavaRunnerRunMain`, `:JavaRunnerStopMain`, `:JavaRunnerToggleLogs`.
- Build workspace: `:JavaBuildBuildWorkspace`, `:JavaBuildCleanWorkspace`.
- Wrapper support (`mvnw`, `gradlew`) should be preferred for reproducibility; ensure `./mvnw` is used when present.

---

## 7. Spring Boot

- **`JavaHello/spring-boot.nvim`** — integrates the **STS4 / Spring Boot Language Server**:
  - `application.properties` / `application.yml` completion + navigation.
  - Spring annotation/dependency hints, code actions.
  - Find Beans by annotation, Discover Web Endpoints (via LSP workspace symbols → Telescope `lsp_workspace_symbols`).
- Provides jdtls extension jars: `require("spring_boot").java_extensions()` and `require("spring_boot").init_lsp_commands()`.
- With `nvim-java`, spring-boot-tools are enabled by default (`spring_boot_tools.enable = true`, language server auto-installed via mason).
- Project scaffolding: Spring Initializr via CLI (`spring init ...`) or `elmcgill/springboot-nvim` (`:SpringBootNewProject`) — needs Spring Boot CLI (SDKMAN `sdk install springboot`).

---

## 8. Servlet / Java EE

- Servlet projects (Tomcat/Jetty/WildFly): syntax/namespace completion via jdtls + `web.xml`/annotations.
- Run: deploy WAR to container or run embedded (Spring Boot); invoke container startup from Neovim terminal.
- Debug: attach DAP to the container's JDWP port (see §4).
- `xml` treesitter parser for deployment descriptors (`web.xml`).
- Optional: `jdtls` "run on server" style configs are not standard in nvim — prefer container CLI + attach.

---

## 9. Formatting & Linting

- **Formatting** (via `conform.nvim`, extend `plugins/formatting.lua`):
  - `java = { "google-java-format" }` (add to `mason-tool-installer`) — standard, reproducible.
  - Alternative: jdtls built-in formatter (`vim.lsp.buf.format` with jdtls).
- **Lint / security analysis** (see `SECURITY.md`):
  - SpotBugs + FindSecBugs plugin (bytecode-level, Java-specific).
  - Semgrep (fast rules, incl. Java security rulesets).
  - Optional SonarLint (local, offline mode).
  - OWASP Dependency-Check, Trivy, Grype for vulnerable deps.

---

## 10. Commands / keymap sketch (post-implementation)

| Action | Suggested key |
|---|---|
| Organize imports | `<leader>co` or `<A-o>` |
| Extract variable/field | `<leader>c` + motion |
| Build workspace | `<leader>jb` |
| Run main | `<leader>jr` |
| Stop main | `<leader>js` |
| Run test class | `<leader>jt` |
| Debug test class | `<leader>jd` |
| Toggle breakpoint | `<leader>db` |
| Continue/step | `<leader>dc` / `<leader>di` / `<leader>do` |
| Decompile class/jar | `<leader>jD` |
| Change runtime | `<leader>jv` |

(All keys must be checked against existing `<leader>` groups — see conflict table in `PLAN.md`.)

---

## 11. Implementation checklist (maps to PLAN Phases 1–4)

- [ ] Add `java` (and `xml`, `properties`, `groovy`) treesitter parsers.
- [ ] Add `lua/yuvan/plugins/java.lua` with chosen jdtls driver.
- [ ] Add Lombok support.
- [ ] Register JDK runtimes (8/11/17/21/25) + runtime switching.
- [ ] Install JDKs via SDKMAN (8, 11, 17, 21, 25).
- [ ] Add `google-java-format` to conform + mason-tool-installer.
- [ ] Add `nvim-dap` + `nvim-dap-ui` (+ virtual text) and Java adapter.
- [ ] Wire `java-test` for JUnit run/debug.
- [ ] Add `spring-boot.nvim` (STS4) + verify properties/yml completion + bean search.
- [ ] Add Maven/Gradle task runner (overseer or custom commands).
- [ ] Add decompiler tooling (CFR/Vineflower + keymap/command).
- [ ] Configure Servlet/container debug attach.
- [ ] Verify each capability against a real Spring Boot project and a plain Java 8 project.
- [ ] Update `docs/IMPLEMENTED.md`, `CHECKPOINTS.md`, `README.md`.

---

## 12. Risks & notes

- `nvim-java` and `nvim-jdtls` must **not** both manage jdtls (conflict). Pick one.
- jdtls startup on large projects is slow first time (workspace indexing). Set `-Xmx` via `jdtls` config if needed.
- Decompilers output is generated code — do not let LSP/format-on-save run on it.
- Any plugin that downloads jars (mason, spring-boot LS, decompilers) must be pinned; see `SECURITY.md`.
- Office networks may restrict outbound; mason downloads and Maven central access must be allowed or mirrored/proxied.