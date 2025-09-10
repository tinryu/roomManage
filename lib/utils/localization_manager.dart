import 'package:flutter/material.dart';
import 'package:app_project/l10n/app_localizations.dart';

class LocalizationManager {
  static LocalizationManager? _instance;
  static AppLocalizations? _localizations;

  static LocalizationManager get instance {
    _instance ??= LocalizationManager();
    return _instance!;
  }

  static void initialize(BuildContext context) {
    _localizations = AppLocalizations.of(context);
  }

  static AppLocalizations get local {
    if (_localizations == null) {
      throw Exception('LocalizationManager not initialized');
    }
    return _localizations!;
  }
}
