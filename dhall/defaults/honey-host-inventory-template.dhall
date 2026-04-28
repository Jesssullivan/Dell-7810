let HostInventory = ../types/HostInventoryRecord.dhall

let record
    : HostInventory.HostInventoryRecord
    = { date = "<fill-date>"
      , ownerIssue = None Text
      , host = "honey"
      , operator = None Text
      , intendedPurpose = Some "Clean workstation baseline"
      , captureRef = None Text
      , biosVersion = None Text
      , boardName = None Text
      , cpuModel = None Text
      , totalRamGiB = None Natural
      , numaNodesObserved = None Natural
      , cpusPerNode = [] : List Text
      , asymmetryNotes = [] : List Text
      , kernelVersion = None Text
      , genericHostLatencyBaseline = None Bool
      , rtOverlayInUse = None Bool
      , bootCmdlineSource = None Text
      , tunedProfile = None Text
      , notes = [] : List Text
      , followUp =
          [ "Run just platform-capture-numa-state tag=baseline-<run-id> on honey."
          , "Fold the captured topology and kernel posture into this record."
          ]
      }

in  record
