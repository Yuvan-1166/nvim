# Neovim Config (yuvan)

Modular, lazy-loaded Neovim config for Java-first development with security hardening.

## Quick start

1. Symlink to `~/.config/nvim`
2. Open Neovim — lazy.nvim installs plugins
3. `:Lazy sync` after changes

## Java

- LSP: nvim-java + jdtls (JDK 8/11/17/21/25)
- Debug/Test: nvim-dap + java-debug/java-test
- Build: overseer.nvim (Maven/Gradle)
- Spring Boot: spring-boot.nvim + springboot-nvim
- Decompile: Vineflower (`:JavaDecompile` / `<leader>xd`)

## Keymaps

- Leader: `Space`
- Java: `<leader>j*` | Debug: `<leader>g*` | Tasks: `<leader>o*` | Git: `<leader>h*` / `<leader>gg`

## Docs

- [PLAN](docs/PLAN.md) | [CHECKPOINTS](docs/CHECKPOINTS.md) | [IMPLEMENTED](docs/IMPLEMENTED.md) | [JAVA](docs/JAVA.md) | [SECURITY](docs/SECURITY.md)

Phases 0-7 complete. Claude integration deferred.
