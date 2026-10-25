return {
  "mfussenegger/nvim-dap",
  optional = true,
  keys = {
    {
      "<leader>ga",
      function()
        require("dap").run({
          type = "java",
          request = "attach",
          name = "Java: Attach (custom)",
          hostName = "127.0.0.1",
          port = tonumber(vim.fn.input("JDWP port: ", "5005")) or 5005,
        })
      end,
      desc = "Debug: attach to JDWP",
    },
  },
}
