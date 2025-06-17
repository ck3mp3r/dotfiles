{...}: {
  programs.mods = {
    enable = true;
    settings = {
      default-model = "claude-3.7-sonnet";
      apis = {
        copilot = {
          base-url = "https://api.githubcopilot.com";
          models = {
            "gpt-4o" = {
              aliased = ["4"];
              "max-input-chars" = 64000;
            };
            "claude-3.7-sonnet" = {
              aliases = ["claude3.7-sonnet" "sonnet-3.7" "claude-3-7-sonnet"];
              "max-input-chars" = 680000;
            };
            "claude-sonnet-4" = {
              aliases = ["sonnet-4" "claude-4-sonnet"];
              "max-input-chars" = 680000;
            };
          };
        };
      };
    };
  };
}
