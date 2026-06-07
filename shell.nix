{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    sops # secrets management
    age # secrets encryption
    ssh-to-age # age key generation. not used

    lix-diff # diffs derivations
    just # command runner
    scc # code stats
    nix-output-monitor # pretty build output
    rich-cli # pretty json ouput

    # (this should be moved into the editor environment)
    just-lsp # just language server
  ];
}

