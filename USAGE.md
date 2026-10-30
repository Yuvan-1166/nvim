# Usage Guide

## Installation
1. Clone or symlink to `~/.config/nvim`
2. Start `nvim` - lazy.nvim installs plugins
3. `:Lazy sync` to update
4. Ensure SDKMAN JDKs installed (8, 11, 17, 21, 25)

## Java Workflow

### LSP
- Open `.java` files - jdtls attaches via nvim-java
- `<leader>jo` - organize imports
- `<leader>jv` - change JDK runtime
- `<leader>jc` - refresh DAP configs

### Run/Debug
- `<leader>jr` - run main class
- `<leader>js` - stop app
- `<leader>jl` - toggle logs
- `<leader>jp` - profiles
- `<leader>ga` - attach to JDWP (custom port)

### Testing
- `<leader>jt` - run test class
- `<leader>jd` - debug test class
- `<leader>jm` - run test method
- `<leader>jM` - debug test method
- `<leader>jT` - run all tests
- `<leader>jR` - debug all tests
- `<leader>jV` - view last test report

### DAP
- `<leader>gb` - toggle breakpoint
- `<leader>gB` - conditional breakpoint
- `<leader>gl` - logpoint
- `<leader>gC` - clear breakpoints
- `<leader>gc` - continue/start
- `<leader>gi` - step into
- `<leader>go` - step over
- `<leader>gO` - step out
- `<leader>gu` - toggle UI
- `<leader>gr` - REPL
- `<leader>gh` - hover eval
- `<leader>gq` - terminate

### Spring Boot
- `<leader>jsb` - Spring Boot actions
- `<leader>jsa` - Spring Boot apps
- `<leader>si` - Spring Initializr

### Build/Tasks
- `<leader>oo` - run task
- `<leader>ot` - toggle tasks
- `<leader>oa` - task action
- `<leader>oq` - quick action
- `<leader>tm` - Maven/Gradle run

### Decompile
- `<leader>xd` - decompile current class/JAR
- `:JavaDecompile [file]` - decompile file

### Git
- `<leader>gg` - LazyGit
- `<leader>hs/hr/hp/hb/hd` - gitsigns hunk actions

## Tips
- JDKs managed via SDKMAN in `~/.sdkman/candidates/java/`
- Vineflower at `~/.local/share/nvim/decompilers/vineflower.jar`
- Use `:checkhealth` for diagnostics
- Docs in `docs/` folder
