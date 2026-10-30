return {
  "nvim-lua/plenary.nvim",
  event = "VeryLazy",
  config = function()
    local Job = require("plenary.job")
    local vineflower = vim.fn.expand("~/.local/share/nvim/decompilers/vineflower.jar")
    local java = vim.fn.expand("~/.sdkman/candidates/java/current/bin/java")

    vim.api.nvim_create_user_command("JavaDecompile", function(opts)
      local file = opts.args ~= "" and opts.args or vim.fn.expand("%:p")
      if file == "" then
        vim.notify("No file to decompile", vim.log.levels.WARN)
        return
      end
      local out = vim.fn.tempname() .. ".java"
      Job:new({
        command = java,
        args = { "-jar", vineflower, "-o=" .. out, file },
        on_exit = function(_, code)
          vim.schedule(function()
            if code ~= 0 then
              vim.notify("Decompile failed", vim.log.levels.ERROR)
              return
            end
            vim.cmd("edit " .. vim.fn.fnameescape(out))
            vim.bo.filetype = "java"
            -- avoid LSP attaching to temp decompile buffers
            vim.b[0].decompiled = true
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            for _, c in ipairs(clients) do
              pcall(vim.lsp.buf_detach_client, 0, c.id)
            end
          end)
        end,
      }):start()
    end, { nargs = "?", complete = "file" })

    vim.keymap.set("n", "<leader>xd", "<cmd>JavaDecompile<CR>", { desc = "Java: decompile class/JAR" })
  end,
}
