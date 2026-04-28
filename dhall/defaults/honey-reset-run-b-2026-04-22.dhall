let Reset = ../types/ResetRun.dhall

let record
    : Reset.ResetRun
    = { runId = "B"
      , trigger = Reset.ResetTrigger.hard-reset
      , acPowerBroken = True
      , managementDisplay = "HDMI-A-2 connected and enabled; Dell EDID present; 1920x1080 modes present"
      , xrDisplay = "DP-2 connected; 256-byte EDID present; 5088x2544 and 3840x1920 modes present"
      , remoteState = "SSH and Tailscale recovered; host stable enough for normal remote inspection"
      , kernelMarkers =
          [ "Failed to setup vendor infoframe on connector HDMI-A-2: -22"
          , "fb0: amdgpudrmfb frame buffer device"
          ]
      , outcome = Reset.RunOutcome.pass
      , evidence =
          [ "docs/research/honey-reset-matrix-2026-04-22.md"
          , "docs/research/honey-management-display-and-recovery-path-2026-04-22.md"
          ]
      , notes = Some "Hard reset cleared the bad state and restored both display lanes."
      }

in  record
