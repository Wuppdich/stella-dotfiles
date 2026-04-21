{
  ...
}:
{
  # fix crackling noises
  environment.etc."wireplumber/main.lua.d/51-disable-suspension.lua" = {
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
}
