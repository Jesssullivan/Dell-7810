let Power = ../types/PowerPathInventory.dhall

let record
    : Power.PowerPathInventory
    = { date = "<fill-date>"
      , ownerIssue = None Text
      , host = "honey"
      , operator = None Text
      , primaryPsu =
          { role = "Dell primary PSU"
          , model = None Text
          , ratedWattage = None Natural
          , partNumber = None Text
          , formFactor = None Text
          , harnesses = [] : List Text
          , notes = None Text
          }
      , secondaryPsu =
          Some
            { role = "External or secondary ATX assist path"
            , model = None Text
            , ratedWattage = None Natural
            , partNumber = None Text
            , formFactor = None Text
            , harnesses = [] : List Text
            , notes = None Text
            }
      , currentConsumers = [] : List Text
      , routingNotes = [] : List Text
      , startTrigger = None Power.TriggerMode
      , startTriggerDetail = None Text
      , stopTriggerDetail = None Text
      , warmRebootLeavesRailsAlive = None Bool
      , gpuModel = None Text
      , gpuAuxConnectors = 2
      , connectorFeeds = [] : List Power.GpuConnectorFeed
      , daisyChainedBranchesPresent = None Bool
      , nativeDellRails = [] : List Text
      , externalAtxRails = [] : List Text
      , inferredConnections = [] : List Text
      , suspectedWeakLinks = [] : List Text
      , knownGoodBehavior = [] : List Text
      , knownBadBehavior = [] : List Text
      , hardAcBreakRecoversSoftRebootState = None Bool
      , relatedResetRuns = [] : List Text
      , evidenceRefs =
          [ "docs/research/honey-power-reset-and-multi-psu-2026-04-22.md"
          , "docs/platform/power-path-inventory-template.md"
          ]
      , explicitUnknowns =
          [ "Exact secondary PSU start and stop signaling is still uncaptured."
          , "Distribution-board and rail allocation remain partially inferred."
          ]
      , proves = [] : List Text
      , unsafeAssumptions = [] : List Text
      , nextStep =
          Some
            "Fill actual PSU models, harnesses, trigger method, GPU connector feeds, and rail ownership."
      }

in  record
