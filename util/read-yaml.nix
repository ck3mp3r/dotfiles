{
  runCommand,
  yq,
}: path: let
  jsonOutput =
    runCommand "from-yaml" {nativeBuildInputs = [yq];}
    ''yq . "${path}" > "$out"'';
in
  builtins.fromJSON (builtins.readFile jsonOutput)
