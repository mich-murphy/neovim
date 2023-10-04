return {

  -- configure tokyonight theme
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = { style = "night" },
  -- },

  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
  },

  -- Configure LazyVim to colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  },
}
