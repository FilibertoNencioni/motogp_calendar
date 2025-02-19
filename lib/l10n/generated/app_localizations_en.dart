// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get races => 'Races';

  @override
  String get settings => 'Settings';

  @override
  String get changeAppLanguage => 'Change app language';

  @override
  String get languageChanged => 'App language changed successfully';

  @override
  String get unexpectedError => 'An unexpected error has occurred, please try again later';

  @override
  String get changeDefaultBroadcasters => 'Change the default broadcaster';

  @override
  String get broadcasterChanged => 'The default broadcaster has been changed';

  @override
  String get broadcasterInfoText => 'The selected broadcaster will be used as the default for retrieving the schedules of the various races.';

  @override
  String get selectedBroadcaster => 'Selected broadcaster';

  @override
  String get getDismissedEvent => 'Show cancelled events';

  @override
  String get generalOptionChanged => 'Settings changed successfully';

  @override
  String get finished => 'Finished';

  @override
  String get inProgress => 'In progress';

  @override
  String get thisWeek => 'This week';

  @override
  String get notStarted => 'Not started';

  @override
  String get canceled => 'Canceled';

  @override
  String get live => 'Live';

  @override
  String get delayed => 'Delayed';
}
