import 'package:motogp_calendar/utils/enum/e_alert_status.dart';

class AlertOptions {
  /// Alert status
  EAlertStatus status;

  /// Alert title
  String title;

  /// Alert message
  String? message;

  /// Duration of the alert (default: 5 seconds)
  Duration duration;

  AlertOptions({
    required this.status,
    required this.title,
    this.message,
    this.duration = const Duration(seconds: 5),
  });

}