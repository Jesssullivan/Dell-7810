let TriggerMode = < syncBoard | inferredRail | manualSwitch | unknown >

let PsuUnit =
      { role : Text
      , model : Optional Text
      , ratedWattage : Optional Natural
      , partNumber : Optional Text
      , formFactor : Optional Text
      , harnesses : List Text
      , notes : Optional Text
      }

let GpuConnectorFeed =
      { connector : Text
      , fedBy : Optional Text
      , separateLead : Optional Bool
      , notes : Optional Text
      }

let PowerPathInventory =
      { date : Text
      , ownerIssue : Optional Text
      , host : Text
      , operator : Optional Text
      , primaryPsu : PsuUnit
      , secondaryPsu : Optional PsuUnit
      , currentConsumers : List Text
      , routingNotes : List Text
      , startTrigger : Optional TriggerMode
      , startTriggerDetail : Optional Text
      , stopTriggerDetail : Optional Text
      , warmRebootLeavesRailsAlive : Optional Bool
      , gpuModel : Optional Text
      , gpuAuxConnectors : Natural
      , connectorFeeds : List GpuConnectorFeed
      , daisyChainedBranchesPresent : Optional Bool
      , nativeDellRails : List Text
      , externalAtxRails : List Text
      , inferredConnections : List Text
      , suspectedWeakLinks : List Text
      , knownGoodBehavior : List Text
      , knownBadBehavior : List Text
      , hardAcBreakRecoversSoftRebootState : Optional Bool
      , relatedResetRuns : List Text
      , evidenceRefs : List Text
      , explicitUnknowns : List Text
      , proves : List Text
      , unsafeAssumptions : List Text
      , nextStep : Optional Text
      }

in  { TriggerMode, PsuUnit, GpuConnectorFeed, PowerPathInventory }
