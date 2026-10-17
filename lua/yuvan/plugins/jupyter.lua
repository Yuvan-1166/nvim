return {
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    config = true,
  },

  {
    "hkupty/iron.nvim",
    event = "VeryLazy",
    config = function()
      local ok, iron = pcall(require, "iron.core")
      if not ok then
        return
      end

      iron.setup({
        config = {
          repl_definition = {
            python = {
              command = { "ipython", "--no-autoindent" },
            },
          },
          repl_open_cmd = require("iron.view").bottom,
        },
        keymaps = {
          send_motion = "<leader>sm",
          visual_send = "<leader>sv",
          send_file = "<leader>sf",
          send_line = "<leader>sl",
          restart = "<leader>sr",
        },
      })
    end,
  },

  {
    "GCBallesteros/NotebookNavigator.nvim",
    event = "VeryLazy",
    dependencies = {
      "GCBallesteros/jupytext.nvim",
      "echasnovski/mini.comment",
      "hkupty/iron.nvim",
    },
    config = function()
      local ok, nn = pcall(require, "notebook-navigator")
      if not ok then
        return
      end

      nn.setup({
        activate_hydra_keys = "<leader>h",
        repl_provider = "iron",
        syntax_highlight = true,
        cell_highlight_group = "Folded",
      })

      vim.keymap.set("n", "]h", function()
        nn.move_cell("d")
      end, { desc = "Next notebook cell" })
      vim.keymap.set("n", "[h", function()
        nn.move_cell("u")
      end, { desc = "Previous notebook cell" })
      vim.keymap.set("n", "<leader>xx", function()
        nn.run_cell()
      end, { desc = "Run notebook cell" })
      vim.keymap.set("n", "<leader>xr", function()
        nn.run_and_move()
      end, { desc = "Run notebook cell and move" })
      vim.keymap.set("n", "<leader>xa", function()
        nn.run_all_cells()
      end, { desc = "Run all notebook cells" })
    end,
  },
}
