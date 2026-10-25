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
      { "<leader>h", group = "git" },
      { "<leader>j", group = "java" },
      { "<leader>o", group = "tasks" },
      { "<leader>s", group = "spring" },
      { "<leader>t", group = "tomcat" },
      { "<leader>x", group = "decompile" },
    },
  },
}
