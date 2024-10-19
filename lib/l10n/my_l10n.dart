import 'package:flutter/material.dart';

class MyL10n extends InheritedWidget {
  final Function(Locale) _localeChangeCallback;

  const MyL10n(
    this._localeChangeCallback,
    {super.key, 
      required super.child,
    }
  );

  static MyL10n? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyL10n>();
  }

  void changeLocale(Locale locale) {
    _localeChangeCallback.call(locale);
  }

  @override
  bool updateShouldNotify(MyL10n old) {
    return true;
  }
}