set shell := ["fish", "-c"]

default:
    @just --list

nix-profiles := "/nix/var/nix/profiles"
nix-current := "/run/current-system/"
nix-build-output := "./result/"
prev-nix-profile := '$(find ' + nix-profiles + ' -type l -name "system-*-link" | sort -rg | sed -n "2 p")'
nom := "--verbose --json &| nom"

_sudo:
    sudo true

# compares the current system configuration to the previous system configuration
diff:
    lix diff {{ prev-nix-profile }} {{ nix-current }}

# compares the derivation in the "result" directory to the current system
diff-build:
    lix diff {{ nix-current }} {{ nix-build-output }}

_rebuild VERB="build": _sudo
    sudo nixos-rebuild {{ VERB }} --flake {{ nom }}

# builds the current derivation
build:
    just _rebuild build diff-build

# switches system to the current configuration
switch:
    just _rebuild switch diff

# prints code stats
stats:
    scc --wide --dryness --by-file --sort complexity --avg-wage 84945