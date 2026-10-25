local overseer = require("overseer")

return {
  name = "maven",
  builder = function()
    return {
      cmd = { "mvn" },
      args = { "compile" },
      components = { { "on_output_quickfix", open = true }, "default" },
    }
  end,
  desc = "Maven compile (custom)",
  tags = { overseer.TAG.BUILD },
  condition = {
    filetype = { "java" },
    callback = function(search)
      return vim.fn.filereadable(search.dir .. "/pom.xml") == 1
    end,
  },
}
