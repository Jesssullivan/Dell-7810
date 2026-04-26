let ChapelProbe = ../types/ChapelHostProbeRun.dhall

let record
    : ChapelProbe.ChapelHostProbeRun
    = { date = "2026-04-26"
      , ownerIssue = Some "TIN-600"
      , host = "honey"
      , compilerSource = "store-prebuilt"
      , compilerRef = Some "/nix/store/8y7r4j0lzv8jjyllmhc0gydyssw88rvr-chapel-2.8.0"
      , chapelVersion = Some "2.8.0"
      , expectedLane = ChapelProbe.ExpectedLane.rt
      , kernelVersion = "6.19.5-rt1-8.xr.el10"
      , unameVariant = Some "#1 SMP PREEMPT_RT Sun Apr 12 22:55:59 UTC 2026"
      , sysKernelRealtime = Some True
      , tunedProfile = Some "t7810-low-latency"
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
      , serialSeconds = Some 0.022157
      , parallelSeconds = Some 0.00181
      , speedup = Some 12.2414
      , delta = Some 1.86265e-09
      , contractCeiling = "C4-precondition-only"
      , result = ChapelProbe.ProbeResult.pass
      , evidence = [ "data/captures/honey/chapel-host-probe-rt-chapel-repeat-2026-04-26-sample-01.txt" ]
      , notes = [ "RT Chapel-only repeat after bounded capture hardening"
          , "Do not claim RT improvement; sample distribution includes a severe parallel outlier" ]
      , followUp = [ "Compare against generic-repeat-2026-04-26 and decide whether to rerun under quieter load" ]
      }

in  record
