{ config, pkgs, lib, ... }:
{
  environment = {
    # "DRM kernel driver 'nvidia-drm' in use. NVK requires nouveau."
    sessionVariables.VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
    # fix crackling noises
    etc = {
      "wireplumber/main.lua.d/51-disable-suspension.lua" = {
        text = ''
          table.insert (alsa_monitor.rules, {
            matches = {
              {
                -- Matches all sources.
                { "node.name", "matches", "alsa_input.*" },
              },
              {
                -- Matches all sinks.
                { "node.name", "matches", "alsa_output.*" },
              },
            },
            apply_properties = {
              ["session.suspend-timeout-seconds"] = 300,  -- 0 disables suspend
            },
          })
        '';
        mode = "0554";
      };
    };
  };
}