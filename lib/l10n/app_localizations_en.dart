// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get users => 'Users';

  @override
  String get tenants => 'Tenants';

  @override
  String get resources => 'Resources';

  @override
  String get assets => 'Assets';

  @override
  String get services => 'Services';

  @override
  String get finance => 'Finance';

  @override
  String get financeSumary => 'Sumary finances';

  @override
  String get rooms => 'Rooms';

  @override
  String get roomsManagement => 'Management rooms';

  @override
  String get hello => 'Hello';

  @override
  String welcome(Object userName) {
    return 'Good morning, $userName!';
  }

  @override
  String get activeUsers => 'Active Users';

  @override
  String get totalRevenue => 'Total revenue';

  @override
  String get userManagement => 'User Management';

  @override
  String get manageUserProfile => 'Manage user profiles';

  @override
  String get trackResources => 'Track resources';
}
