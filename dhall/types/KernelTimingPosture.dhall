let KernelLane = < stock | host-latency | host-latency-rt | xr | debug | unknown >

in  { kernelLane : KernelLane
    , bootSource : Text
    , expectRT : Bool
    , tunedProfile : Optional Text
    , cmdlineParams : List Text
    , smiMitigations : List Text
    , notes : Optional Text
    }
