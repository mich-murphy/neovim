-- On NixOS, Mason's pre-built binaries often fail to execute because they
-- aren't patched for the Nix store. Install these tools via Nix (see
-- ~/nixos/modules/home/neovim.nix) and tell Mason to skip them.

local skip = {
  ["codelldb"] = true,
  ["tflint"] = true,
  ["stylua"] = true,
  ["markdown-toc"] = true,
  ["markdownlint-cli2"] = true,
  ["delve"] = true,
  ["goimports"] = true,
  ["gofumpt"] = true,
  ["prettier"] = true,
}

return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_filter(function(tool)
        return not skip[tool]
      end, opts.ensure_installed or {})
    end,
  },
  -- Point the codelldb DAP adapter at the Nix-provided binary instead of
  -- the Mason install path that LazyVim configures by default.
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.exepath("codelldb"),
          args = { "--port", "${port}" },
        },
      }
    end,
  },
}
