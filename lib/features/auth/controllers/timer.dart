import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerNotifier extends StateNotifier<int?> {
  TimerNotifier() : super(null);
  Timer? _timer;

  void startTimer() {
    // Set the initial countdown time to 30 seconds
    state = 60;

    // Clear any existing timer
    _timer?.cancel();

    // Start the countdown
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (state == 1) {
        // Stop the timer when it reaches zero
        timer.cancel();
        state = null; // Set to null to indicate the timer is inactive
      } else {
        state = state! - 1;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, int?>((ref) {
  return TimerNotifier();
});
