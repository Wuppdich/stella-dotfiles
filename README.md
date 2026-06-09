# Stella's nixfiles

This is my configuration for the machines i run. At the time of writing i'm in the middle of a huge refactor. After merging three machine configs into a nix-flake based setup, it has a lot of repeated code and lacks a great deal of modularization.

## Structure
### machines folder
Specific configs to each host, solving hardware requirements and quirks.

#### Hosts:
- **coulon:** 12-Core AMD, 32GB RAM, 2TB SSD, Nvidia RTX 3080 Watercooled Desktop Workstation. named after a river  
- **pyrit:** heavy, but pretty laptop  
- **lambda04:** laptop collecting dust  
- **netmon-pi:** Raspberry-pi 4, running raspian for pi-hole and a network monitor 
- **rabe:** 4-Core, 8GB RAM, 150GB SSD VPS hosted by contabo  
- **mcserver:** 4-Core, 8GB RAM, 100GB SSH VPS, running Arch. somewhat old and overpriced, hosted by contabo, scheduled for removal  
- **egg:** nixos-anywhere first-stage/bootstrap system

### modules folder
Defining modules, that can be applied to hosts.

## Secrets
Secrets are stored in a private repo and imported as a flake input. the're managed with sops-nix and encrypted with an age-key set up externally.

Development uses "admin-key" in `~/.config/sops/age/keys.txt` on the admin-machine(s).

System activation uses the "machine-key" in `/var/lib/sops-nix/key.txt`.

To use the `sops` command, the admin-key is needed.

To activate a configuration, a machine-key is needed

Keys are generated with `age-keygen -o ~/.config/sops/age/keys.txt` (public keys can be queried with `age-keygen -y ~/.config/sops/age/keys.txt`)  

## SSH
Devices use ssh-keys to access private remote git repos. SSH keys are set with SOPS. (this means a machine needs to be deployed with a developer machine first, otherwise the private repo will be inaccessible).

Set a repo's "deploy keys" to the machines (and maybe admins) public key. this limits their access to this repo

## Private Values
Private values are accessible in private.nix, which is unencrypted, but "hidden" in a private repo.
- [ ] define type for private.nix, to have a public template

## Services
Services are defined as a mixture nixos-native services, managed by systemd and a bunch of podman containers, each running a service, declared with quadled-nix.

### nixos-native:
Nixos and services running on nixos are meant to provide a base system for hosting further Software. Optionally, some services will be elevated to run on the system instead of containers, if the service and nixpkgs/flake declaration is actively maintained and ease of configuration permits it.

### containerized:
Every game server and services considered to be "esoteric" or unmaintained. Also services with special network isolation requirements, like failsafe VPN.

## Settings:
Settings can be added in `options.yourname` and then be found/set/referenced in `config.yourname`.

Within the context of a home-manager module, the `config` attribute contains the home-manager config and the `osConfig` contains the nixos configuration.

### Dataflow:
Settings defined per user that benefit from system changes (like a window manager) should be enabled within the context of a user module (eg home-manager). Within the system context we should check if any user has the option in question enabled (using anyHome by isableroses https://github.com/isabelroses/dotfiles/blob/90b37e47757b0b1298cbf869f8f373f4d25802f2/modules/flake/lib/validators.nix#L27). That way we avoid enforcing certain defaults or carrying around unnescessary packages.


## nixos-anywhere Deployment Process:
1. launch a system with some kind of linux os and internet access.
2. run `ssh-copy-id root@testing.stel.gay`
TIP: run `ssh-keygen -R testing.stel.gay` if the system's fingerprint has changed
2. check if the IP is set via DHCP or staticly.
    - enable DHCP if neccesary and skip step 3.
3. set the mac, ips and password in `default.nix` (typically in the "egg"-machine)
4. run nixos-anywhere with the egg profile
5. generate a sops key with `sudo age-keygen -o /var/lib/sops-nix/key.txt` on the server
6. add the public key to `.sops.yaml`
    - optionally for development/development: generate the key locally an transfer it, otherwise `.sops.yaml` will need to be updated for every redeployment


## TODO:
- [ ] peruse and steal useful settings from isabelroses dotfiles
    - [ ] probably also steal from other nix configs i can find online