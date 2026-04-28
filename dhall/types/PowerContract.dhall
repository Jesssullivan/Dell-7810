let PowerState = < stable | fragile | unknown >

in  { primaryPsu : Text
    , secondaryPsu : Optional Text
    , syncMethod : Optional Text
    , gpuAuxConnectors : Natural
    , requireSeparateGpuLeads : Bool
    , state : PowerState
    , knownUnknowns : List Text
    , notes : Optional Text
    }
