set shell := ["fish", "-c"]

_default:
    @just --list

nix-profiles := "/nix/var/nix/profiles"
nix-current := "/run/current-system/"
nix-build-output := "./result/"
prev-nix-profile := '$(find ' + nix-profiles + ' -type l -name "system-*-link" | sort -rg | sed -n "2 p")'
nom := "--verbose --json &| nom"
host := "$(hostname)"

@_sudo:
    sudo true

# compares the current system configuration to the previous system configuration
diff:
    lix diff {{ prev-nix-profile }} {{ nix-current }}

# compares the derivation in the "result" directory to the current system
diff-build:
    lix diff {{ nix-current }} {{ nix-build-output }}

_rebuild VERB="build" TARGET=host: _sudo
    sudo nixos-rebuild {{ VERB }} --flake .#{{ TARGET }} {{ nom }}

# builds the current derivation
@build TARGET=host:
    just _rebuild build {{ TARGET }} diff-build

# switches system to the current configuration
@switch TARGET=host:
    just _rebuild switch {{ TARGET }} diff

# prints code stats
stats:
    scc --wide --dryness --by-file --sort complexity --avg-wage 84945
