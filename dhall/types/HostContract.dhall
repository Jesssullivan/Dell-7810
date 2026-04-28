let HostIdentity = ./HostIdentity.dhall

let KernelTimingPosture = ./KernelTimingPosture.dhall

let DisplayPath = ./DisplayPath.dhall

let PowerContract = ./PowerContract.dhall

let EvidenceRef = ./EvidenceRef.dhall

let ResetTypes = ./ResetRun.dhall

in  { host : HostIdentity
    , kernel : KernelTimingPosture
    , displays : List DisplayPath
    , power : PowerContract
    , recentResetRuns : List ResetTypes.ResetRun
    , evidence : List EvidenceRef
    , invariants : List Text
    , explicitUnknowns : List Text
    }
