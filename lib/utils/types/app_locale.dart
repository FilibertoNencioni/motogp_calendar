import 'dart:ui';

class AppLocale{
  String displayName;
  String code;

  AppLocale({
    required this.displayName,
    required this.code,
  });

  Locale get locale=> Locale(code);
}