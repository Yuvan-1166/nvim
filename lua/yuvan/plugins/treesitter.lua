return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    local parsers = {
      "c",
      "cpp",
      "go",
      "json",
      "javascript",
      "typescript",
      "tsx",
      "yaml",
      "html",
      "css",
      "markdown",
      "markdown_inline",
      "svelte",
      "bash",
      "lua",
      "dockerfile",
      "gitignore",
      "python",
      "sql",
      "toml",
    }

    local treesitter_ok, treesitter = pcall(require, "nvim-treesitter")
    if not treesitter_ok then
      return
    end

    -- Install missing parsers (async, no-op when already present)
    treesitter.install(parsers)

    -- Neovim 0.11+ native highlighting + treesitter indentation
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("UserTreesitter", {}),
      callback = function(ev)
        if pcall(vim.treesitter.start, ev.buf) then
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    -- configure nvim-ts-autotag separately
    local autotag_ok, autotag = pcall(require, "nvim-ts-autotag")
    if not autotag_ok then
      return
    end

    autotag.setup({
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
    })
  end,
}
