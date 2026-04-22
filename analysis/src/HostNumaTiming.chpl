// HostNumaTiming -- host characterization helpers for Dell 7810 analysis
//
// This module is intentionally about workstation structure and timing
// invariants rather than application-specific BCI logic.

module HostNumaTiming {
  use List;

  record Partition {
    var start: int;
    var count: int;
  }

  record TimingStats {
    var minSeconds: real;
    var maxSeconds: real;
    var meanSeconds: real;
    var samples: int;
  }

  proc partitionChannels(numChannels: int, partitions: int): [0..<partitions] Partition {
    var parts: [0..<partitions] Partition;
    const base = numChannels / partitions;
    const remainder = numChannels % partitions;
    var offset = 0;

    for i in 0..<partitions {
      const count = base + (if i < remainder then 1 else 0);
      parts[i] = new Partition(start = offset, count = count);
      offset += count;
    }

    return parts;
  }

  proc totalCovered(parts: [?D] Partition): int {
    var total = 0;
    for p in parts do
      total += p.count;
    return total;
  }

  proc coversExactly(parts: [?D] Partition, total: int): bool {
    var expectedStart = 0;
    for p in parts {
      if p.count < 0 then return false;
      if p.start != expectedStart then return false;
      expectedStart += p.count;
    }
    return expectedStart == total;
  }

  proc syntheticSignal(numSamples: int, seed: int = 0): list(real) {
    var signal: list(real);
    for i in 0..<numSamples {
      const raw = ((seed + i * 1103515245 + 12345) % 1000): real;
      signal.pushBack((raw - 500.0) / 25.0);
    }
    return signal;
  }

  proc summarizeSamples(samples: list(real)): TimingStats {
    if samples.size == 0 {
      return new TimingStats(minSeconds = 0.0, maxSeconds = 0.0,
                             meanSeconds = 0.0, samples = 0);
    }

    var minSeconds = samples[0];
    var maxSeconds = samples[0];
    var sumSeconds: real = 0.0;

    for s in samples {
      if s < minSeconds then minSeconds = s;
      if s > maxSeconds then maxSeconds = s;
      sumSeconds += s;
    }

    return new TimingStats(
      minSeconds = minSeconds,
      maxSeconds = maxSeconds,
      meanSeconds = sumSeconds / samples.size: real,
      samples = samples.size
    );
  }
}
