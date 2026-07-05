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
    thaura: {
      name: "Thaura AI"
      provider: "openai"
      api_key: (^security find-generic-password -s "THAURA_KEY" -w | str trim)
      base_url: "https://backend.thaura.ai/v1"
      models: {
        thaura: {
          name : "Thaura"
          limit: {
            context: 256000
            output: 8192
          }
        }
      }
    }
    ollama: {
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
        "ornith:35b": {
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
        "ornith:35b": {
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
          additional_params: {
            thinking: {type: "disabled"}
          }
          limit: {
            context: 168000
            output: 8192
          }
        }
        "claude-opus-4.5": {
          additional_params: {
            thinking: {type: "disabled"}
          }
          limit: {
            context: 168000
            output: 8192
          }
        }
        "claude-opus-4.6": {
          additional_params: {
            thinking: {type: "disabled"}
          }
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
    c5t_dev: {
      enabled: false
      transport: "sse"
      url: "http://0.0.0.0:3738/mcp"
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
      transport: "sse"
      url: "https://mcp.context7.com/mcp"
    }
  }
}

# Start an agent with optional session name and agent type
export def dave [
  --agent (-a): string = "orchestrator" # Agent type to use (default: orchestrator)
  --session (-s): string # Session name (optional)
] {
  if ($session | is-empty) {
    agent --name dave --agent $agent
  } else {
    agent --name dave --agent $agent --session $session
  }
}
