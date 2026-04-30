$env.config.plugins.agent = {
  mcp: {
    c5t: {
      transport: "sse"
      url: "http://0.0.0.0:3737/mcp"
    }
    nu: {
      transport: "stdio"
      command: "nu-mcp"
      args: [
        "--add-path"
        "/tmp"
        "--add-path"
        "/nix/store"
      ]
      env: {GIT_PAGER: ""}
    }
  }
  model: "github-copilot/anthropic/claude-sonnet-4.5"
  providers: {
    "ollama": {
      # base_url: "http://192.168.1.73:11434/v1"
      models: {
        "gemma4:31b": {}
        "qwen3.6:27b-coding-mxfp8": {}
      }
    }
    "github-copilot": {
      # ✅ Separate provider entry
      api_key: (open ~/.local/share/opencode/auth.json | get github-copilot.access)
      base_url: "https://api.individual.githubcopilot.com"
      models: {
        "openai/gpt-4o": {}
        "openai/gpt-4o-mini": {}
        "openai/gpt-5.3-codex": {}
        "anthropic/claude-sonnet-4.5": {}
      }
    }
  }
}
