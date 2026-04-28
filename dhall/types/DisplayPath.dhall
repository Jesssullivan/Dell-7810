let DisplayRole = < management | xr | auxiliary >

let DisplayStatus = < expected | observed-good | observed-bad | unknown >

in  { role : DisplayRole
    , connector : Text
    , displayName : Optional Text
    , edidExpected : Bool
    , status : DisplayStatus
    , notes : Optional Text
    }
