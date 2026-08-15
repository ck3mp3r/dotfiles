{pkgs, ...}: let
  grammars = with pkgs.tree-sitter-grammars; [
    tree-sitter-go
    tree-sitter-java
    tree-sitter-javascript
    tree-sitter-kotlin
    tree-sitter-nix
    tree-sitter-rust
    tree-sitter-typescript
  ];

  # Pre-compile all grammar parsers (including sub-grammars like tsx/flow)
  # and link them into the tree-sitter CLI cache directory so they are
  # available immediately without on-first-use compilation.
  #
  # The tree-sitter CLI looks for compiled parsers at:
  #   $XDG_CACHE_HOME/tree-sitter/lib/<lang>.<dylib-so-ext>
  #
  # The nixpkgs grammar packages ship a pre-compiled "parser" shared
  # library for their primary language, but multi-language grammars (e.g.
  # tree-sitter-typescript which exports typescript, tsx, and flow) only
  # have one compiled parser. This derivation compiles ALL sub-grammars from
  # source so every language is available pre-compiled.
  compileGrammars = pkgs.runCommand "tree-sitter-compiled-grammars" {
    nativeBuildInputs = with pkgs; [gcc jq];
  } ''
    mkdir -p $out/lib
    ${pkgs.lib.concatMapStrings (g: let
      src = g.src;
      libExt = pkgs.stdenv.hostPlatform.extensions.sharedLibrary;
    in ''
      echo "Processing ${g.pname or g.name}..."
      if [[ -f ${src}/tree-sitter.json ]]; then
        # Multi-language grammar: compile each sub-grammar
        lang_paths=$(jq -r '.grammars[] | "\(.name)\t\(.path // ".")"' ${src}/tree-sitter.json)
        while IFS=$'\t' read -r lang path; do
          echo "  Compiling $lang from $path"
          grammar_dir="${src}/$path"
          if [[ -f "$grammar_dir/src/parser.c" ]]; then
            objs=""
            if [[ -f "$grammar_dir/src/scanner.c" ]]; then
              $CC -fPIC -c -I"$grammar_dir/src" "$grammar_dir/src/scanner.c" -o scanner.o
              objs="scanner.o"
            elif [[ -f "$grammar_dir/src/scanner.cc" ]]; then
              $CXX -fPIC -c -I"$grammar_dir/src" "$grammar_dir/src/scanner.cc" -o scanner.o
              objs="scanner.o"
            fi
            $CC -fPIC -c -I"$grammar_dir/src" "$grammar_dir/src/parser.c" -o parser.o
            $CXX -shared -o "$out/lib/$lang${libExt}" parser.o $objs
          fi
        done <<< "$lang_paths"
      elif [[ -f ${src}/src/parser.c ]]; then
        # Single-language grammar without tree-sitter.json
        lang="${g.pname or g.name}"
        lang="''${lang#tree-sitter-}"
        echo "  Compiling $lang"
        objs=""
        if [[ -f "${src}/src/scanner.c" ]]; then
          $CC -fPIC -c -I"${src}/src" "${src}/src/scanner.c" -o scanner.o
          objs="scanner.o"
        elif [[ -f "${src}/src/scanner.cc" ]]; then
          $CXX -fPIC -c -I"${src}/src" "${src}/src/scanner.cc" -o scanner.o
          objs="scanner.o"
        fi
        $CC -fPIC -c -I"${src}/src" "${src}/src/parser.c" -o parser.o
        $CXX -shared -o "$out/lib/$lang${libExt}" parser.o $objs
      fi
    '') grammars}
  '';

  # tree-sitter CLI needs parser-directories pointing at grammar sources for
  # query files (highlights.scm, etc.) and language discovery.
  grammarDir = pkgs.linkFarm "tree-sitter-grammars" (map (g: {
      name = g.pname or g.name;
      path = g.src;
    })
    grammars);
  config = {
    parser-directories = [
      "${grammarDir}"
    ];
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
  # Pre-compiled parser shared libraries for the tree-sitter CLI cache.
  # These are linked into $XDG_CACHE_HOME/tree-sitter/lib/ so the CLI
  # finds them without needing to compile from source on first use.
  home.file.".cache/tree-sitter/lib" = {
    source = "${compileGrammars}/lib";
    recursive = true;
  };
  home.file.".config/tree-sitter/config.json".text = builtins.toJSON config;
  home.packages = with pkgs; [
    tree-sitter
  ];
}
