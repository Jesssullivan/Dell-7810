let ChapelProbe = ../types/ChapelHostProbeRun.dhall

let record
    : ChapelProbe.ChapelHostProbeRun
    = { date = "2026-04-25"
      , ownerIssue = Some "TIN-600"
      , host = "honey"
      , compilerSource = "target-store-prebuilt"
      , compilerRef = Some "/nix/store/8y7r4j0lzv8jjyllmhc0gydyssw88rvr-chapel-2.8.0"
      , chapelVersion = Some "2.8.0"
      , expectedLane = ChapelProbe.ExpectedLane.rt
      , kernelVersion = "6.19.5-rt1-8.xr.el10"
      , unameVariant = Some "#1 SMP PREEMPT_RT Sun Apr 12 22:55:59 UTC 2026"
      , sysKernelRealtime = Some True
      , tunedProfile = None Text
      , localeCount = 1
      , sublocaleCount = 0
      , coresPerLocale = 16
      , channelCount = 100
      , sampleCount = 2500
      , sampleRateHz = 250
      , partitionCount = 2
      , timingConforms = True
      , jitterMinSeconds = 0.0
      , jitterMaxSeconds = 1.33574e-15
      , jitterMeanSeconds = 3.12804e-16
      , serialSeconds = Some 0.022533
      , parallelSeconds = Some 0.001927
      , speedup = Some 11.6933
      , delta = Some 1.86265e-09
      , contractCeiling = "C3"
      , result = ChapelProbe.ProbeResult.pass
      , evidence = [ "data/captures/honey/chapel-host-probe-rt-2026-04-25.txt"
          , "data/captures/honey/smi-validate-rt-2026-04-25-sample-01.txt"
          , "data/captures/honey/smi-validate-rt-2026-04-25-sample-02.txt"
          , "data/captures/honey/smi-validate-rt-2026-04-25-sample-03.txt" ]
      , notes = [ "RT-lane Chapel host characterization captured with matched RT SMI/hwlat context; this is host characterization, not downstream XR proof."
          , "RT SMI remained nonzero and similar in magnitude to the generic packet; do not claim SMI improvement." ]
      , followUp = [ "Compare generic and RT packets in a claim-safe result note; increase sample count before publication claims." ]
      }

in  record
