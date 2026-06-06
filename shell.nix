{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    lix-diff
    just
    just-lsp
    scc
    sops
    age
    ssh-to-age
    nix-output-monitor
    rich-cli
  ];
}

