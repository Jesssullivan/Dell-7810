// TestHostNumaTiming -- property-based tests for host partitioning and timing helpers

use quickchpl;
use List;
use HostNumaTiming;

proc approxEqual(a: real, b: real, eps: real = 1e-9): bool {
  return abs(a - b) <= eps * max(1.0, max(abs(a), abs(b)));
}

proc main() {
  writeln("TestHostNumaTiming: property-based tests for Dell 7810 host analysis");
  writeln("");

  var partitionCoverage = property("partition coverage equals channel total",
    tupleGen(
      listGen(realGen(-1.0, 1.0), 0, 512),
      realGen(1.0, 16.0)
    ),
    proc(args: (list(real), real)): bool {
      const (channels, groupApprox) = args;
      const groups = max(1, min(16, groupApprox: int));
      const parts = partitionChannels(channels.size, groups);
      return totalCovered(parts) == channels.size;
    });

  var r1 = check(partitionCoverage, 200);
  printResult(r1);

  var partitionContiguous = property("partitions are contiguous and exact",
    tupleGen(
      listGen(realGen(-1.0, 1.0), 0, 512),
      realGen(1.0, 16.0)
    ),
    proc(args: (list(real), real)): bool {
      const (channels, groupApprox) = args;
      const groups = max(1, min(16, groupApprox: int));
      const parts = partitionChannels(channels.size, groups);
      return coversExactly(parts, channels.size);
    });

  var r2 = check(partitionContiguous, 200);
  printResult(r2);

  var syntheticDeterministic = property("synthetic signal is deterministic",
    tupleGen(realGen(0.0, 256.0), realGen(0.0, 10000.0)),
    proc(args: (real, real)): bool {
      const (sampleApprox, seedApprox) = args;
      const numSamples = max(0, sampleApprox: int);
      const seed = seedApprox: int;
      const s1 = syntheticSignal(numSamples, seed);
      const s2 = syntheticSignal(numSamples, seed);

      if s1.size != s2.size then return false;
      for i in 0..<s1.size {
        if !approxEqual(s1[i], s2[i]) then return false;
      }
      return true;
    });

  var r3 = check(syntheticDeterministic, 200);
  printResult(r3);

  var statsOrdered = property("timing stats are ordered and non-negative",
    listGen(realGen(0.0, 5.0), 1, 128),
    proc(samples: list(real)): bool {
      const stats = summarizeSamples(samples);
      return stats.samples == samples.size
          && stats.minSeconds >= 0.0
          && stats.maxSeconds >= stats.minSeconds
          && stats.meanSeconds >= stats.minSeconds
          && stats.meanSeconds <= stats.maxSeconds;
    });

  var r4 = check(statsOrdered, 200);
  printResult(r4);

  var statsScaling = property("timing stats scale linearly with positive factors",
    tupleGen(
      listGen(realGen(0.0, 5.0), 1, 128),
      realGen(0.1, 10.0)
    ),
    proc(args: (list(real), real)): bool {
      const (samples, scale) = args;
      var scaled: list(real);
      for s in samples do scaled.pushBack(s * scale);

      const a = summarizeSamples(samples);
      const b = summarizeSamples(scaled);

      return b.samples == a.samples
          && approxEqual(b.minSeconds, a.minSeconds * scale, 1e-6)
          && approxEqual(b.maxSeconds, a.maxSeconds * scale, 1e-6)
          && approxEqual(b.meanSeconds, a.meanSeconds * scale, 1e-6);
    });

  var r5 = check(statsScaling, 100);
  printResult(r5);

  writeln("");
  printSummary([r1, r2, r3, r4, r5]);
}
