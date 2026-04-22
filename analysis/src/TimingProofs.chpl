// TimingProofs -- proof-oriented timing helpers for Dell 7810 host analysis
//
// These helpers are deliberately generic enough to support NUMA probes,
// reset timing notes, and RT validation captures in this repo.

module TimingProofs {
  use List;
  use HostNumaTiming only TimingStats, summarizeSamples;

  record TimingBudget {
    var targetPeriodSeconds: real;
    var maxJitterSeconds: real;
    var maxLatencySeconds: real;
  }

  proc isMonotonicNondecreasing(timestamps: list(real)): bool {
    if timestamps.size <= 1 then return true;

    for i in 1..<timestamps.size {
      if timestamps[i] < timestamps[i - 1] then return false;
    }

    return true;
  }

  proc intervalsFromTimestamps(timestamps: list(real)): list(real) {
    var intervals: list(real);

    if timestamps.size <= 1 then return intervals;

    for i in 1..<timestamps.size do
      intervals.pushBack(timestamps[i] - timestamps[i - 1]);

    return intervals;
  }

  proc exactPeriodicTimestamps(numSamples: int, periodSeconds: real): list(real) {
    var timestamps: list(real);

    if numSamples <= 0 then return timestamps;

    for i in 0..<numSamples do
      timestamps.pushBack(i: real * periodSeconds);

    return timestamps;
  }

  proc jitteredTimestamps(
    numSamples: int,
    periodSeconds: real,
    jitterSeconds: real,
    seed: int = 0
  ): list(real) {
    var timestamps: list(real);

    if numSamples <= 0 then return timestamps;

    var timeSeconds: real = 0.0;
    timestamps.pushBack(timeSeconds);

    for i in 1..<numSamples {
      const raw = ((seed + i * 1103515245 + 12345) % 2001) - 1000;
      const deviation = jitterSeconds * raw: real / 1000.0;
      const intervalSeconds = max(0.0, periodSeconds + deviation);
      timeSeconds += intervalSeconds;
      timestamps.pushBack(timeSeconds);
    }

    return timestamps;
  }

  proc worstCase(samples: list(real)): real {
    if samples.size == 0 then return 0.0;

    var maximum = samples[0];
    for sample in samples do
      if sample > maximum then maximum = sample;

    return maximum;
  }

  proc maxAbsDeviation(samples: list(real), target: real): real {
    var maximum: real = 0.0;

    for sample in samples {
      const deviation = abs(sample - target);
      if deviation > maximum then maximum = deviation;
    }

    return maximum;
  }

  proc summarizeJitter(intervals: list(real), targetPeriodSeconds: real): TimingStats {
    var deviations: list(real);

    for intervalSeconds in intervals do
      deviations.pushBack(abs(intervalSeconds - targetPeriodSeconds));

    return summarizeSamples(deviations);
  }

  proc timingConforms(intervals: list(real), budget: TimingBudget): bool {
    if budget.targetPeriodSeconds < 0.0 then return false;
    if budget.maxJitterSeconds < 0.0 then return false;
    if budget.maxLatencySeconds < 0.0 then return false;

    if intervals.size == 0 then return true;

    return maxAbsDeviation(intervals, budget.targetPeriodSeconds) <= budget.maxJitterSeconds + 1e-12
        && worstCase(intervals) <= budget.maxLatencySeconds + 1e-12;
  }
}
