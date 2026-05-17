[default]
[private]
default:
    @just --list

NIX_CURRENT_SYSTEM := "/run/current-system/"
HOST := "$(hostname)"
LATEST_COMMIT_HASH := "$(git rev-parse --short HEAD)"
LATEST_COMMIT_FOLDER := "commit-" + LATEST_COMMIT_HASH
TMP_DIR := "/tmp/just-nix/"
GIT_CLONE_PATH := TMP_DIR + LATEST_COMMIT_FOLDER


[private]
path PATH TARGET:
    nix path-info --derivation \
        {{ PATH }}#nixosConfigurations.{{ TARGET }}.config.system.build.toplevel

[private]
git-clone-to-tmp:
    #!/usr/bin/env bash
    set -euo pipefail
    if [ ! -d {{ GIT_CLONE_PATH }} ]; then
        git clone ./ {{ GIT_CLONE_PATH }}
    fi

# compares derivation of the latest commit to derivation of current worktree
diff TARGET=HOST: git-clone-to-tmp
    #!/usr/bin/env bash
    set -euo pipefail
    current=$(just path {{ GIT_CLONE_PATH }} {{ TARGET }})
    prev=$(just path . {{ TARGET }})
    lix diff $current $last

# compares current system to derivation of current worktree
diff-system TARGET=HOST:
    #!/usr/bin/env bash
    set -euo pipefail
    current=$(nix path-info --derivation {{ NIX_CURRENT_SYSTEM }})
    prev=$(just path . {{ TARGET }})
    lix diff $current $last

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
rebuild VERB TARGET FLAKE_PATH=".":
    #!/usr/bin/env bash
    set -euo pipefail
    nixos-rebuild {{ VERB }} \
        --flake {{ FLAKE_PATH }}#{{ TARGET }} \
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
