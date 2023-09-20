{ lib, config, ... }:

with lib;

let
  cfg = config.common.yazi;
in
{
  options.common.lf = {
    enable = mkEnableOption "Enable Yazi with personalised settings";
  };

  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      # keymap = {}
      settings = {
        log = {
          enabled = false;
        };
        manager = {
          show_hidden = false;
          sort_by = "modified";
          sort_dir_first = true;
        };
      };
    };
  };
}
