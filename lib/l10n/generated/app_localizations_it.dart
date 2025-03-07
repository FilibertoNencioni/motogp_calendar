// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get races => 'Gare';

  @override
  String get settings => 'Impostazioni';

  @override
  String get changeAppLanguage => 'Cambia lingua applicazione';

  @override
  String get languageChanged => 'Lingua cambiata con successo';

  @override
  String get unexpectedError => 'Si è verificato un errore inaspettato, riprova più tardi';

  @override
  String get changeBroadcaster => 'Cambia emittente';

  @override
  String get changeDefaultBroadcasters => 'Cambia l\'emittente principale';

  @override
  String get broadcasterChanged => 'L\'emittente principale è stato cambiato con successo';

  @override
  String get broadcasterInfoText => 'L\'emittente selezionato sarà utilizzato come predefinito per il recupero degli orari delle varie gare.';

  @override
  String get selectBroadcaster => 'Seleziona un\'emittente';

  @override
  String get selectedBroadcaster => 'Emittente selezionato';

  @override
  String get getDismissedEvent => 'Mostra eventi cancellati';

  @override
  String get generalOptionChanged => 'Impostazioni cambiate con successo';

  @override
  String get finished => 'Finita';

  @override
  String get inProgress => 'In corso';

  @override
  String get thisWeek => 'Questa settimana';

  @override
  String get notStarted => 'Non iniziata';

  @override
  String get canceled => 'Cancellata';

  @override
  String get live => 'Live';

  @override
  String get delayed => 'Differita';
}
