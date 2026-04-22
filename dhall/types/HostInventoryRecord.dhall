let HostInventoryRecord =
      { date : Text
      , ownerIssue : Optional Text
      , host : Text
      , operator : Optional Text
      , intendedPurpose : Optional Text
      , captureRef : Optional Text
      , biosVersion : Optional Text
      , boardName : Optional Text
      , cpuModel : Optional Text
      , totalRamGiB : Optional Natural
      , numaNodesObserved : Optional Natural
      , cpusPerNode : List Text
      , asymmetryNotes : List Text
      , kernelVersion : Optional Text
      , genericHostLatencyBaseline : Optional Bool
      , rtOverlayInUse : Optional Bool
      , bootCmdlineSource : Optional Text
      , tunedProfile : Optional Text
      , notes : List Text
      , followUp : List Text
      }

in  { HostInventoryRecord }
