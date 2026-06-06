{
  lib,
  ...
}:
{
  # home manager config
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.alice =
      { pkgs, ... }:
      {
        wayland.windowManager.hyprland = {
          enable = true;
          package = null;
          portalPackage = null;
          systemd.variables = [ "--all" ];
          configType = "lua";
          extraConfig = builtins.readFile ../../modules/hyprland.lua;
        };
        programs = {
          kitty = {
            enable = true;
          };
          fish = {
            enable = true;
            shellInit = ''
              set fish_greeting
            '';
            # shellInitLast = ''
            #   enable_transience
            # '';
          };
          starship = {
            enable = true;
            enableTransience = true;
            settings = {
              add_newline = false;
              format = lib.concatStrings [
                "$fill$cmd_duration$line_break"
                "[](red)$username" # left side
                "[](fg:red bg:202)$hostname"
                "$localip"
                "$shlvl"
                "$singularity"
                "$kubernetes"
                "$nix_shell"
                "[](fg:202 bg:yellow)$directory[](yellow)"
                "$fill[](fg:black bg:green)" # pad
                "$git_branch"
                "$git_commit"
                "$git_state"
                "$git_metrics"
                "$git_status"
                "[](fg:green bg:blue)" # right side
                "$vcsh"
                "$fossil_branch"
                "$fossil_metrics"
                "$hg_branch"
                "$pijul_channel"
                "$docker_context"
                "$package"
                "$c"
                "$cmake"
                "$cobol"
                "$daml"
                "$dart"
                "$deno"
                "$dotnet"
                "$elixir"
                "$elm"
                "$erlang"
                "$fennel"
                "$gleam"
                "$golang"
                "$guix_shell"
                "$haskell"
                "$haxe"
                "$helm"
                "$java"
                "$julia"
                "$kotlin"
                "$gradle"
                "$lua"
                "$nim"
                "$nodejs"
                "$ocaml"
                "$opa"
                "$perl"
                "$php"
                "$pulumi"
                "$purescript"
                "$python" # color this and group with nix-shell?
                "$quarto"
                "$raku"
                "$rlang"
                "$red"
                "$ruby"
                "$rust"
                "$scala"
                "$solidity"
                "$swift"
                "$terraform"
                "$typst"
                "$vlang"
                "$vagrant"
                "$zig"
                "$buf"
                "$conda"
                "$meson"
                "$spack"
                "$memory_usage"
                "$aws"
                "$gcloud"
                "$openstack"
                "$azure"
                "$nats"
                "$direnv"
                "$env_var"
                "$crystal"
                "$custom"
                "$sudo"
                "[](fg:blue bg:purple)$time[](purple) "
                "$line_break" # new line
                "$jobs"
                "$battery"
                "$status"
                "$os"
                "$container"
                "$shell"
                "$character"
              ];
              username = {
                show_always = true;
                style_root = "bold fg:black bg:red";
                style_user = "bold fg:black bg:red";
                format = "[♥ $user ]($style)";
              };
              hostname = {
                ssh_only = false;
                style = "bold fg:black bg:202";
                format = "[ @$ssh_symbol$hostname ]($style)"; # TODO: this or that for symbol
              };
              nix_shell = {
                style = "bold fg:black bg:202";
                symbol = " ";
                format = "[via $symbol$state( \($name\)) ]($style)";
              };
              directory = {
                style = "bold fg:black bg:yellow";
                read_only_style = "fg:red bg:yellow";
                format = "[  $path]($style)[$read_only]($read_only_style)";
              };
              git_branch = {
                format = "[ $symbol$branch(:$remote_branch) ]($style)";
                style = "bold fg:black bg:bg:green";
              };
              git_commit = {
                format = "[\($hash$tag\) ]($style)";
                style = "bold fg:black bg:bg:green";
              };
              git_state = {
                format = "[\($state( $progress_current/$progress_total)\) ]($style)";
                style = "bold fg:black bg:bg:green";
              };
              git_status = {
                format = "([$all_status$ahead_behind ]($style))"; # FIXME: escaped square brackets are broken
                style = "bold fg:black bg:bg:green";
              };
              time = {
                disabled = false;
                style = "bold fg:black bg:purple";
                time_format = "%R";
                format = "[ 󰥔 $time]($style)";
              };
            };
          };
          dircolors = {
            enable = true;
            settings = {
              OTHER_WRITABLE = "37;42";
              STICKY = "30;44";
            };
          };
        };

        home = {
          shellAliases = {
            ls = "ls --color=auto --hyperlink=auto";
            ll = "ls -lAh --color=auto --hyperlink=auto";
            less = "less --use-color";
          };
          # do not change this without good reason!
          stateVersion = "24.05";
        };

        fonts.fontconfig.enable = true;
      };
    backupFileExtension = "backup";
  };
}
