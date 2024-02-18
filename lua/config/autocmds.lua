-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- create autogroup to trigger autocmds only once
local function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- disable lsp_lines in lazy.vim floating window
vim.api.nvim_create_autocmd("WinEnter", {
  group = augroup("disable_lsp_lines"),
  callback = function()
    local floating = vim.api.nvim_win_get_config(0).relative ~= ""
    vim.diagnostic.config({
      virtual_text = floating,
      virtual_lines = not floating,
    })
  end,
})

-- set Zellij mode
local function zellij(mode)
  if vim.env.ZELLIJ ~= nil then
    vim.fn.system({ "zellij", "action", "switch-mode", mode })
  end
end

-- set Zellij to lock with Neovim is open: refer to help autocmd-events
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("zellij_lock"),
  callback = function()
    zellij("locked")
  end
})

-- set Zellij to normal when Neovim exits
vim.api.nvim_create_autocmd("VimLeave", {
  group = augroup("zellij_normal"),
  callback = function()
    zellij("normal")
  end
})

