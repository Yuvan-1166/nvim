return {
  "elmcgill/springboot-nvim",
  ft = { "java", "yaml", "yml", "properties" },
  dependencies = {
    "neovim/nvim-lspconfig",
  },
  config = function()
    local ok, sb = pcall(require, "springboot-nvim")
    if not ok then
      return
    end
    sb.setup({})
  end,
}
