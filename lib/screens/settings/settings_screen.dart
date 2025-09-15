import 'package:app_project/screens/tenants/profile_detail_screen.dart';
import 'package:app_project/utils/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_project/screens/tenants/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_project/providers/settings_provider.dart';
import 'package:app_project/utils/format.dart';
import 'package:provider/provider.dart' as p;
import 'package:app_project/providers/dashboard_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  final void Function(Locale locale) onLocaleChange;
  final void Function(ThemeMode mode)? onThemeChange;
  final ThemeMode? currentThemeMode;
  const SettingsScreen({
    super.key,
    required this.onLocaleChange,
    this.onThemeChange,
    this.currentThemeMode,
  });

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late Locale _currentLocale;
  late ThemeMode _themeMode;
  late bool _hasUnsavedChanges = false;
  late String _currentCurrency;
  late String _currentDateFormat;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = ref.read(settingsProvider).valueOrNull;
    _currentLocale = Localizations.localeOf(context);
    _themeMode = widget.currentThemeMode ?? ThemeMode.light;
    _currentCurrency = settings?.currencyCode ?? 'VND';
    _currentDateFormat = settings?.dateFormatPattern ?? 'yyyy-MM-dd';
  }

  // Add this method to handle save changes
  Future<void> _saveChanges() async {
    final dp = p.Provider.of<DashboardProvider>(context, listen: false);
    try {
      // Save locale
      widget.onLocaleChange(_currentLocale);

      // Save theme
      widget.onThemeChange?.call(_themeMode);

      // Save currency and date format
      await ref
          .read(settingsProvider.notifier)
          .setCurrencyCode(_currentCurrency);
      await ref
          .read(settingsProvider.notifier)
          .setDateFormatPattern(_currentDateFormat);

      // Refresh dashboard data

      await dp.fetchDashboard();

      // Reset the changes flag
      setState(() {
        _hasUnsavedChanges = false;
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocalizationManager.local.settingsSaved)),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocalizationManager.local.errorSavingSettings),
          ),
        );
      }
    }
  }

  Future<void> _pickCurrency() async {
    // Common currency options (symbol will be resolved by currencySymbolFor)
    final options = <String>['VND', 'USD', 'EUR', 'JPY'];

    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: options.map((code) {
              final settings = ref.watch(settingsProvider).valueOrNull;
              final selected = (settings?.currencyCode ?? 'VND') == code;
              final symbol = currencySymbolFor(code);
              // Example amount preview using centralized formatter
              final preview = appFormatCurrency(context, 2500000, code: code);

              return ListTile(
                leading: Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: selected ? Colors.lightBlue : null,
                ),
                title: Text(
                  '$code ($symbol) ',
                  textScaler: TextScaler.linear(0.8),
                ),
                subtitle: Text(
                  preview,
                  style: TextStyle(color: Colors.grey),
                  textScaler: TextScaler.linear(0.8),
                ),
                onTap: () async {
                  setState(() {
                    _currentCurrency = code;
                    _hasUnsavedChanges = true;
                  });
                  await ref
                      .read(settingsProvider.notifier)
                      .setCurrencyCode(code);
                  // ignore: use_build_context_synchronously
                  if (mounted) Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _pickTheme() async {
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _themeTile('Light', ThemeMode.light),
              _themeTile('Dark', ThemeMode.dark),
              _themeTile('System', ThemeMode.system),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _themeTile(String label, ThemeMode mode) {
    final selected = _themeMode == mode;
    return ListTile(
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: selected ? Colors.lightBlue : null,
      ),
      title: Text(label, textScaler: TextScaler.linear(0.8)),
      onTap: () {
        setState(() {
          _themeMode = mode;
          _hasUnsavedChanges = true;
        });
        widget.onThemeChange?.call(mode);
        Navigator.pop(context);
      },
    );
  }

  Future<void> _pickLanguage() async {
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: Text('English (EN)', textScaler: TextScaler.linear(0.8)),
                trailing: _currentLocale.languageCode == 'en'
                    ? const Icon(Icons.check, color: Colors.lightBlue)
                    : null,
                onTap: () {
                  widget.onLocaleChange(const Locale('en'));
                  setState(() {
                    _currentLocale = const Locale('en');
                    _hasUnsavedChanges = true;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(
                  'Tiếng Việt (VI)',
                  textScaler: TextScaler.linear(0.8),
                ),
                trailing: _currentLocale.languageCode == 'vi'
                    ? const Icon(Icons.check, color: Colors.lightBlue)
                    : null,
                onTap: () {
                  widget.onLocaleChange(const Locale('vi'));
                  setState(() {
                    _currentLocale = const Locale('vi');
                    _hasUnsavedChanges = true;
                  });
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Future<void> _signOut() async {
    await Supabase.instance.client.auth.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _pickDateFormat() async {
    // Candidate patterns; preview computed via appFormatDate to reflect app's logic
    final patterns = <String>[
      'yyyy-MM-dd',
      'dd/MM/yyyy',
      'MM-dd-yyyy',
      'MMM d, y',
      'yyyy-MM-dd HH:mm',
    ];

    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: patterns.map((pattern) {
              final preview = appFormatDate(
                context,
                DateTime.now(),
                pattern: pattern,
              );
              final currentPattern =
                  ref.read(settingsProvider).valueOrNull?.dateFormatPattern ??
                  'yyyy-MM-dd';
              final selected = currentPattern == pattern;
              return ListTile(
                leading: Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: selected ? Colors.lightBlue : null,
                ),
                title: Text(pattern, textScaler: TextScaler.linear(0.8)),
                subtitle: Text(preview, textScaler: TextScaler.linear(0.8)),
                onTap: () async {
                  setState(() {
                    _currentDateFormat = pattern;
                    _hasUnsavedChanges = true;
                  });
                  await ref
                      .read(settingsProvider.notifier)
                      .setDateFormatPattern(pattern);
                  // ignore: use_build_context_synchronously
                  if (mounted) Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final settings = settingsAsync.valueOrNull;
    // ignore: deprecated_member_use
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          centerTitle: true,
          actions: [
            if (_hasUnsavedChanges)
              TextButton(
                onPressed: _saveChanges,
                child: Text(
                  LocalizationManager.local.save,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            // General
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text('Language', textScaler: TextScaler.linear(0.8)),
                    subtitle: Text(_currentLocale.languageCode.toUpperCase()),
                    onTap: _pickLanguage,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.brightness_6_outlined),
                    title: Text('Theme', textScaler: TextScaler.linear(0.8)),
                    subtitle: Text(_themeMode.name),
                    onTap: _pickTheme,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.calendar_today_outlined),
                    title: Text(
                      'Date format',
                      textScaler: TextScaler.linear(0.8),
                    ),
                    subtitle: Text(appFormatDate(context, DateTime.now())),
                    onTap: _pickDateFormat,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.monetization_on_outlined),
                    title: Text('Currency', textScaler: TextScaler.linear(0.8)),
                    subtitle: Text(
                      settings?.currencyCode ?? 'VND',
                      textScaler: TextScaler.linear(0.8),
                    ),
                    onTap: _pickCurrency,
                  ),
                ],
              ),
            ),

            // Notifications
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    value: true,
                    onChanged: (val) {}, // placeholder
                    title: Text(
                      LocalizationManager.local.paymentReminder,
                      textScaler: TextScaler.linear(0.8),
                    ),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: true,
                    onChanged: (val) {}, // placeholder
                    title: Text(
                      LocalizationManager.local.tasksReminder,
                      textScaler: TextScaler.linear(0.8),
                    ),
                  ),
                ],
              ),
            ),

            // Account
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.person_outline),
                    title: Text(
                      LocalizationManager.local.profile,
                      textScaler: TextScaler.linear(0.8),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileDetailScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: Text(
                      LocalizationManager.local.logout,
                      style: TextStyle(color: Colors.red),
                      textScaler: TextScaler.linear(0.8),
                    ),
                    onTap: _signOut,
                  ),
                ],
              ),
            ),

            // About
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About', textScaler: TextScaler.linear(0.8)),
                subtitle: const Text(
                  'Room Manager • v1.0.0',
                  textScaler: TextScaler.linear(0.8),
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
      onWillPop: () async {
        if (_hasUnsavedChanges) {
          final shouldDiscard = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Unsaved Changes'),
              content: Text(
                'You have unsaved changes. Discard them and leave?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('discard'),
                ),
              ],
            ),
          );
          return shouldDiscard ?? false;
        }
        return true;
      },
    );
  }
}
