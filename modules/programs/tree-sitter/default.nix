{pkgs, ...}: let
  config = {
    # parser-directories only needed for grammar development, not for installed grammars
    # Grammars from tree-sitter.withPlugins are found automatically via Nix
    theme = {
      attribute = {
        color = 124;
        italic = true;
      };
      comment = {
        color = 245;
        italic = true;
      };
      constant = 94;
      "constant.builtin" = {
        bold = true;
        color = 94;
      };
      constructor = 136;
      embedded = null;
      function = 26;
      "function.builtin" = {
        bold = true;
        color = 26;
      };
      keyword = 56;
      module = 136;
      number = {
        bold = true;
        color = 94;
      };
      operator = {
        bold = true;
        color = 239;
      };
      property = 124;
      "property.builtin" = {
        bold = true;
        color = 124;
      };
      punctuation = 239;
      "punctuation.bracket" = 239;
      "punctuation.delimiter" = 239;
      "punctuation.special" = 239;
      string = 28;
      "string.special" = 30;
      tag = 18;
      type = 23;
      "type.builtin" = {
        bold = true;
        color = 23;
      };
      variable = 252;
      "variable.builtin" = {
        bold = true;
        color = 252;
      };
      "variable.parameter" = {
        color = 252;
        underline = true;
      };
    };
  };
in {
  home.file.".config/tree-sitter/config.json".text = builtins.toJSON config;
  home.packages = with pkgs; [
    tree-sitter
    (tree-sitter.withPlugins (p: [
      # p.tree-sitter-nushell
      p.tree-sitter-rust
      p.tree-sitter-go
      p.tree-sitter-java
      p.tree-sitter-kotlin
      p.tree-sitter-typescript
      p.tree-sitter-javascript
    ]))
  ];
}
