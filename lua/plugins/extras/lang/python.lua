return {

  -- add lsp extensions to mason
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "ruff",
          "ruff-lsp",
        })
      end
    end,
  },

  -- add diagnostic and formatter options to null-ls
  -- {
  --   "nvimtools/none-ls.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     local nls = require("null-ls")
  --     opts.sources = vim.list_extend(opts.sources or {}, {
  --       nls.builtins.formatting.ruff,
  --       nls.builtins.diagnostics.ruff.with({
  --         extra_args = {
  --           "--line-length",
  --           "88",
  --         },
  --       }),
  --     })
  --   end,
  -- },

  -- configure formattters for conform
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["python"] = { "ruff_fmt" },
      },
    },
  },

  -- configure linters for nvim-lint
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        ["python"] = { "ruff" },
      },
      linters = {
        ruff = {
          args = { "--line-length", "88" },
        },
      },
    },
  },
}
