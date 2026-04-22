let ResetTrigger = < warm-reboot | shutdown-power-on | hard-reset | ac-break >

let RunOutcome = < pass | fail | partial | historical >

let ResetRun =
      { runId : Text
      , trigger : ResetTrigger
      , acPowerBroken : Bool
      , managementDisplay : Text
      , xrDisplay : Text
      , remoteState : Text
      , kernelMarkers : List Text
      , outcome : RunOutcome
      , evidence : List Text
      , notes : Optional Text
      }

in  { ResetTrigger, RunOutcome, ResetRun }
