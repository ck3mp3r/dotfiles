{
  pkgs,
  system,
  ...
}: let
  data = builtins.fromJSON (builtins.readFile ./data/${system}.json);
  aichat = pkgs.callPackage ../../../util/github-release.nix {
    inherit pkgs data;
    name = "aichat";
    version = "v0.26.0";
  };
  modelVersion = "deepseek-r1:8b";
in {
  home.file.".config/aichat/config.yaml".text = ''
    model: "ollama:${modelVersion}"
    clients:
      - type: "openai-compatible"
        name: "ollama"
        api_base: "http://localhost:11434/v1"
        api_key: null
        models:
          - name: "ollama:${modelVersion}"
  '';

  home.activation = {
    ollama-pull = ''
      echo "Pulling model ollama:${modelVersion} using Ollama..."
      ${pkgs.ollama}/bin/ollama pull "${modelVersion}"
    '';
  };

  home.packages = [aichat];
}
