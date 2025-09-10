import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:app_project/providers/settings_provider.dart';
import 'package:app_project/utils/localization_manager.dart';

String compactKMBSuffix(num n, String codeRegion) {
  double v = n.toDouble();
  String fmt(double x) => x.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '');
  if (v >= 1e12) {
    return '${fmt(v / 1e12)}${codeRegion == 'VND' ? 'ngàn tỷ' : 'T'}';
  }

  if (v >= 1e9) {
    return '${fmt(v / 1e9)}${codeRegion == 'VND' ? 'tỷ' : 'B'}';
  }

  if (v >= 1e6) {
    return '${fmt(v / 1e6)}${codeRegion == 'VND' ? 'triệu' : 'M'}';
  }

  if (v >= 1e3) {
    return '${fmt(v / 1e3)}${codeRegion == 'VND' ? 'ngàn' : 'K'}';
  }

  return v.toStringAsFixed(0);
}

/// Optional: extension usage like:  amount.toCompactKMB()
extension NumCompactFormatter on num {
  String toCompactKMB() => compactKMBSuffix(this, '');
}

/// Formatting helpers used across the app.
/// Place all number/date formatting utilities here for reuse.

/// Converts a number to a compact string with K/M/B/T suffixes.
/// Examples:
///  - 1_200 -> 1.2K
///  - 500_000_000 -> 500M
///  - 1_000_000_000 -> 1B

/// Formats a DateTime using the app's global date format pattern.
/// If [pattern] is provided, it will override the global pattern.
/// If neither is available, defaults to 'yyyy-MM-dd'.
String appFormatDate(BuildContext context, DateTime dt, {String? pattern}) {
  try {
    final container = ProviderScope.containerOf(context, listen: false);
    final settings = container.read(settingsProvider).valueOrNull;
    final locale = Localizations.localeOf(context);
    final pat =
        pattern ??
        settings?.dateFormatPattern ??
        LocalizationManager.local.defaultDateFormat;

    return DateFormat(pat, locale.languageCode).format(dt);
  } catch (_) {
    // Fallback when container/provider not available
    return DateFormat(pattern ?? 'yyyy-MM-dd', 'en').format(dt);
  }
}

/// Formats amount using compact K/M/B/T suffix together with currency symbol.
/// Examples: $1.2K, €950, ₫120K
/// Uses app currency setting unless [code] overrides it.
String appFormatCurrencyCompact(
  BuildContext context,
  num amount, {
  String? code,
}) {
  try {
    final container = ProviderScope.containerOf(context, listen: false);
    final settings = container.read(settingsProvider).valueOrNull;
    final resolvedCode = (code ?? settings?.currencyCode ?? 'VND')
        .toUpperCase();
    final symbol = currencySymbolFor(resolvedCode);
    if (resolvedCode == 'VND') {
      return '${compactKMBSuffix(amount, resolvedCode)} $symbol';
    }
    return '$symbol ${compactKMBSuffix(amount, resolvedCode)}';
  } catch (_) {
    final resolvedCode = (code ?? 'VND').toUpperCase();
    final symbol = currencySymbolFor(resolvedCode);
    if (resolvedCode == 'VND') {
      return '${compactKMBSuffix(amount, resolvedCode)} $symbol';
    }
    return '$symbol ${compactKMBSuffix(amount, resolvedCode)}';
  }
}

/// Returns a symbol for a given currency code. Defaults to code if symbol unknown.
String currencySymbolFor(String code) {
  switch (code.toUpperCase()) {
    case 'USD':
      return r'$';
    case 'EUR':
      return '€';
    case 'JPY':
      return '¥';
    case 'VND':
      return 'đ';
    case 'GBP':
      return '£';
    case 'AUD':
      return r'A$';
    case 'CAD':
      return r'C$';
    default:
      return code.toUpperCase();
  }
}

/// Formats a numeric amount using the app's currency settings.
/// If [code] is provided, it overrides the app setting.
/// Zero decimals for JPY/VND, two for most others by default.
String appFormatCurrency(
  BuildContext context,
  num amount, {
  String? code,
  int? decimalDigits,
}) {
  try {
    final container = ProviderScope.containerOf(context, listen: false);
    final settings = container.read(settingsProvider).valueOrNull;
    final resolvedCode = (code ?? settings?.currencyCode ?? 'VND')
        .toUpperCase();
    final symbol = currencySymbolFor(resolvedCode);
    final digits =
        decimalDigits ??
        (resolvedCode == 'JPY' || resolvedCode == 'VND' ? 0 : 2);
    final nf = NumberFormat.currency(symbol: symbol, decimalDigits: digits);
    return nf.format(amount);
  } catch (_) {
    final resolvedCode = (code ?? 'VND').toUpperCase();
    final symbol = currencySymbolFor(resolvedCode);
    final digits =
        decimalDigits ??
        (resolvedCode == 'JPY' || resolvedCode == 'VND' ? 0 : 2);
    final nf = NumberFormat.currency(symbol: symbol, decimalDigits: digits);
    return nf.format(amount);
  }
}
