{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    lix-diff
    just
    just-lsp
    scc
    nix-output-monitor
  ];
}

