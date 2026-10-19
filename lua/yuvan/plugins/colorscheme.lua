return {
  "scottmckendry/cyberdream.nvim",
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    vim.cmd("colorscheme cyberdream")
  end,
}
