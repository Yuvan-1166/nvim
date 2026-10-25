return {
  "stevearc/overseer.nvim",
  cmd = { "OverseerRun", "OverseerToggle", "OverseerQuickAction", "OverseerTaskAction", "OverseerClearCache" },
  event = "VeryLazy",
  opts = {
    strategy = { "toggleterm", use_shell = false },
    templates = { "builtin", "user.maven", "user.gradle" },
    task_list = {
      bindings = {
        ["<C-h>"] = false,
        ["<C-j>"] = false,
        ["<C-k>"] = false,
        ["<C-l>"] = false,
      },
    },
  },
  config = function(_, opts)
    require("overseer").setup(opts)

    local map = vim.keymap.set
    map("n", "<leader>oo", "<cmd>OverseerRun<CR>", { desc = "Tasks: run" })
    map("n", "<leader>ot", "<cmd>OverseerToggle<CR>", { desc = "Tasks: toggle list" })
    map("n", "<leader>oa", "<cmd>OverseerTaskAction<CR>", { desc = "Tasks: action" })
    map("n", "<leader>oq", "<cmd>OverseerQuickAction<CR>", { desc = "Tasks: quick action" })
  end,
}
