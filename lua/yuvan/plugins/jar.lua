return {
  "davidmh/jarvis.nvim",
  ft = { "jar", "class" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local ok, jarvis = pcall(require, "jarvis")
    if not ok then
      return
    end
    jarvis.setup({})
  end,
}
