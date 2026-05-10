local flake = "/home/michael/nixos"
local host = "p0ch1t4"

return {
  recommended = {
    ft = "nix",
    root = { "flake.nix", "default.nix", "shell.nix" },
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
        nixd = {
          settings = {
            nixd = {
              nixpkgs = { expr = "import <nixpkgs> {}" },
              formatting = { command = { "alejandra" } },
              options = {
                nixos = {
                  expr = string.format(
                    '(builtins.getFlake "%s").nixosConfigurations.%s.options',
                    flake,
                    host
                  ),
                },
                home_manager = {
                  expr = string.format(
                    '(builtins.getFlake "%s").nixosConfigurations.%s.options.home-manager.users.type.getSubOptions []',
                    flake,
                    host
                  ),
                },
              },
            },
          },
        },
      },
    },
  },
}
