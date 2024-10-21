import 'dart:async';

import 'package:motogp_calendar/utils/types/alert_options.dart';

// The service that manages the alert
class AlertService {
  static final AlertService _instance = AlertService._internal();
  
  factory AlertService() {
    return _instance;
  }
  
  AlertService._internal(); // Private constructor

  AlertOptions? _alertOptions;
  Function(AlertOptions?)? onUpdate;
  Timer? _hideTimer;

  AlertOptions? get alertOptions => _alertOptions;

  void hideAlert() {
    _alertOptions = null;
    if (onUpdate != null) {
      onUpdate!(null); // Trigger the callback to update the widget
    }
  }

  void showAlert(AlertOptions options) {
    _alertOptions = options;
    _resetHideTimer(); // Start the hide timer based on the new options
    if (onUpdate != null) {
      onUpdate!(options); // Trigger the callback to update the widget
    }
  }

  void _resetHideTimer() {
    // Cancel any existing timer
    _hideTimer?.cancel();
    
    // Start a new timer to hide the alert after the specified duration
    if (_alertOptions != null) {
      _hideTimer = Timer(_alertOptions!.duration, () {
        onUpdate!(null);
      });
    }
  }

  // Register the callback
  void registerOnUpdate(Function(AlertOptions?) callback) {
    onUpdate = callback;
  }

}