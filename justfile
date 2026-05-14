[default]
[private]
default:
    @just --list

NIX_CURRENT := "/run/current-system/"
HOST := "$(hostname)"
LATEST-COMMIT-HASH := "$(git rev-parse --short HEAD)"
GIT-CLONE-PATH := "/tmp/just-build-output/commit-" + LATEST-COMMIT-HASH

[private]
@sudo:
    sudo true

[private]
path PATH TARGET:
    #!/usr/bin/env bash
    set -euo pipefail
    nix path-info --derivation \
        {{ PATH }}#nixosConfigurations.{{ TARGET }}.config.system.build.toplevel

# compares derivation of the latest commit to derivation of current worktree
diff TARGET=HOST:
    #!/usr/bin/env bash
    set -euo pipefail
    if [ ! -d {{ GIT-CLONE-PATH }} ]; then
        git clone ./ {{ GIT-CLONE-PATH }}
    fi
    lix diff \
        $(just path {{ GIT-CLONE-PATH }} {{ TARGET }}) \
        $(just path . {{ TARGET }})

# compares current system to derivation of current worktree
diff-system TARGET=HOST:
    #!/usr/bin/env bash
    set -euo pipefail
    lix diff \
        $(nix path-info --derivation {{ NIX_CURRENT }}) \
        $(just path . {{ TARGET }})

[private]
rebuild VERB="build" TARGET=HOST: sudo
    #!/usr/bin/env bash
    set -euo pipefail
    sudo nixos-rebuild {{ VERB }} \
        --flake .#{{ TARGET }} \
        --log-format internal-json \
        |& nom --json

# builds the current derivation
@build TARGET=HOST:
    just rebuild build {{ TARGET }}

# switches system to the current configuration
@switch TARGET=HOST:
    just rebuild switch {{ TARGET }}

# prints code stats
stats:
    scc \
        --wide \
        --dryness \
        --by-file \
        --sort complexity \
        --avg-wage 84945
