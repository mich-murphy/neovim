# neovim

Personal Neovim configuration, cloned to `~/.config/nvim`.

[nix-config](https://github.com/mich-murphy/nix-config) installs Neovim and its
runtime dependencies; lazy.nvim manages plugins (pinned in `lazy-lock.json`) and
Mason installs editor-only tools.

`exrc` is on, so a trusted `.nvim.lua` in a project adds project-specific
settings, for example nixd's flake options. Run `:trust` to allow one.
