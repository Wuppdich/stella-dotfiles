{ inputs, ... }: {
  _module.args = {
    values = import "${builtins.toString inputs.secrets}/private.nix";
  };
}
