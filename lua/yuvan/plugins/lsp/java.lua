return {
  "nvim-java/nvim-java",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "JavaHello/spring-boot.nvim", commit = "218c0c26c14d99feca778e4d13f5ec3e8b1b60f0" },
    "MunifTanjim/nui.nvim",
    "mfussenegger/nvim-dap",
  },
  config = function()
    require("java").setup()

    -- SDKMAN-managed Temurin runtimes (21 is the default)
    vim.lsp.config("jdtls", {
      settings = {
        java = {
          configuration = {
            runtimes = {
              {
                name = "JavaSE-1.8",
                path = vim.fn.expand("~/.sdkman/candidates/java/8.0.504+1-tem"),
              },
              {
                name = "JavaSE-11",
                path = vim.fn.expand("~/.sdkman/candidates/java/11.0.32+1.1-tem"),
              },
              {
                name = "JavaSE-17",
                path = vim.fn.expand("~/.sdkman/candidates/java/17.0.20-tem"),
              },
              {
                name = "JavaSE-21",
                path = vim.fn.expand("~/.sdkman/candidates/java/21.0.12+1.1-tem"),
                default = true,
              },
              {
                name = "JavaSE-25",
                path = vim.fn.expand("~/.sdkman/candidates/java/25.0.4.1+1-tem"),
              },
            },
          },
        },
      },
    })

    vim.lsp.enable("jdtls")
  end,
}
