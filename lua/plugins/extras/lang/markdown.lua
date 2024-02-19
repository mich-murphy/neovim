return {

  -- markdownlint is showing multiple diagnostics
  -- as its running in both none-ls and nvim-lint
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local remove_sources = { "markdownlint" }
      opts.sources = vim.tbl_filter(function(source)
        return not vim.tbl_contains(remove_sources, source.name)
      end, opts.sources)
    end,
  },

  -- disable use of bullets for markdown headings
  {
    "lukas-reineke/headlines.nvim",
    opts = function(_, opts)
      for _, ft in ipairs({ "markdown", "norg", "rmd", "org" }) do
        opts[ft].bullets = false
      end
    end,
  },
}
