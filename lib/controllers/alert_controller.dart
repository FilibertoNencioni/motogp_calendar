import 'dart:async';
import 'package:motogp_calendar/utils/types/alert_options.dart';

class AlertController {
  static final AlertController _instance = AlertController._internal();  
  factory AlertController() =>_instance;
  AlertController._internal(); 

  /// Indicates when the controller is ready to be used (The Alert widget is mounted)
  final Completer<void> _readyCompleter = Completer<void>();

  /// The alert details, if null no alert to show
  AlertOptions? _options;

  /// Callback to update the Alert widget
  Function(AlertOptions?)? onUpdate;

  /// Timer to hide the alert after a certain duration (specified in the options)
  Timer? _hideTimer;

  AlertOptions? get alertOptions => _options;

  /// Hide the alert
  void hide() async {
    _options = null;
    await _readyCompleter.future;
    if (_readyCompleter.isCompleted) {
      onUpdate!(null);
    }
  }

  /// Show the alert with the provided [options]
  void show(AlertOptions options) async {
    _options = options;
    await _readyCompleter.future;

    if (_readyCompleter.isCompleted) {
      _resetHideTimer(options.duration);
      onUpdate!(options);
    }
  }

  /// Reset the hide timer
  void _resetHideTimer(Duration duration) {
    // Cancel any existing timer
    _hideTimer?.cancel();
    
    // Start a new timer to hide the alert after the specified duration
    _hideTimer = Timer(duration, () => onUpdate!(null));
  }

  /// Sets the Alert redy to use.
  /// Also register the Alert [callback] to interact with the widget.
  void init(Function(AlertOptions?) callback) {
    if (!_readyCompleter.isCompleted) {
      _readyCompleter.complete();
    }
    onUpdate = callback;
  }

}