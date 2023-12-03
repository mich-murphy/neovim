return {

  -- neovim plugin for nix
  {
    "LnL7/vim-nix",
    ft = "nix",
  },

  -- add nix treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "nix")
    end,
  },

  -- add lsp extensions to mason
  -- {
  --   "williamboman/mason.nvim",
  --   opts = function(_, opts)
  --     table.insert(opts.ensure_installed, "nil")
  --   end,
  -- },

  -- add diagnostic and formatter options to none-ls
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      table.insert(opts.sources, nls.builtins.formatting.alejandra)
    end,
  },

  -- add diagnostic and formatter options
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["nix"] = { "alejandra" },
      },
    },
  },

  -- add lsp server for nix
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nixd = {},
      },
    },
  },
}
