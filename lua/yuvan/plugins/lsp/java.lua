return {
  "nvim-java/nvim-java",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "JavaHello/spring-boot.nvim", commit = "218c0c26c14d99feca778e4d13f5ec3e8b1b60f0" },
    "MunifTanjim/nui.nvim",
    "mfussenegger/nvim-dap",
  },
  config = function()
    require("java").setup({
      -- Use the SDKMAN-managed JDK for jdtls instead of downloading one
      jdk = {
        auto_install = false,
        path = vim.fn.expand("~/.sdkman/candidates/java/21.0.12+1.1-tem"),
      },
    })

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

    local map = vim.keymap.set

    -- IntelliJ-style Java conveniences
    map("n", "<leader>jo", function()
      vim.lsp.buf.code_action({
        apply = true,
        filter = function(a)
          return a.kind == "source.organizeImports"
        end,
      })
    end, { desc = "Java: organize imports" })

    map("n", "<leader>jt", function()
      vim.cmd("JavaTestRunCurrentClass")
    end, { desc = "Java: run test class" })
    map("n", "<leader>jd", function()
      vim.cmd("JavaTestDebugCurrentClass")
    end, { desc = "Java: debug test class" })
    map("n", "<leader>jm", function()
      vim.cmd("JavaTestRunCurrentMethod")
    end, { desc = "Java: run test method" })
    map("n", "<leader>jM", function()
      vim.cmd("JavaTestDebugCurrentMethod")
    end, { desc = "Java: debug test method" })
    map("n", "<leader>jT", function()
      vim.cmd("JavaTestRunAllTests")
    end, { desc = "Java: run all tests" })
    map("n", "<leader>jR", function()
      vim.cmd("JavaTestDebugAllTests")
    end, { desc = "Java: debug all tests" })

    -- Run / debug application
    map("n", "<leader>jr", function()
      vim.cmd("JavaRunnerRunMain")
    end, { desc = "Java: run main class" })
    map("n", "<leader>js", function()
      vim.cmd("JavaRunnerStopMain")
    end, { desc = "Java: stop running app" })
    map("n", "<leader>jl", function()
      vim.cmd("JavaRunnerToggleLogs")
    end, { desc = "Java: toggle run logs" })
    map("n", "<leader>jp", function()
      vim.cmd("JavaProfile")
    end, { desc = "Java: run profiles" })

    map("n", "<leader>jV", function()
      vim.cmd("JavaTestViewLastReport")
    end, { desc = "Java: view last test report" })
    map("n", "<leader>jc", function()
      vim.cmd("JavaDapConfig")
    end, { desc = "Java: refresh debug configs" })
    map("n", "<leader>jv", function()
      vim.cmd("JavaSettingsChangeRuntime")
    end, { desc = "Java: change JDK runtime" })

    -- Spring Boot helpers
    map("n", "<leader>jsb", function()
      pcall(vim.cmd, "SpringBootDash")
    end, { desc = "Spring Boot: dashboard" })
    map("n", "<leader>jsa", function()
      pcall(vim.cmd, "SpringBootApp")
    end, { desc = "Spring Boot: apps" })
  end,
}
