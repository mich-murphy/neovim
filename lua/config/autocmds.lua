-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- disable lsp_lines in lazy.vim
vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    local floating = vim.api.nvim_win_get_config(0).relative ~= ""
    vim.diagnostic.config({
      virtual_text = floating,
      virtual_lines = not floating,
    })
  end,
})

-- set Zellij to lock with Neovim is open: refer to help autocmd-events
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if vim.env.ZELLIJ ~= nil then
      vim.fn.system({ "zellij", "action", "switch-mode", "locked" })
    end
  end,
})

-- set Zellij to normal when Neovim exits
vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    if vim.env.ZELLIJ ~= nil then
      vim.fn.system({ "zellij", "action", "switch-mode", "normal" })
    end
  end,
})

