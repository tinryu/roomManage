import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final String dateFormatPattern;
  final String currencyCode;

  const SettingsState({
    this.dateFormatPattern = 'yyyy-MM-dd',
    this.currencyCode = 'VND',
  });

  SettingsState copyWith({String? dateFormatPattern, String? currencyCode}) {
    return SettingsState(
      dateFormatPattern: dateFormatPattern ?? this.dateFormatPattern,
      currencyCode: currencyCode ?? this.currencyCode,
    );
  }
}

class SettingsNotifier extends AsyncNotifier<SettingsState> {
  static const _kDateFormatKey = 'settings.date_format_pattern';
  static const _kCurrencyCodeKey = 'settings.currency_code';

  SharedPreferences? _prefs;

  @override
  Future<SettingsState> build() async {
    _prefs = await SharedPreferences.getInstance();
    final pattern = _prefs!.getString(_kDateFormatKey) ?? 'yyyy-MM-dd';
    final currency = _prefs!.getString(_kCurrencyCodeKey) ?? 'VND';
    return SettingsState(dateFormatPattern: pattern, currencyCode: currency);
  }

  Future<void> setDateFormatPattern(String pattern) async {
    final current = state.value ?? const SettingsState();
    state = AsyncData(current.copyWith(dateFormatPattern: pattern));
    await _prefs?.setString(_kDateFormatKey, pattern);
  }

  Future<void> setCurrencyCode(String code) async {
    final current = state.value ?? const SettingsState();
    state = AsyncData(current.copyWith(currencyCode: code));
    await _prefs?.setString(_kCurrencyCodeKey, code);
  }
}

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);
