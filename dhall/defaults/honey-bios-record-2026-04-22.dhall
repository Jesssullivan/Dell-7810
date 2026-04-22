let Bios = ../types/BiosRecord.dhall

let record
    : Bios.BiosRecord
    = { date = "2026-04-22"
      , ownerIssue = Some "TIN-397"
      , host = "honey"
      , operator = Some "Jess Sullivan"
      , biosVersion = Some "A34"
      , biosDate = Some "10/19/2020"
      , settings =
          [ { name = "usblegacy"
            , expected = "disabled"
            , observed = Some "usbemu=enable"
            , source = Some Bios.SettingSource.cctk
            , matchState = Bios.MatchState.mismatched
            , notes = Some "Legacy Dell Command | Configure 3.0 exposes the USB legacy posture through usbemu rather than the newer usblegacy field."
            }
          , { name = "cstates"
            , expected = "c1 (legacy DCC surface approximates with cstatesctrl=disable)"
            , observed = Some "cstatesctrl=disable"
            , source = Some Bios.SettingSource.cctk
            , matchState = Bios.MatchState.matches
            , notes = Some "Legacy DCC 3.0 only exposes cstatesctrl=enable|disable; disable is the closest machine-readable low-latency posture to the newer C1-only target."
            }
          , { name = "intelturboboosten"
            , expected = "disabled"
            , observed = Some "turbomode=disable"
            , source = Some Bios.SettingSource.cctk
            , matchState = Bios.MatchState.matches
            , notes = Some "Legacy DCC 3.0 export uses turbomode for the same BIOS control."
            }
          , { name = "intelspdstep"
            , expected = "disabled"
            , observed = Some "speedstep=disable"
            , source = Some Bios.SettingSource.cctk
            , matchState = Bios.MatchState.matches
            , notes = Some "Legacy DCC 3.0 export uses speedstep for the same BIOS control."
            }
          , { name = "hpet"
            , expected = "enabled"
            , observed = None Text
            , source = Some Bios.SettingSource.cctk
            , matchState = Bios.MatchState.unknown
            , notes = Some "Legacy DCC 3.0 export did not expose an hpet field on this host; verify manually in firmware setup if needed."
            }
          , { name = "computrace"
            , expected = "deactivate"
            , observed = None Text
            , source = Some Bios.SettingSource.cctk
            , matchState = Bios.MatchState.unknown
            , notes = Some "Legacy DCC 3.0 export did not expose a computrace field on this host; verify manually in firmware setup if needed."
            }
          ]
      , fullCheckOutputRef = Some "data/captures/honey/bios-check-2026-04-22.txt"
      , manualNotes =
          [ "Live probe confirmed BIOS version A34 and BIOS date 10/19/2020."
          , "Legacy Dell Command | Configure 3.0.0-509 plus srvadmin-hapi 7.4.0 were staged from Dell's Precision Tower 7810 driver payload and installed successfully on Rocky Linux 10.1."
          , "Raw export is captured in data/captures/honey/bios-export-2026-04-22.cctk."
          , "The active tuned profile remains throughput-performance, and the live boot cmdline still lacks the intended low-latency arguments, so the host should not yet be treated as a validated low-latency baseline."
          ]
      , matchesLowLatencyTarget = Some False
      , rebootPending = Some False
      , unlocksNextValidation = Some True
      , followUp =
          [ "Decide whether to apply the legacy DCC low-latency posture, starting with usbemu=disable."
          , "Capture manual BIOS observations for hpet and computrace if those fields remain invisible through legacy DCC."
          , "Only promote the host to a low-latency validated baseline after BIOS settings, tuned profile, and host cmdline posture are all re-checked."
          ]
      }

in  record
