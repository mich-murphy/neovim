{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.common.tmux;
in
{
  options.common.tmux = {
    enable = mkEnableOption "Enable Tmux with personalised settings";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      disableConfirmationPrompt = true;
      escapeTime = 0;
      historyLimit = 10000;
      keyMode = "vi";
      newSession = false;
      prefix = "C-a";
      terminal = "screen-256color";
      tmuxp.enable = true;
      plugins = with pkgs; [
        tmuxPlugins.tmux-fzf
        tmuxPlugins.vim-tmux-navigator
        {
          plugin = tmuxPlugins.catppuccin;
          extraConfig = ''
            set -g @catppuccin_flavor 'mocha'
            set -g @catppuccin_status_left_separator "█"
            set -g @catppuccin_window_default_text "#W"
            set -g @catppuccin_window_current_text "#W"
            set -g @catppuccin_status_modules_right "directory host session"
          '';
        }
      ];
      extraConfig = ''
        # Additional terminal color settings
        set-option -ga terminal-overrides ",xterm-256color:Tc"

        # Vim settings
        set-option -g focus-events on

        # Easier split pane bindings
        bind - split-window -v -c "#{pane_current_path}"
        bind | split-window -h -c "#{pane_current_path}"

        # Vim keybindings
        unbind -T copy-mode-vi Space;
        unbind -T copy-mode-vi Enter;
        bind -T copy-mode-vi v send-keys -X begin-selection
        bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xsel --clipboard" 

        # Allow mouse scrolling
        set -g mouse on

        # Status bar at top
        set-option -g status-position top
      '';
    };
  };
}
