let Bios = ../types/BiosRecord.dhall

let record
    : Bios.BiosRecord
    = { date = "<fill-date>"
      , ownerIssue = None Text
      , host = "honey"
      , operator = None Text
      , biosVersion = None Text
      , biosDate = None Text
      , settings =
          [ { name = "usblegacy"
            , expected = "disabled"
            , observed = None Text
            , source = None Bios.SettingSource
            , matchState = Bios.MatchState.unknown
            , notes = None Text
            }
          , { name = "cstates"
            , expected = "c1"
            , observed = None Text
            , source = None Bios.SettingSource
            , matchState = Bios.MatchState.unknown
            , notes = None Text
            }
          , { name = "intelturboboosten"
            , expected = "disabled"
            , observed = None Text
            , source = None Bios.SettingSource
            , matchState = Bios.MatchState.unknown
            , notes = None Text
            }
          , { name = "intelspdstep"
            , expected = "disabled"
            , observed = None Text
            , source = None Bios.SettingSource
            , matchState = Bios.MatchState.unknown
            , notes = None Text
            }
          , { name = "hpet"
            , expected = "enabled"
            , observed = None Text
            , source = None Bios.SettingSource
            , matchState = Bios.MatchState.unknown
            , notes = None Text
            }
          , { name = "computrace"
            , expected = "deactivate"
            , observed = None Text
            , source = None Bios.SettingSource
            , matchState = Bios.MatchState.unknown
            , notes = None Text
            }
          ]
      , fullCheckOutputRef = None Text
      , manualNotes = [] : List Text
      , matchesLowLatencyTarget = None Bool
      , rebootPending = None Bool
      , unlocksNextValidation = None Bool
      , followUp =
          [ "Run just platform-bios-rt-check on honey."
          , "Capture any settings that require manual BIOS inspection."
          ]
      }

in  record
