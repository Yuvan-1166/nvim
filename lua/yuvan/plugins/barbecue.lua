return {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
        "SmiteshP/nvim-navic",
        "nvim-tree/nvim-web-devicons",
    },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        vim.opt.updatetime = 200

        require("barbecue").setup({
            attach_navic = true,
            create_autocmd = true, -- let barbecue handle its own updates
            show_dirname = true,
            show_basename = true,
            show_modified = false,
        })
    end,
}
