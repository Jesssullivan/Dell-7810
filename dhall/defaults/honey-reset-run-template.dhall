let Reset = ../types/ResetRun.dhall

let record
    : Reset.ResetRun
    = { runId = "<run-id>"
      , trigger = Reset.ResetTrigger.warm-reboot
      , acPowerBroken = False
      , managementDisplay = "<management-display-result>"
      , xrDisplay = "<xr-display-result>"
      , remoteState = "<remote-return-result>"
      , kernelMarkers = [] : List Text
      , outcome = Reset.RunOutcome.partial
      , evidence = [] : List Text
      , notes = None Text
      }

in  record
