let ChapelProbe = ../types/ChapelHostProbeRun.dhall

let record
    : ChapelProbe.ChapelHostProbeRun
    = { date = "2026-04-26"
      , ownerIssue = Some "TIN-600"
      , host = "honey"
      , compilerSource = "target-store-prebuilt"
      , compilerRef = Some "/nix/store/8y7r4j0lzv8jjyllmhc0gydyssw88rvr-chapel-2.8.0"
      , chapelVersion = Some "2.8.0"
      , expectedLane = ChapelProbe.ExpectedLane.generic
      , kernelVersion = "6.19.5-7.xr.el10"
      , unameVariant = Some "#1 SMP PREEMPT_DYNAMIC Sun Apr 12 13:09:27 UTC 2026"
      , sysKernelRealtime = Some False
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
      , serialSeconds = Some 0.021964
      , parallelSeconds = Some 0.001782
      , speedup = Some 12.3255
      , delta = Some 1.86265e-09
      , contractCeiling = "C2"
      , result = ChapelProbe.ProbeResult.pass
      , evidence = [ "data/captures/honey/chapel-host-probe-generic-repeat-2026-04-26-sample-03.txt"
          , "data/captures/honey/host-characterization-window-generic-repeat-2026-04-26.txt" ]
      , notes = [ "Generic-lane store-prebuilt Chapel repeat captured in the 2026-04-26 host characterization window; not an RT comparison." ]
      , followUp = [ "Capture the matching RT repeat series with the same host-characterization-window helper." ]
      }

in  record
