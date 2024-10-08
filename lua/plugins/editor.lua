return {

  -- undo tree
  {
    "mbbill/undotree",
    lazy = true,
    keys = {
      { "<leader>su", "<cmd>UndotreeToggle<cr>", desc = "Search undo tree" },
    },
  },

  -- customize file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      close_if_last_window = true,
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        group_empty_dirs = true,
        hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
      },
    },
  },
}
