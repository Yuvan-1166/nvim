# SECURITY.md — Office / Workplace Security Posture

This config is intended for **office/workplace use**. The guiding rule: **nothing about the work should leak out of the machine unless explicitly required, and every dependency should be pinned and reviewable.** This doc is the security reference for the Neovim config and the Java toolchain it provisions.

Companion docs: [`PLAN.md`](PLAN.md) (Phase 5), [`JAVA.md`](JAVA.md) (Java tooling), [`../AGENTS.md`](../AGENTS.md) (policy).

---

## 1. Threat model (what we care about)

| Vector | Risk | Mitigation |
|---|---|---|
| **Telemetry / rich presence** | Plugins phoning home with file/project names (e.g., Discord RPC). | Remove/neutralize `cord.lua`. No cloud plugins without review. |
| **Cloud AI** | Code sent to third-party servers (Copilot, cloud LSPs). | Remove Copilot; only add AI with explicit approval + local/enterprise endpoint. |
| **Browser bridge** | Buffers transmitted via browser extension (FireNvim). | Review; disable unless proven local-only. |
| **Supply chain (plugins)** | Malicious/compromised git plugin, or unpinned update pulls bad code. | lazy.nvim **lockfile pinning**; review maintainers; avoid rarely-used plugins; vendor critical ones if needed. |
| **Supply chain (Java deps)** | Known CVEs in Maven/Gradle dependencies. | OWASP Dependency-Check, Trivy/Grype, Dependabot/Renovate-style updates. |
| **Vulnerable code (Java)** | Security bugs in source (injection, unsafe deserialization, etc.). | SpotBugs + FindSecBugs, Semgrep, SonarLint, CodeQL if available. |
| **Secrets in repo/config** | API keys, tokens, keystore passwords committed. | `gitleaks`/`git-secrets` pre-commit; never store secrets in config; `.gitignore`. |
| **Auto-execution of untrusted code** | Neovim `exrc`/modeline/plugins executing code from the opened project. | Disable `exrc`; restrict modelines; review `.nvim.lua` usage. |
| **Outbound in CI/build** | Build tools phoning home or pulling unpinned artifacts. | Mirror/proxy Maven/Gradle; pin versions; audit `settings.xml`/`init.gradle`. |
| **Compromised terminal tools** | Decompilers/CLIs from untrusted sources. | Download from official releases, verify hashes, keep in a pinned dir. |

---

## 2. Current review status (baseline)

| Plugin / feature | File | Status | Action |
|---|---|---|---|
| Copilot + CopilotChat | `plugins/copilot.lua` | 🟢 **Removed** (Phase 0) | No code leaves machine via Copilot now |
| Jupyter notebooks | `plugins/jupyter.lua` | 🟢 **Removed** (Phase 0) | Unused; reduced surface |
| Discord RPC | `plugins/cord.lua` | 🟢 **Removed** (Phase 0) | External leak eliminated |
| FireNvim | `plugins/firenvim.lua` | 🟡 **Kept / reviewed** | Local loopback by default; no egress unless reconfigured. Low risk. Remove on request. |
| All other plugins | rest of `lua/yuvan/plugins/` | Pinned via `lazy-lock.json` (38 entries) | Keep; re-review on each update |

> **Tech-debt note:** `vim.deprecate` stub has been **removed** (it was hiding deprecation warnings). 0 deprecation warnings now surface; if any appear later, fix the underlying call rather than re-stubbing.

---

## 3. Neovim runtime hardening checklist

- [x] Ensure `exrc` is **disabled** (`vim.o.exrc = false`), so Neovim does not auto-run project-local config. (done: `lua/yuvan/core/options.lua`)
- [ ] Review modeline handling; keep `modeline` enabled but ensure untrusted files aren't auto-opened with plugins attached.
- [ ] Keep `shada`/undo history on a local, non-shared path; don't sync secrets in shada.
- [ ] Avoid `:!` shell commands built from untrusted file paths (current `:Comp` uses fixed path — keep it fixed).
- [ ] `clipboard` = `unnamedplus` is fine locally; be aware copy goes to system clipboard (X11/Wayland) — acceptable in office, just don't paste secrets into shared terminals.
- [ ] Do not `git pull`/update plugins while working on sensitive code without reviewing the changelog/lockfile diff.

---

## 4. Plugin supply-chain policy

