$env.config.plugins.agent = {
  model: "github-copilot/claude-opus-4.7"
  permissions: {
    "*": "ask"
    "read": "allow"
    "nu__run": {
      "command": {
        "echo \"bar\"": allow
        "echo \"foo\"": deny
      }
    }
  }
  providers: {
    "ollama": {
      models: {
        "gemma4:26b-mlx": {
          limit: {
            context: 262144
            output: 8192
          }
        }
        "gemma4:31b-mlx": {
          limit: {
            context: 262144
            output: 8192
          }
        }
        "qwen3.6:27b-mlx": {
          limit: {
            context: 262144
            output: 8192
          }
        }
        "qwen3.6:35b-mlx": {
          limit: {
            context: 262144
            output: 8192
          }
        }
      }
    }
    "ollama-remote": {
      provider: "ollama"
      base_url: "http://192.168.1.73:11434"
      models: {
        "gemma4:26b-mlx": {
          limit: {
            context: 262144
            output: 8192
          }
        }
        "gemma4:31b-mlx": {
          limit: {
            context: 262144
            output: 8192
          }
        }
        "qwen3.6:27b-mlx": {
          limit: {
            context: 262144
            output: 8192
          }
        }
        "qwen3.6:35b-mlx": {
          limit: {
            context: 262144
            output: 8192
          }
        }
      }
    }
    "github-copilot": {
      # ✅ Separate provider entry
      # api_key: (open ~/.local/share/opencode/auth.json | get github-copilot.access)
      # base_url: "https://api.individual.githubcopilot.com"
      # base_url: "https://api.githubcopilot.com"
      models: {
        "gpt-5.3-codex": {
          limit: {
            context: 250000
            output: 8192
          }
        }
        "claude-sonnet-4.6": {
          limit: {
            context: 168000
            output: 8192
          }
        }
        "claude-opus-4.5": {
          limit: {
            context: 168000
            output: 8192
          }
        }
        "claude-opus-4.6": {
          limit: {
            context: 168000
            output: 8192
          }
        }
      }
    }
  }
  mcp: {
    c5t: {
      transport: "sse"
      url: "http://0.0.0.0:3737/mcp"
    }
    nu: {
      transport: "stdio"
      command: "NU_MCP_PATH" # Will be replaced with full store path by Nix
      args: [
        "--add-path"
        "/tmp"
        "--add-path"
        "/nix/store"
      ]
      env: {GIT_PAGER: ""}
    }
    tmux: {
      enabled: false
      transport: "stdio"
      command: "NU_MCP_PATH"
      args: [
        "--tools-dir"
        "NU_MCP_TOOLS_PATH/tmux"
      ]
    }
    gh: {
      enabled: false
      transport: "stdio"
      command: "NU_MCP_PATH"
      args: [
        "--tools-dir"
        # "/Users/christian/Projects/ck3mp3r/nu-mcp/tools/gh"
        "NU_MCP_TOOLS_PATH/gh"
      ]
    }
    context7: {
      transport: "stdio"
      command: "NU_MCP_PATH"
      args: [
        "--tools-dir"
        "NU_MCP_TOOLS_PATH/c67"
      ]
    }
  }
}

# Start an agent with optional session name and agent type
export def dave [
  --agent (-a): string = "orchestrator" # Agent type to use (default: orchestrator)
  --session (-s): string # Session name (default: current directory name)
] {
  let session_name = if ($session | is-empty) {
    $env.PWD | path basename
  } else {
    $session
  }

  agent --name dave --agent $agent --session $session_name
}
