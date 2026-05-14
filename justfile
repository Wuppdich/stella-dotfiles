[default]
[private]
default:
    @just --list

nix-profiles := "/nix/var/nix/profiles"
nix-current := "/run/current-system/"
nix-build-output := "./result/"
prev-nix-profile := '$(find ' + nix-profiles + ' -type l -name "system-*-link" | sort -rg | sed -n "2 p")'
host := "$(hostname)"

[private]
@sudo:
    sudo true

# compares the current system configuration to the previous system configuration
diff:
    lix diff {{ prev-nix-profile }} {{ nix-current }}

# compares the derivation in the "result" directory to the current system
diff-build:
    lix diff {{ nix-current }} {{ nix-build-output }}

[private]
rebuild VERB="build" TARGET=host: sudo
    #!/usr/bin/env bash
    set -euo pipefail
    sudo nixos-rebuild {{ VERB }} \
    --flake .#{{ TARGET }} \
    --log-format internal-json \
    |& nom --json

# builds the current derivation
@build TARGET=host:
    just rebuild build {{ TARGET }} diff-build

# switches system to the current configuration
@switch TARGET=host:
    just rebuild switch {{ TARGET }} diff

# prints code stats
stats:
    scc \
    --wide \
    --dryness \
    --by-file \
    --sort complexity \
    --avg-wage 84945
