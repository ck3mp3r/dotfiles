{
  pkgs,
  system,
  ...
}: let
  data = builtins.fromJSON (builtins.readFile ./data/${system}.json);
  aichat = pkgs.callPackage ../../../util/github-release.nix {
    inherit pkgs data;
    name = "aichat";
    version = "v0.29.0";
  };
  # modelVersion = "deepseek-r1:8b";
  # modelVersion = "gemma3:12b";
  # modelVersion = "llama3.1:8b";
  modelVersion = "qwen3:4b";
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
      - type: "openai-compatible"
        name: "copilot"
        api_base: "https://api.githubcopilot.com"
        models:
          - name: "copilot:claude-sonnet-4"
            type: "chat"
            max_input_tokens: 200000
            max_output_tokens: 8192
          - name: "copilot:claude-3-5-sonnet-20241022"
            type: "chat"
            max_input_tokens: 200000
            max_output_tokens: 8192
          - name: "copilot:gpt-4o"
            type: "chat"
            max_input_tokens: 128000
            max_output_tokens: 16384
    save_session: true
    function_calling: true
    stream: true
  '';

  home.activation = {
    ollama-pull = ''
      echo "Pulling model ollama:${modelVersion} using Ollama..."
      ${pkgs.ollama}/bin/ollama pull "${modelVersion}"
    '';
  };

  home.packages = [aichat];
}
