let ChapelProbe = ../types/ChapelHostProbeRun.dhall

let record
    : ChapelProbe.ChapelHostProbeRun
    = { date = "2026-04-23"
      , ownerIssue = Some "TIN-470"
      , host = "honey"
      , compilerSource = "dell-local-fallback-on-target"
      , compilerRef = Some "/nix/store/7ss0vzf5h55kl260i8j8hy72f3jnjs3y-chapel-2.8.0 + synthetic CHPL_HOME"
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
      , serialSeconds = Some 0.02283
      , parallelSeconds = Some 0.00228
      , speedup = Some 10.0132
      , delta = Some 1.86265e-09
      , contractCeiling = "C4-precondition-only"
      , result = ChapelProbe.ProbeResult.pass
      , evidence = [ "data/captures/honey/chapel-host-probe-baseline.txt" ]
      , notes =
          [ "Generic-lane live probe executed successfully on honey."
          , "numactl reports two NUMA nodes, but the current Chapel probe reported zero sublocales."
          , "Capture used the Dell-local fallback package built on-target with a synthetic CHPL_HOME during operator bring-up."
          ]
      , followUp =
          [ "Revalidate the turnkey on-target capture script after the package wrapper fixes."
          , "Determine why Chapel/qthreads does not currently expose NUMA sublocales on the dual-socket host."
          ]
      }

in  record
