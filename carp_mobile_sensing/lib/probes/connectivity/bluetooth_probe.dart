/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of connectivity;

/// The [BluetoothProbe] scans for nearby and visible Bluetooth devices and collect
/// a [BluetoothDatum] for each. Uses a [PeriodicMeasure] for configuration the
/// [frequency] and [duration] of the scan.
class BluetoothProbe extends StreamProbe {
  /// Default timeout for bluetooth scan - 2 secs
  static const DEFAULT_TIMEOUT = 2 * 1000;

  FlutterBlue flutterBlue = FlutterBlue.instance;
  Duration frequency, duration;
  Timer timer;

  BluetoothProbe(PeriodicMeasure measure)
      : assert(measure != null),
        assert(measure.frequency != null, 'Measure frequency cannot be null for a BluetoothProbe.'),
        frequency = Duration(milliseconds: measure.frequency),
        duration = (measure.duration != null)
            ? Duration(milliseconds: measure.duration)
            : Duration(milliseconds: DEFAULT_TIMEOUT),
        super(measure);

  Stream<Datum> get stream => flutterBlue
      .scan(scanMode: ScanMode.lowLatency, timeout: duration)
      .map((result) => BluetoothDatum.fromScanResult(result));

  @override
  Future start() async {
    super.start();
    this.resume();
  }

  @override
  void resume() {
    // create a recurrent timer that resumes sampling every [frequency].
    timer = Timer.periodic(frequency, (Timer timer) {
      // starting the scanning event loop, will run the [timeout] duration
      subscription = stream.listen(onData, onError: onError);
    });
  }

  @override
  void pause() {
    if (subscription != null) subscription.cancel();
    subscription = null;
    timer.cancel();
  }

  // important that we don't propagate this up the chain, since this would close the overall stream
  @override
  void onDone() {}
}
