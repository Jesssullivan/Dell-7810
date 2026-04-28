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
      , genericHostLatencyBaseline = Some True
      , rtOverlayInUse = Some False
      , bootCmdlineSource = Some "/proc/cmdline live capture on honey after tuned-managed reboot"
      , tunedProfile = Some "t7810-low-latency"
      , notes =
          [ "Live capture confirms BIOS A34 and the generic linux-xr kernel lane."
          , "RT is installed on-host but was not active in this capture."
          , "After the repo-owned tuned activation and reboot, the live boot cmdline now contains the intended low-latency isolation and C-state override arguments."
          , "The repo-owned kernel baseline validator passed 30/30 config checks and 19/19 cmdline checks on the post-tuned reboot."
          , "The active tuned profile is now t7810-low-latency."
          , "Dell Command | Configure is installed and BIOS settings are machine-checked through the legacy 7810-compatible cctk surface."
          , "Bounded SMI counts remain nonzero, but the tracefs hwlat fallback reported 0 us max latency in the post-tuned reboot sample."
          ]
      , followUp =
          [ "Capture a longer tracefs hwlat run now that the tuned-managed boot cmdline is live."
          , "Investigate hidden BIOS surfaces that legacy DCC cannot see, especially Computrace and AMT-adjacent management posture."
          , "Decide whether the next validation lane should be PREEMPT_RT or further BIOS-side SMI candidate testing."
          ]
      }

in  record
