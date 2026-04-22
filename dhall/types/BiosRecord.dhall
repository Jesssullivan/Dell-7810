let SettingSource = < cctk | manualBios | captureScript >

let MatchState = < matches | mismatched | unknown >

let BiosSetting =
      { name : Text
      , expected : Text
      , observed : Optional Text
      , source : Optional SettingSource
      , matchState : MatchState
      , notes : Optional Text
      }

let BiosRecord =
      { date : Text
      , ownerIssue : Optional Text
      , host : Text
      , operator : Optional Text
      , biosVersion : Optional Text
      , biosDate : Optional Text
      , settings : List BiosSetting
      , fullCheckOutputRef : Optional Text
      , manualNotes : List Text
      , matchesLowLatencyTarget : Optional Bool
      , rebootPending : Optional Bool
      , unlocksNextValidation : Optional Bool
      , followUp : List Text
      }

in  { SettingSource, MatchState, BiosSetting, BiosRecord }
