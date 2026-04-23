let KernelLane = < generic | rt >

let ValidationResult = < pass | fail | partial | historical >

let KernelValidationRun =
      { date : Text
      , ownerIssue : Optional Text
      , host : Text
      , lane : KernelLane
      , phase : Text
      , intent : Optional Text
      , kernelVersion : Text
      , unameVariant : Optional Text
      , sysKernelRealtime : Optional Bool
      , tunedProfile : Optional Text
      , defaultKernel : Optional Text
      , defaultPreserved : Optional Bool
      , nextEntryState : Optional Text
      , nextEntryConsumed : Optional Bool
      , baseMatched : Natural
      , baseMismatched : Natural
      , rtMatched : Optional Natural
      , rtMismatched : Optional Natural
      , cmdlineMatched : Natural
      , cmdlineMissing : Natural
      , validatorPass : Bool
      , smiCountPer10s : Optional Natural
      , hwlatMaxUs : Optional Natural
      , reconnectSeconds : Optional Natural
      , returnToGenericSeconds : Optional Natural
      , returnKernelVersion : Optional Text
      , returnBaselinePass : Optional Bool
      , result : ValidationResult
      , evidence : List Text
      , notes : List Text
      , followUp : List Text
      }

in  { KernelLane, ValidationResult, KernelValidationRun }
