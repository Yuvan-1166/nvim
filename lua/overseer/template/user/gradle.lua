local overseer = require("overseer")

return {
  name = "gradle",
  builder = function()
    local cmd = vim.fn.filereadable("gradlew") == 1 and "./gradlew" or "gradle"
    return {
      cmd = { cmd },
      args = { "build" },
      components = { { "on_output_quickfix", open = true }, "default" },
    }
  end,
  desc = "Gradle build (custom)",
  tags = { overseer.TAG.BUILD },
  condition = {
    filetype = { "java" },
    callback = function(search)
      return vim.fn.filereadable(search.dir .. "/build.gradle") == 1
        or vim.fn.filereadable(search.dir .. "/build.gradle.kts") == 1
    end,
  },
}
