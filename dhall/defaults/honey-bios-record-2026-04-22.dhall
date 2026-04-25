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
            , observed = Some "usbemu=disable"
            , source = Some Bios.SettingSource.cctk
            , matchState = Bios.MatchState.matches
            , notes = Some "Legacy Dell Command | Configure 3.0 exposes the USB legacy posture through usbemu rather than the newer usblegacy field. This value was changed remotely on April 22, 2026, persisted across reboot, and did not produce an observed reduction in the bounded 10-second SMI sample."
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
      , fullCheckOutputRef = Some "data/captures/honey/bios-check-post-reboot-usbemu-disable-2026-04-22.txt"
      , manualNotes =
          [ "Live probe confirmed BIOS version A34 and BIOS date 10/19/2020."
          , "Legacy Dell Command | Configure 3.0.0-509 plus srvadmin-hapi 7.4.0 were staged from Dell's Precision Tower 7810 driver payload and installed successfully on Rocky Linux 10.1."
          , "Pre-change raw export is captured in data/captures/honey/bios-export-2026-04-22.cctk."
          , "Post-change raw export is captured in data/captures/honey/bios-export-post-usbemu-disable-2026-04-22.cctk."
          , "Reboot confirmation is captured in data/captures/honey/reboot-confirmation-post-usbemu-disable-2026-04-22.txt."
          , "Post-reboot raw export is captured in data/captures/honey/bios-export-post-reboot-usbemu-disable-2026-04-22.cctk."
          , "A post-change pre-reboot SMI sample is captured in data/captures/honey/smi-validate-post-usbemu-disable-pre-reboot-2026-04-22.txt and reported 16 SMIs in 10s."
          , "A post-reboot SMI sample is captured in data/captures/honey/smi-validate-post-reboot-usbemu-disable-2026-04-22.txt and also reported 16 SMIs in 10s, so this BIOS change alone did not produce an observed improvement in bounded SMI behavior."
          , "After the repo-owned tuned activation and reboot, the active tuned profile became t7810-low-latency and the live boot cmdline matched the full Dell low-latency token set."
          , "The post-tuned reboot kernel baseline result is captured in data/captures/honey/kernel-baseline-post-tuned-reboot-2026-04-22.txt and passed 30/30 config checks plus 19/19 cmdline checks."
          , "The post-tuned reboot SMI sample is captured in data/captures/honey/smi-validate-post-tuned-reboot-2026-04-22.txt and still reported 16 SMIs in 10s, but the tracefs hwlat fallback reported 0 us max latency."
          ]
      , matchesLowLatencyTarget = Some False
      , rebootPending = Some False
      , unlocksNextValidation = Some True
      , followUp =
          [ "Investigate other BIOS-managed and platform-managed SMI sources, because usbemu=disable persisted across reboot without reducing the bounded 10-second SMI sample."
          , "Capture manual BIOS observations for hpet and computrace if those fields remain invisible through legacy DCC."
          , "Only promote the host to a low-latency validated baseline after BIOS settings, tuned profile, host cmdline posture, and bounded SMI behavior are all re-checked."
          ]
      }

in  record
