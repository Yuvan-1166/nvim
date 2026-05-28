return {
  -- Inline Copilot Suggestions
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { expr = true, silent = true })
    end,
  },

  -- Copilot Chat Panel
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    cmd = { "CopilotChat", "CopilotChatToggle", "CopilotChatOpen" },
    dependencies = {
      "github/copilot.vim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("CopilotChat").setup({
        window = {
          layout = "vertical",
          width = 0.4,
        },
        mappings = {
          submit_prompt = {
            normal = "<CR>",
            insert = "<C-CR>",
          },
          close = {
            normal = "q",
            insert = "<C-c>",
          },
        },
      })
    end,
  },
}
