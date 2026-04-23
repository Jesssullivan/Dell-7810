// HostNumaProbe -- canonical Dell-7810 host NUMA and timing probe
//
// Run:
//   chpl examples/HostNumaProbe.chpl -M src -o /tmp/dell-7810-numa-demo
//   /tmp/dell-7810-numa-demo
//
// This is the canonical Dell-host example.
// `DualSocketDemo.chpl` remains only as a legacy compatibility shim because
// the older name also exists in XoxdWM.

use Time;
use HostNumaTiming;
use TimingProofs;

config const numChannels = 100;
config const numSamples = 250 * 10;
config const sampleRateHz = 250;
config const partitions = 2;

proc main() {
  const sublocaleCount = here._getChildCount();

  writeln("===============================================");
  writeln("Dell T7810 Host NUMA Probe");
  writeln("===============================================");
  writeln("Locales:    ", numLocales);
  writeln("Cores:      ", here.maxTaskPar, " per locale");
  writeln("Sublocales: ", sublocaleCount, " (locale children; flat locale model typically reports 0)");
  writeln("Channels:   ", numChannels);
  writeln("Samples:    ", numSamples, " (", numSamples / sampleRateHz, "s at ", sampleRateHz, " Hz)");
  writeln("");

  const parts = partitionChannels(numChannels, partitions);
  writeln("Channel partitions:");
  for i in 0..<parts.size do
    writeln("  part ", i, ": start=", parts[i].start, " count=", parts[i].count);
  writeln("");

  const periodSeconds = 1.0 / sampleRateHz: real;
  const syntheticTimestamps = exactPeriodicTimestamps(numSamples, periodSeconds);
  const syntheticIntervals = intervalsFromTimestamps(syntheticTimestamps);
  const timingBudget = new TimingBudget(
    targetPeriodSeconds = periodSeconds,
    maxJitterSeconds = 0.0,
    maxLatencySeconds = periodSeconds
  );
  const jitterStats = summarizeJitter(syntheticIntervals, periodSeconds);

  writeln("Timing proof surface:");
  writeln("  Period:   ", periodSeconds, "s");
  writeln("  Conforms: ", timingConforms(syntheticIntervals, timingBudget));
  writeln("  Jitter:   min=", jitterStats.minSeconds,
          " max=", jitterStats.maxSeconds,
          " mean=", jitterStats.meanSeconds);
  writeln("");

  writeln("Generating synthetic channel data...");
  var data: [0..<numChannels, 0..<numSamples] real;
  forall ch in 0..<numChannels {
    const signal = syntheticSignal(numSamples, ch);
    for s in 0..<numSamples do
      data[ch, s] = signal[s];
  }

  writeln("Computing serial reduction...");
  var serialTimer = new stopwatch();
  serialTimer.start();
  var serialTotal: real = 0.0;
  for ch in 0..<numChannels {
    for s in 0..<numSamples do
      serialTotal += abs(data[ch, s]);
  }
  serialTimer.stop();
  writeln("  Serial:   ", serialTimer.elapsed(), "s");

  writeln("Computing forall reduction...");
  var parallelTimer = new stopwatch();
  parallelTimer.start();
  var channelTotals: [0..<numChannels] real;
  forall ch in 0..<numChannels {
    var total: real = 0.0;
    for s in 0..<numSamples do
      total += abs(data[ch, s]);
    channelTotals[ch] = total;
  }

  var parallelTotal: real = 0.0;
  for total in channelTotals do
    parallelTotal += total;
  parallelTimer.stop();
  writeln("  Parallel: ", parallelTimer.elapsed(), "s");
  writeln("  Speedup:  ", serialTimer.elapsed() / parallelTimer.elapsed(), "x");
  writeln("  Delta:    ", abs(serialTotal - parallelTotal));
}
