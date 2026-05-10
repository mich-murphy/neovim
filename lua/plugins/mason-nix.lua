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
  ["ruff"] = true,
  ["marksman"] = true,
}

-- LSP servers (lspconfig name -> binary on PATH) that we want to launch
-- from Nix rather than Mason's bin dir. Mason prepends its bin to vim.env.PATH
-- at setup time, so a stale Mason install would otherwise shadow the Nix copy.
local nix_lsp_cmd = {
  marksman = { "marksman", "server" },
  ruff = { "ruff", "server" },
}

-- Resolve a binary on PATH, skipping Mason's bin directory.
local function exepath_skip_mason(name)
  local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
  local saved = vim.env.PATH or ""
  local parts = vim.split(saved, ":", { plain = true })
  local filtered = vim.tbl_filter(function(p)
    return p ~= "" and p ~= mason_bin
  end, parts)
  vim.env.PATH = table.concat(filtered, ":")
  local result = vim.fn.exepath(name)
  vim.env.PATH = saved
  return result ~= "" and result or name
end

return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_filter(function(tool)
        return not skip[tool]
      end, opts.ensure_installed or {})
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_filter(function(server)
        return not skip[server]
      end, opts.ensure_installed or {})
    end,
  },
  -- Stop LazyVim from queueing these servers in mason-lspconfig's
  -- install list, and pin cmd to the Nix binary so a stale Mason install
  -- (or Mason's PATH prepend) can't shadow it.
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      for server, cmd in pairs(nix_lsp_cmd) do
        local resolved = exepath_skip_mason(cmd[1])
        local override = { mason = false, cmd = { resolved, unpack(cmd, 2) } }
        opts.servers[server] = vim.tbl_deep_extend("force", opts.servers[server] or {}, override)
      end
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
