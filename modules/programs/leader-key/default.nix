{...}: let
  config = {
    type = "group";
    actions = [
      {
        key = "a";
        type = "application";
        value = "/Applications/Arc.app";
      }
      {
        key = "g";
        type = "application";
        value = "/Applications/Ghostty.app";
      }
      {
        key = "o";
        type = "group";
        actions = [
          {
            key = "e";
            type = "application";
            value = "/System/Applications/Mail.app";
          }
          {
            key = "m";
            type = "application";
            value = "/System/Applications/Messages.app";
          }
          {
            key = "t";
            type = "application";
            value = "/Applications/Telegram.app";
          }
        ];
      }
    ];
  };
in {
  home.file.".config/leader-key/config.json".text = builtins.toJSON config;
}
