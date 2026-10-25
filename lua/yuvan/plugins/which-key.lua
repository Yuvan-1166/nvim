return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    spec = {
      { "<leader>g", group = "debug" },
      { "<leader>j", group = "java" },
      { "<leader>o", group = "tasks" },
      { "<leader>x", group = "decompile" },
    },
  },
}
