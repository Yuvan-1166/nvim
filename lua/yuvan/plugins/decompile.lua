return {
  "Michal-Atlas/decomp-nvim",
  cmd = { "Decomp" },
  config = function()
    local ok, decomp = pcall(require, "decomp-nvim")
    if not ok then
      return
    end
    decomp.setup({
      decompiler = {
        jar_path = vim.fn.expand("~/.local/share/nvim/decompilers/vineflower.jar"),
        java_path = vim.fn.expand("~/.sdkman/candidates/java/current/bin/java"),
      },
    })
  end,
}
