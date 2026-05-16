[default]
[private]
default:
    @just --list

NIX_CURRENT := "/run/current-system/"
HOST := "$(hostname)"
LATEST-COMMIT-HASH := "$(git rev-parse --short HEAD)"
GIT-CLONE-PATH := "/tmp/just-build-output/commit-" + LATEST-COMMIT-HASH


[private]
path PATH TARGET:
    nix path-info --derivation \
        {{ PATH }}#nixosConfigurations.{{ TARGET }}.config.system.build.toplevel

[private]
git-clone-to-tmp:
    #!/usr/bin/env bash
    set -euo pipefail
    if [ ! -d {{ GIT-CLONE-PATH }} ]; then
        git clone ./ {{ GIT-CLONE-PATH }}
    fi

# compares derivation of the latest commit to derivation of current worktree
diff TARGET=HOST: git-clone-to-tmp
    lix diff \
        $(just path {{ GIT-CLONE-PATH }} {{ TARGET }}) \
        $(just path . {{ TARGET }})

# compares current system to derivation of current worktree
diff-system TARGET=HOST:
    lix diff \
        $(nix path-info --derivation {{ NIX_CURRENT }}) \
        $(just path . {{ TARGET }})

# errors, if the given target is not the host system
[private]
check_host TARGET:
    [ {{ TARGET }} = {{ HOST }} ]

build TARGET=HOST:
    just rebuild build {{ TARGET }}

switch TARGET=HOST: (check_host TARGET)
    sudo just rebuild switch {{ TARGET }}

test TARGET=HOST: (check_host TARGET)
    sudo just rebuild test {{ TARGET }}

[private]
rebuild VERB TARGET:
    #!/usr/bin/env bash
    set -euo pipefail
    nixos-rebuild {{ VERB }} \
        --flake .#{{ TARGET }} \
        --log-format internal-json \
        |& nom --json

# prints code stats
stats:
    scc \
        --wide \
        --dryness \
        --by-file \
        --sort complexity \
        --avg-wage 84945
