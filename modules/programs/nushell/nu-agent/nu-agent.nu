$env.config.plugins.agent = {
  models: {
    default: {
      model: "ollama-cloud/deepseek-v4-flash"
      max_retries: 6
      max_context_tokens: 1000000
    }
    heavy: {
      model: "ollama-cloud/glm-5.2"
    }
    light: {
      model: "ollama-cloud/gemma4:31b"
    }
  }
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
    opencode: {
      provider: "openai"
      base_url: "https://opencode.ai/zen/v1"
      api_key: (^security find-generic-password -s "OPENCODE_GO_KEY" -w | str trim)
      models: {
        "deepseek-v4-flash": {
          limit: {
            context: 1000000
            output: 384000
          }
        }
        "deepseek-v4-pro": {
          limit: {
            context: 1000000
            output: 384000
          }
        }
        "glm-5.2": {
          limit: {
            context: 1000000
            output: 384000
          }
        }
      }
    }
    mistral: {
      name: "Mistral AI"
      provider: "openai"
      api_key: (^security find-generic-password -s "mistral-ai-api-key" -w | str trim)
      base_url: "https://api.mistral.ai/v1"
      models: {
        "mistral-medium-3-5": {
          name: "mistral-medium-3-5"
          limit: {
            context: 256000
            output: 8192
          }
        }
        "codestral-2508": {
          name: "codestral-2508"
          limit: {
            context: 128000
            output: 8192
          }
        }
      }
    }
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
    "ollama-cloud": {
      provider: "openai"
      base_url: "https://ollama.com/v1"
      api_key: (^security find-generic-password -s "OLLAMA_CLOUD_KEY" -w | str trim)
      models: {
        "kimi-k2.7-code": {
          name: "kimi-k2.7-code"
          tool_call: true
          limit: {
            context: 262144
            output: 8192
          }
        }
        "glm-5.2": {
          name: "glm-5.2"
          tool_call: true
          limit: {
            context: 1000000
            output: 384000
          }
        }
        "gemma4:26b": {
          name: "gemma4:26b"
          tool_call: true
          limit: {
            context: 262144
            output: 8192
          }
        }
        "gemma4:31b": {
          name: "gemma4:31b"
          tool_call: true
          limit: {
            context: 262144
            output: 8192
          }
        }
        "qwen3.5:cloud": {
          name: "qwen3.5:cloud"
          tool_call: true
          limit: {
            context: 256000
            output: 8192
          }
        }
        "qwen3.5:397b-cloud": {
          name: "qwen3.5:397b-cloud"
          tool_call: true
          limit: {
            context: 256000
            output: 8192
          }
        }
        "deepseek-v4-flash": {
          name: "deepseek-v4-flash"
          tool_call: true
          limit: {
            context: 1000000
            output: 8192
          }
        }
        "deepseek-v4-pro": {
          name: "deepseek-v4-pro"
          tool_call: true
          limit: {
            context: 1000000
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
            output_config: {effort: "medium"}
          }
          limit: {
            context: 168000
            output: 8192
          }
        }
        "claude-opus-4.6": {
          additional_params: {
            output_config: {effort: "medium"}
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
      url: "http://127.0.0.1:3737/mcp"
    }
    c5t_dev: {
      enabled: false
      transport: "sse"
      url: "http://127.0.0.1:3738/mcp"
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
      url: "https://mcp.context7.com/mcp/oauth"
      auth: {
        type: "oauth"
      }
    }
  }
}

# Start an agent with optional session name, agent type, and model
export def dave [
  --agent (-a): string = "orchestrator" # Agent type to use (default: orchestrator)
  --name (-n): string = "dave" # Agent name
  --session (-s): string # Session name (optional)
  --model (-m): string # Model override (optional, e.g. 'openai/gpt-4o')
] {
  let has_session = not ($session | is-empty)
  let has_model = not ($model | is-empty)

  match [$has_session $has_model] {
    [true true] => { agent --name $name --agent $agent --a2a-port 0 --session $session --model $model }
    [true false] => { agent --name $name --agent $agent --a2a-port 0 --session $session }
    [false true] => { agent --name $name --agent $agent --a2a-port 0 --model $model }
    _ => { agent --name $name --agent $agent --a2a-port 0 }
  }
}
