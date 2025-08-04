$env.config = ($env.config? | default {})
$env.config.hooks = ($env.config.hooks? | default {})
$env.config.hooks.pre_prompt = (
  $env.config.hooks.pre_prompt?
  | default []
  | append {||
    direnv export json
    | from json --strict
    | default {}
    | items {|key value|
      let value = do (
        {
          "PATH": {
            from_string: {|s| $s | split row (char esep) | path expand --no-symlink }
            to_string: {|v| $v | path expand --no-symlink | str join (char esep) }
          }
        }
        | merge ($env.ENV_CONVERSIONS? | default {})
        | get -o ([[value optional insensitive]; [$key false true]] | into cell-path)
        | get -o from_string
        | if ($in | is-empty) { {|x| $x } } else { $in }
      ) $value
      return [$key $value]
    }
    | into record
    | load-env
  }
)
