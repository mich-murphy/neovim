local in_herdr = vim.env.HERDR_ENV == "1"

return {
  -- Pane navigation between WezTerm and Neovim when Herdr is not the mux.
  {
    "mrjones2014/smart-splits.nvim",
    enabled = not in_herdr,
    lazy = false,
    keys = {
      {
        "<C-h>",
        function()
          require("smart-splits").move_cursor_left()
        end,
        desc = "Move cursor to left pane",
      },
      {
        "<C-j>",
        function()
          require("smart-splits").move_cursor_down()
        end,
        desc = "Move cursor to below pane",
      },
      {
        "<C-k>",
        function()
          require("smart-splits").move_cursor_up()
        end,
        desc = "Move cursor to above pane",
      },
      {
        "<C-l>",
        function()
          require("smart-splits").move_cursor_right()
        end,
        desc = "Move cursor to right pane",
      },
    },
  },

  -- Process-aware navigation between Neovim splits and Herdr panes.
  {
    "lmilojevicc/herdr-splits.nvim",
    enabled = in_herdr,
    tag = "v0.5.1",
    lazy = false,
    opts = {
      at_edge = "stop",
      nav_at_edge = "stop",
      unzoom_on_nav = true,
    },
    keys = {
      {
        "<C-h>",
        function()
          require("herdr-splits").move_cursor_left()
        end,
        desc = "Move cursor to left pane",
      },
      {
        "<C-j>",
        function()
          require("herdr-splits").move_cursor_down()
        end,
        desc = "Move cursor to below pane",
      },
      {
        "<C-k>",
        function()
          require("herdr-splits").move_cursor_up()
        end,
        desc = "Move cursor to above pane",
      },
      {
        "<C-l>",
        function()
          require("herdr-splits").move_cursor_right()
        end,
        desc = "Move cursor to right pane",
      },
    },
  },
}
