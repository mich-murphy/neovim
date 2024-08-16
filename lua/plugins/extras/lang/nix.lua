return {
  recommended = {
    ft = "nix",
    root = "flake.nix",
  },

  -- neovim plugin for nix
  {
    "LnL7/vim-nix",
    ft = "nix",
  },

  -- add nix treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "nix" } },
  },

  -- add diagnostic and formatter options
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        nix = { "alejandra" },
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
