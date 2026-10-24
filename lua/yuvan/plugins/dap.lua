return {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()
    require("nvim-dap-virtual-text").setup()

    -- IntelliJ-style: debug UI follows the session
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- Remote/attach debugging (Servlet container or Spring Boot with JDWP agent)
    dap.configurations.java = dap.configurations.java or {}
    table.insert(dap.configurations.java, {
      type = "java",
      request = "attach",
      name = "Java: Attach to running process (JDWP :5005)",
      hostName = "localhost",
      port = 5005,
    })

    local map = vim.keymap.set

    map("n", "<leader>gb", dap.toggle_breakpoint, { desc = "Debug: toggle breakpoint" })
    map("n", "<leader>gB", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Debug: conditional breakpoint" })
    map("n", "<leader>gl", function()
      dap.set_breakpoint(nil, nil, vim.fn.input("Log message: "))
    end, { desc = "Debug: logpoint" })
    map("n", "<leader>gC", function()
      dap.clear_breakpoints()
    end, { desc = "Debug: clear all breakpoints" })

    map("n", "<leader>gc", dap.continue, { desc = "Debug: start/continue" })
    map("n", "<leader>gi", dap.step_into, { desc = "Debug: step into" })
    map("n", "<leader>go", dap.step_over, { desc = "Debug: step over" })
    map("n", "<leader>gO", dap.step_out, { desc = "Debug: step out" })

    map("n", "<leader>gu", function()
      dapui.toggle()
    end, { desc = "Debug: toggle UI" })
    map("n", "<leader>gr", function()
      dap.repl.open()
    end, { desc = "Debug: REPL" })
    map("n", "<leader>gh", function()
      require("dap.ui.widgets").hover()
    end, { desc = "Debug: evaluate under cursor" })
    map("n", "<leader>gq", function()
      dap.terminate()
    end, { desc = "Debug: terminate session" })
  end,
}
