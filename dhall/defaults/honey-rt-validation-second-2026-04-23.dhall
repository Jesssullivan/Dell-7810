let KernelValidation = ../types/KernelValidationRun.dhall

let record
    : KernelValidation.KernelValidationRun
    = { date = "2026-04-23"
      , ownerIssue = Some "TIN-397"
      , host = "honey"
      , lane = KernelValidation.KernelLane.rt
      , phase = "second one-time RT validation under reconciled Dell rule"
      , intent =
          Some
            "Confirm that the shipped linux-xr RT kernel validates cleanly under the reconciled Dell rule and still returns safely to the generic fallback lane."
      , kernelVersion = "6.19.5-rt1-8.xr.el10"
      , unameVariant = Some "#1 SMP PREEMPT_RT Sun Apr 12 22:55:59 UTC 2026"
      , sysKernelRealtime = Some True
      , tunedProfile = Some "t7810-low-latency"
      , defaultKernel = Some "/boot/vmlinuz-6.19.5-7.xr.el10"
      , defaultPreserved = Some True
      , nextEntryState = Some "consumed-and-cleared"
      , nextEntryConsumed = Some True
      , baseMatched = 30
      , baseMismatched = 0
      , rtMatched = Some 3
      , rtMismatched = Some 0
      , cmdlineMatched = 19
      , cmdlineMissing = 0
      , validatorPass = True
      , smiCountPer10s = Some 16
      , hwlatMaxUs = Some 0
      , reconnectSeconds = Some 120
      , returnToGenericSeconds = Some 55
      , returnKernelVersion = Some "6.19.5-7.xr.el10"
      , returnBaselinePass = Some True
      , result = KernelValidation.ValidationResult.partial
      , evidence =
          [ "data/captures/honey/kernel-lane-status-pre-rt-recheck-2026-04-23.txt"
          , "data/captures/honey/kernel-baseline-pre-rt-recheck-2026-04-23.txt"
          , "data/captures/honey/kernel-lane-arm-rt-recheck-2026-04-23.txt"
          , "data/captures/honey/reboot-confirmation-post-rt-recheck-2026-04-23.txt"
          , "data/captures/honey/kernel-lane-status-post-rt-recheck-2026-04-23.txt"
          , "data/captures/honey/kernel-baseline-post-rt-recheck-2026-04-23.txt"
          , "data/captures/honey/smi-validate-post-rt-recheck-2026-04-23.txt"
          , "data/captures/honey/reboot-confirmation-post-rt-recheck-return-generic-2026-04-23.txt"
          , "data/captures/honey/kernel-lane-status-post-rt-recheck-return-generic-2026-04-23.txt"
          , "data/captures/honey/kernel-baseline-post-rt-recheck-return-generic-2026-04-23.txt"
          ]
      , notes =
          [ "Generic preflight passed before the second RT run: base 30/30 and cmdline 19/19."
          , "The reconciled Dell RT validator passed cleanly against the shipped linux-xr RT kernel: base 30/30, RT overlay 3/3, cmdline 19/19."
          , "Bounded SMI count remained at 16 in 10 seconds, but tracefs hwlat reported 0 us on the second RT pass."
          , "RT reconnect remained slower than the generic lane, but the second pass was smoother than the first."
          , "The host returned to the generic fallback lane and the generic baseline passed again after the follow-on reboot."
          ]
      , followUp =
          [ "Decide whether the slower RT recovery is operationally acceptable for honey's workstation role."
          , "Decide whether a longer RT hwlat run is worth the host time."
          , "Keep Chapel live-host work separate from kernel validation until the local compiler build is available."
          ]
      }

in  record
