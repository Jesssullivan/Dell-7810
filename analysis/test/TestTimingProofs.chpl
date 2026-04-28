// TestTimingProofs -- property-based tests for repo-owned timing proof helpers

use quickchpl;
use List;
use TimingProofs;

proc approxEqual(a: real, b: real, eps: real = 1e-9): bool {
  return abs(a - b) <= eps * max(1.0, max(abs(a), abs(b)));
}

proc timestampsFromIntervals(intervals: list(real)): list(real) {
  var timestamps: list(real);
  var elapsed: real = 0.0;

  timestamps.pushBack(elapsed);
  for intervalSeconds in intervals {
    elapsed += intervalSeconds;
    timestamps.pushBack(elapsed);
  }

  return timestamps;
}

proc main() {
  writeln("TestTimingProofs: property-based tests for timing budgets and jitter");
  writeln("");

  var roundTrip = property("monotonic timestamps round-trip to intervals",
    listGen(realGen(0.0, 0.05), 1, 128),
    proc(intervals: list(real)): bool {
      const timestamps = timestampsFromIntervals(intervals);
      const recovered = intervalsFromTimestamps(timestamps);

      if !isMonotonicNondecreasing(timestamps) then return false;
      if recovered.size != intervals.size then return false;

      for i in 0..<intervals.size {
        if !approxEqual(recovered[i], intervals[i]) then return false;
      }

      return true;
    });

  var r1 = check(roundTrip, 200);
  printResult(r1);

  var exactBudget = property("exact periodic timestamps satisfy exact budget",
    tupleGen(realGen(2.0, 256.0), realGen(0.0005, 0.02)),
    proc(args: (real, real)): bool {
      const (countApprox, periodSeconds) = args;
      const count = max(2, countApprox: int);
      const timestamps = exactPeriodicTimestamps(count, periodSeconds);
      const intervals = intervalsFromTimestamps(timestamps);
      const budget = new TimingBudget(
        targetPeriodSeconds = periodSeconds,
        maxJitterSeconds = 0.0,
        maxLatencySeconds = periodSeconds
      );
      const jitterStats = summarizeJitter(intervals, periodSeconds);

      return timingConforms(intervals, budget)
          && approxEqual(jitterStats.minSeconds, 0.0, 1e-12)
          && approxEqual(jitterStats.maxSeconds, 0.0, 1e-12)
          && approxEqual(jitterStats.meanSeconds, 0.0, 1e-12);
    });

  var r2 = check(exactBudget, 200);
  printResult(r2);

  var boundedJitter = property("bounded jitter respects matching budget",
    tupleGen(
      realGen(2.0, 256.0),
      realGen(0.004, 0.02),
      realGen(0.0, 1.0),
      realGen(0.0, 10000.0)
    ),
    proc(args: (real, real, real, real)): bool {
      const (countApprox, periodSeconds, jitterFraction, seedApprox) = args;
      const count = max(2, countApprox: int);
      const jitterSeconds = jitterFraction * periodSeconds / 4.0;
      const seed = seedApprox: int;
      const timestamps = jitteredTimestamps(count, periodSeconds, jitterSeconds, seed);
      const intervals = intervalsFromTimestamps(timestamps);
      const budget = new TimingBudget(
        targetPeriodSeconds = periodSeconds,
        maxJitterSeconds = jitterSeconds + 1e-9,
        maxLatencySeconds = periodSeconds + jitterSeconds + 1e-9
      );
      const jitterStats = summarizeJitter(intervals, periodSeconds);

      return isMonotonicNondecreasing(timestamps)
          && timingConforms(intervals, budget)
          && jitterStats.maxSeconds <= jitterSeconds + 1e-6;
    });

  var r3 = check(boundedJitter, 200);
  printResult(r3);

  var scalingInvariant = property("scaling intervals and budget preserves conformance",
    tupleGen(
      realGen(2.0, 256.0),
      realGen(0.004, 0.02),
      realGen(0.0, 1.0),
      realGen(0.1, 10.0),
      realGen(0.0, 10000.0)
    ),
    proc(args: (real, real, real, real, real)): bool {
      const (countApprox, periodSeconds, jitterFraction, scale, seedApprox) = args;
      const count = max(2, countApprox: int);
      const jitterSeconds = jitterFraction * periodSeconds / 4.0;
      const seed = seedApprox: int;
      const timestamps = jitteredTimestamps(count, periodSeconds, jitterSeconds, seed);
      const intervals = intervalsFromTimestamps(timestamps);
      var scaledIntervals: list(real);

      for intervalSeconds in intervals do
        scaledIntervals.pushBack(intervalSeconds * scale);

      const budget = new TimingBudget(
        targetPeriodSeconds = periodSeconds,
        maxJitterSeconds = jitterSeconds + 1e-9,
        maxLatencySeconds = periodSeconds + jitterSeconds + 1e-9
      );
      const scaledBudget = new TimingBudget(
        targetPeriodSeconds = periodSeconds * scale,
        maxJitterSeconds = (jitterSeconds + 1e-9) * scale,
        maxLatencySeconds = (periodSeconds + jitterSeconds + 1e-9) * scale
      );

      return timingConforms(intervals, budget)
          && timingConforms(scaledIntervals, scaledBudget);
    });

  var r4 = check(scalingInvariant, 100);
  printResult(r4);

  writeln("");
  printSummary([r1, r2, r3, r4]);
}
