let Reset = ../types/ResetRun.dhall

let record
    : Reset.ResetRun
    = { runId = "C"
      , trigger = Reset.ResetTrigger.warm-reboot
      , acPowerBroken = False
      , managementDisplay = "HDMI-A-2 connected and enabled after reboot"
      , xrDisplay = "DP-2 connected after reboot"
      , remoteState = "LAN SSH returned before Tailscale recovered; Tailscale returned later via DERP"
      , kernelMarkers =
          [ "Failed to setup vendor infoframe on connector HDMI-A-2: -22"
          , "fb0: amdgpudrmfb frame buffer device"
          ]
      , outcome = Reset.RunOutcome.pass
      , evidence =
          [ "docs/research/honey-reset-matrix-2026-04-22.md"
          , "docs/research/honey-management-display-and-recovery-path-2026-04-22.md"
          ]
      , notes = Some "Warm reboot preserved both display paths from a known-good starting state."
      }

in  record
