let KernelValidation = ../types/KernelValidationRun.dhall

let record
    : KernelValidation.KernelValidationRun
    = { date = "2026-04-23"
      , ownerIssue = Some "TIN-397"
      , host = "honey"
      , lane = KernelValidation.KernelLane.rt
      , phase = "first one-time RT validation"
      , intent =
          Some
            "Validate one-time PREEMPT_RT boot while preserving the generic linux-xr kernel as the persistent fallback lane."
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
      , rtMatched = Some 1
      , rtMismatched = Some 3
      , cmdlineMatched = 19
      , cmdlineMissing = 0
      , validatorPass = False
      , smiCountPer10s = Some 16
      , hwlatMaxUs = Some 1
      , reconnectSeconds = Some 145
      , returnToGenericSeconds = None Natural
      , returnKernelVersion = Some "6.19.5-7.xr.el10"
      , returnBaselinePass = None Bool
      , result = KernelValidation.ValidationResult.partial
      , evidence =
          [ "data/captures/honey/kernel-lane-status-pre-rt-reboot-2026-04-23.txt"
          , "data/captures/honey/kernel-runtime-pre-rt-reboot-2026-04-23.txt"
          , "data/captures/honey/reboot-confirmation-post-rt-boot-2026-04-23.txt"
          , "data/captures/honey/kernel-lane-status-post-rt-boot-2026-04-23.txt"
          , "data/captures/honey/kernel-baseline-post-rt-boot-2026-04-23.txt"
          , "data/captures/honey/smi-validate-post-rt-boot-2026-04-23.txt"
          , "data/captures/honey/reboot-confirmation-post-rt-return-generic-2026-04-23.txt"
          , "data/captures/honey/kernel-lane-status-post-rt-return-generic-2026-04-23.txt"
          ]
      , notes =
          [ "The one-time RT boot succeeded and preserved the generic default kernel as intended."
          , "The first-pass Dell RT fragment was stricter than the live shipped linux-xr RT kernel and failed on PREEMPT_DYNAMIC semantics."
          , "Bounded SMI count stayed at 16 in 10 seconds, while tracefs hwlat reported only 1 us max latency."
          , "Remote recovery after the RT reboot was slow and briefly unstable before follow-on checks completed."
          ]
      , followUp =
          [ "Reconcile the Dell RT validator with the shipped linux-xr RT semantics."
          , "Repeat the one-time RT validation under the reconciled rule."
          , "Collect the first Dell-owned Chapel host probe result once the local compiler build is available."
          ]
      }

in  record
