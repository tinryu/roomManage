// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get home => 'Trang chủ';

  @override
  String get users => 'Người dùng';

  @override
  String get tenants => 'Người thuê';

  @override
  String get resources => 'Kho';

  @override
  String get assets => 'Vật dụng';

  @override
  String get services => 'Dịch vụ';

  @override
  String get payment => 'Thanh toán';

  @override
  String get financeSumary => 'Tổng số liệu';

  @override
  String get rooms => 'Phòng';

  @override
  String get roomsManagement => 'Quảng lý phòng';

  @override
  String get hello => 'Xin chào';

  @override
  String welcome(Object userName) {
    return 'Chào mừng, $userName!';
  }

  @override
  String get activeUsers => 'Số người truy cập';

  @override
  String get totalRevenue => 'Tổng doanh thu';

  @override
  String get userManagement => 'Quản lý người dùng';

  @override
  String get manageUserProfile => 'Quản lý thông tin người dùng';

  @override
  String get trackResources => 'Theo dõi kho';
}