1. **Pinned commits** — `lazy-lock.json` is the single source of truth for versions; commit it.
2. **Review before adding** — check maintainer, stars/activity, `build`/`install` hooks (these run arbitrary commands), and any network calls.
3. **Prefer mainstream** — `nvim-dap`, `nvim-treesitter`, `telescope`, `mason`, `conform`, `nvim-jdtls`/`nvim-java` (well-known).
4. **No anonymous `build` scripts** without inspection — e.g. `cord.lua` uses `build = "./build || .\\build"`; inspect before trusting.
5. **Update cadence** — update deliberately (not auto), read `:Lazy` changelog, re-run `:checkhealth`.
6. **nvim-java downloads** — jdtls, java-debug, java-test, lombok and spring-boot-tools jars are fetched once by nvim-java's `auto_install` into `~/.local/share/nvim/nvim-java/` (versions come from nvim-java's pinned defaults). Reviewed in Phase 1: local dev tooling, no code egress. Set `auto_install = false` + `path = ...` to use externally managed copies instead.

---

## 5. Java dependency & code scanning (for the projects you edit)

Install and wire these in Phase 5 (see `JAVA.md` §9):
- **Dependency CVEs:** OWASP Dependency-Check (`dependency-check-maven`/`dependency-check-gradle`), **Trivy** / **Grype** on JARs/images.
- **SAST (Java):** SpotBugs + **FindSecBugs**, **Semgrep** (Java security rules), optional SonarLint (local/offline).
- **SBOM:** CycloneDX/SPDX generation for releases.
- **Pinning:** enforce Maven/Gradle wrapper (`mvnw`/`gradlew`) + lock/verify checksums where supported.

> These run on *project code*, not on the Neovim config, but the config should provision them (mason/tool installer) so they're available inside the editor/CI.

---

## 6. Secrets management

- Never commit tokens, API keys, keystores, `application-*.properties` with credentials, or `.env`.
- Consider `gitleaks` pre-commit (opt-in). Maven/Gradle mirror/proxy can be documented here for air-gapped setups.
- Use a secret manager or environment variables; for Spring, externalize secrets (Vault/env) and keep only `application-*.example.yml` in git.
- Add pre-commit secret scanning: `gitleaks detect` or `git-secrets` (opt-in, documented so it doesn't block unrelated work).
- Rotate anything that was ever committed.

---

## 7. Network / air-gapped considerations

- Office networks may block `github.com`, Maven Central, Eclipse update sites. Provide mirror/proxy config:
  - Maven: `~/.m2/settings.xml` with internal mirror.
  - Gradle: `init.gradle` / internal repo.
  - mason: point to internal registry or pre-install LSP/decompiler jars and reference them by path (avoid mason download at runtime).
- Any plugin that downloads binaries at install time must be pinned and, ideally, pre-vendored.

---

## 8. Reporting / change log

Any change to security-relevant plugins (add/remove/disabling) must be recorded here **and** in `docs/IMPLEMENTED.md`:

| Date | Item | Change | Reason |
|---|---|---|---|
| Phase 0 | copilot.lua, CopilotChat keymaps | **Removed** | Office IP/telemetry — no cloud code egress |
| Phase 0 | cord.lua (Discord) | **Removed** | Rich presence leaked project/file context externally |
| Phase 0 | jupyter.lua | **Removed** | Unused; reduced attack/complexity surface |
| Phase 0 | neodev.nvim | **Removed** | Deprecated; functionality in lua_ls |
| Phase 0 | vim-deprecate stub | **Removed** | Hid deprecation warnings (0 now) |
| Phase 0 | firenvim.lua | **Kept, reviewed** | Local loopback only; low risk — remove on request |
| Phase 1 | nvim-java, spring-boot.nvim, nui.nvim, nvim-dap | **Added** | Java IDE stack; well-known maintainers, commits pinned in `lazy-lock.json`, no telemetry |
| Phase 1 | google-java-format (mason) | **Added** | Local formatter binary; no network/telemetry |
| Phase 1 | nvim-java jar downloads (jdtls / java-debug / java-test / lombok / spring-boot-tools) | **Reviewed** | Versioned jars fetched once into `~/.local/share/nvim/nvim-java/` (versions from nvim-java defaults); local dev tooling only — no code egress |
| (baseline) | firenvim.lua | flagged then reviewed | Browser bridge egress risk — assessed low (loopback) |
| Phase 4 | Vineflower 1.11.1 (local jar) | **Added** | Local offline-capable decompiler in `~/.local/share/nvim/decompilers/`; used only on trusted artifacts. Hash: see file on disk. |