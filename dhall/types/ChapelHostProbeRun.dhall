let ExpectedLane = < generic | rt | unknown >

let ProbeResult = < pass | fail | partial | blocked >

let ChapelHostProbeRun =
      { date : Text
      , ownerIssue : Optional Text
      , host : Text
      , compilerSource : Text
      , compilerRef : Optional Text
      , chapelVersion : Optional Text
      , expectedLane : ExpectedLane
      , kernelVersion : Text
      , unameVariant : Optional Text
      , sysKernelRealtime : Optional Bool
      , tunedProfile : Optional Text
      , localeCount : Natural
      , sublocaleCount : Natural
      , coresPerLocale : Natural
      , channelCount : Natural
      , sampleCount : Natural
      , sampleRateHz : Natural
      , partitionCount : Natural
      , timingConforms : Bool
      , jitterMinSeconds : Double
      , jitterMaxSeconds : Double
      , jitterMeanSeconds : Double
      , serialSeconds : Optional Double
      , parallelSeconds : Optional Double
      , speedup : Optional Double
      , delta : Optional Double
      , contractCeiling : Text
      , result : ProbeResult
      , evidence : List Text
      , notes : List Text
      , followUp : List Text
      }

in  { ExpectedLane, ProbeResult, ChapelHostProbeRun }
