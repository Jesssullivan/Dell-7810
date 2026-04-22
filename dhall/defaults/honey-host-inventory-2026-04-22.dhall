let HostInventory = ../types/HostInventoryRecord.dhall

let record
    : HostInventory.HostInventoryRecord
    = { date = "2026-04-22"
      , ownerIssue = Some "TIN-397"
      , host = "honey"
      , operator = Some "Jess Sullivan"
      , intendedPurpose = Some "Live workstation baseline after authority consolidation"
      , captureRef = Some "data/captures/honey/numa-baseline-2026-04-22.json"
      , biosVersion = Some "A34"
      , boardName = Some "0GWHMW"
      , cpuModel = Some "Intel(R) Xeon(R) CPU E5-2630 v3 @ 2.40GHz"
      , totalRamGiB = Some 219
      , numaNodesObserved = Some 2
      , cpusPerNode =
          [ "node0:0-7,16-23"
          , "node1:8-15,24-31"
          ]
      , asymmetryNotes =
          [ "Node 0 reports more RAM than node 1 in the live capture."
          ]
      , kernelVersion = Some "6.19.5-7.xr.el10"
      , genericHostLatencyBaseline = Some False
      , rtOverlayInUse = Some False
      , bootCmdlineSource = Some "/proc/cmdline live capture on honey"
      , tunedProfile = Some "none detected"
      , notes =
          [ "Live capture confirms BIOS A34 and the generic linux-xr kernel lane."
          , "RT is installed on-host but was not active in this capture."
          , "The current boot cmdline does not contain the intended low-latency isolation or C-state override arguments."
          , "Dell Command | Configure was not installed, so BIOS settings were not machine-checked."
          ]
      , followUp =
          [ "Install or temporarily stage Dell Command | Configure if BIOS settings must be read programmatically."
          , "Run just platform-bios-rt-check on the live host once cctk is available."
          , "Decide whether the low-latency cmdline should be restored on the generic lane or kept as a narrower experimental posture."
          ]
      }

in  record
