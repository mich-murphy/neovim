return {

  -- undo tree
  {
    "simnalamburt/vim-mundo",
    keys = {
      { "<leader>su", "<cmd>MundoToggle<cr>", desc = "Search undo tree" },
    },
  },

  -- disable builtin telescope dependancy
  { "nvim-telescope/telescope-fzf-native.nvim", enabled = false },

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
