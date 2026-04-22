let HostContract = ../types/HostContract.dhall

let KernelLane = (../types/KernelTimingPosture.dhall).KernelLane

let DisplayRole = (../types/DisplayPath.dhall).DisplayRole
let DisplayStatus = (../types/DisplayPath.dhall).DisplayStatus

let PowerState = (../types/PowerContract.dhall).PowerState

let EvidenceKind = (../types/EvidenceRef.dhall).EvidenceKind

let runB = ./honey-reset-run-b-2026-04-22.dhall

let runC = ./honey-reset-run-c-2026-04-22.dhall

let honey
    : HostContract
    = { host =
          { hostname = "honey"
          , vendor = "Dell"
          , model = "Precision Tower 7810"
          , boardId = "0GWHMW"
          , biosVersion = Some "A34"
          , biosDate = None Text
          , gpu = Some "AMD Radeon RX 9070-class card"
          , notes =
              Some
                "Host subject for Dell-7810 platform characterization; not a full boot-ops definition."
          }
      , kernel =
          { kernelLane = KernelLane.host-latency
          , bootSource = "Record concrete boot-entry and deployment state in XoxdWM; summarize only the host posture here."
          , expectRT = False
          , tunedProfile = Some "t7810-low-latency"
          , cmdlineParams =
              [ "tsc=nowatchdog"
              , "clocksource=tsc"
              , "intel_pstate=disable"
              , "processor.max_cstate=1"
              , "intel_idle.max_cstate=0"
              , "nmi_watchdog=0"
              ]
          , smiMitigations =
              [ "Disable USB legacy support"
              , "Prefer TCO watchdog disabled in kernel config"
              , "Use Dell-specific BIOS posture captured in bios-settings record"
              ]
          , notes =
              Some
                "This summarizes the host timing posture only. Kernel package versions and boot-entry generation stay outside this contract."
          }
      , displays =
          [ { role = DisplayRole.management
            , connector = "HDMI-A-2"
            , displayName = Some "Dell HDMI management display"
            , edidExpected = True
            , status = DisplayStatus.observed-good
            , notes = Some "Trusted operator display after hard recovery boot on 2026-04-22."
            }
          , { role = DisplayRole.xr
            , connector = "DP-2"
            , displayName = Some "Bigscreen Beyond display path"
            , edidExpected = True
            , status = DisplayStatus.observed-good
            , notes = Some "Recovered alongside HDMI-A-2 on healthy reset rows."
            }
          ]
      , power =
          { primaryPsu = "Dell primary PSU and distribution board"
          , secondaryPsu = Some "External or secondary ATX assist path"
          , syncMethod = None Text
          , gpuAuxConnectors = 2
          , requireSeparateGpuLeads = True
          , state = PowerState.fragile
          , knownUnknowns =
              [ "Exact secondary start and stop signaling is not yet captured as a measured contract."
              , "Distribution-board and rail allocation remain partially inferred."
              ]
          , notes =
              Some
                "See the power-path inventory and multi-PSU research note before turning this into stronger electrical claims."
          }
      , recentResetRuns = [ runB, runC ]
      , evidence =
          [ { id = "reset-matrix-2026-04-22"
            , kind = EvidenceKind.note
            , ref = "docs/research/honey-reset-matrix-2026-04-22.md"
            , summary = "Reset outcomes, connector states, and remote operability on April 22, 2026."
            }
          , { id = "power-reset-multi-psu-2026-04-22"
            , kind = EvidenceKind.note
            , ref = "docs/research/honey-power-reset-and-multi-psu-2026-04-22.md"
            , summary = "Power-path and multi-PSU research framing with source-backed constraints."
            }
          , { id = "management-display-2026-04-22"
            , kind = EvidenceKind.note
            , ref = "docs/research/honey-management-display-and-recovery-path-2026-04-22.md"
            , summary = "Why the management-display lane is part of the host contract."
            }
          , { id = "host-kernel-baseline"
            , kind = EvidenceKind.note
            , ref = "docs/platform/host-kernel-baseline.md"
            , summary = "Generic host-latency kernel baseline beneath XR overlays."
            }
          ]
      , invariants =
          [ "The management display is a required recovery surface."
          , "Host timing posture and host evidence belong in Dell-7810."
          , "Boot-entry generation and storage topology remain operational surfaces outside this contract."
          ]
      , explicitUnknowns =
          [ "No measured BIOS settings record has been filled yet."
          , "No filled power-path inventory exists yet."
          , "The exact secondary PSU sync and rail contract is still incomplete."
          ]
      }

in  honey
