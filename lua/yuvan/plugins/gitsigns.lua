return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
    current_line_blame = false,
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      map("n", "]c", function()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          gs.next_hunk()
        end)
        return "<Ignore>"
      end, { expr = true, desc = "Git: next hunk" })

      map("n", "[c", function()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return "<Ignore>"
      end, { expr = true, desc = "Git: prev hunk" })

      map("n", "<leader>hs", gs.stage_hunk, { desc = "Git: stage hunk" })
      map("n", "<leader>hr", gs.reset_hunk, { desc = "Git: reset hunk" })
      map("n", "<leader>hp", gs.preview_hunk, { desc = "Git: preview hunk" })
      map("n", "<leader>hb", function()
        gs.blame_line({ full = true })
      end, { desc = "Git: blame line" })
      map("n", "<leader>hd", gs.diffthis, { desc = "Git: diff this" })
    end,
  },
}
