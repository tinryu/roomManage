// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Quản lý Phòng';

  @override
  String get save => 'Lưu';

  @override
  String get cancel => 'Hủy';

  @override
  String get delete => 'Xóa';

  @override
  String get edit => 'Sửa';

  @override
  String get add => 'Thêm';

  @override
  String get search => 'Tìm kiếm';

  @override
  String get loading => 'Đang tải...';

  @override
  String get loadMore => 'Tải thêm';

  @override
  String get error => 'Lỗi';

  @override
  String get success => 'Thành công';

  @override
  String get retry => 'Thử lại';

  @override
  String get back => 'Quay lại';

  @override
  String get next => 'Tiếp theo';

  @override
  String get done => 'Xong';

  @override
  String get nope => 'Chưa';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get select => 'Chọn';

  @override
  String get selectImage => 'Chọn ảnh';

  @override
  String get selectExactlyOne => 'Chọn chính xác item';

  @override
  String get takePhoto => 'Chụp ảnh';

  @override
  String get chooseFromGallery => 'Chọn từ thư viện';

  @override
  String get noData => 'Không có dữ liệu';

  @override
  String get unknownError => 'Đã xảy ra lỗi không xác định';

  @override
  String get noInternet => 'Không có kết nối mạng';

  @override
  String get tryAgain => 'Vui lòng thử lại';

  @override
  String get requiredField => 'Trường bắt buộc';

  @override
  String get invalidEmail => 'Email không hợp lệ';

  @override
  String get invalidPhone => 'Số điện thoại không hợp lệ';

  @override
  String get invalidNumber => 'Số không hợp lệ';

  @override
  String get deleteFailed => 'Xóa thất bại';

  @override
  String get defaultDateFormat => 'dd/MM/yyyy';

  @override
  String get settingsSaved => 'Settings saved successfully';

  @override
  String get errorSavingSettings => 'Error saving settings';

  @override
  String get saveChanges => 'Lưu thay đổi';

  @override
  String get home => 'Trang chủ';

  @override
  String get dashboard => 'Bảng điều khiển';

  @override
  String get users => 'Người dùng';

  @override
  String get tenants => 'Người thuê';

  @override
  String get resources => 'Kho';

  @override
  String get assets => 'Tài sản';

  @override
  String get services => 'Dịch vụ';

  @override
  String get payments => 'Thanh toán';

  @override
  String get financeSummary => 'Tổng quan tài chính';

  @override
  String get rooms => 'Phòng';

  @override
  String get tasks => 'Công việc';

  @override
  String get upcomingTask => 'Công việc sắp tới';

  @override
  String get noTask => 'Không có task';

  @override
  String get reports => 'Báo cáo';

  @override
  String get settings => 'Cài đặt';

  @override
  String get profile => 'Hồ sơ';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get login => 'Đăng nhập';

  @override
  String get register => 'Đăng ký';

  @override
  String get forgotPassword => 'Quên mật khẩu?';

  @override
  String get dontHaveAccount => 'Chưa có tài khoản? ';

  @override
  String get alreadyHaveAccount => 'Đã có tài khoản? ';

  @override
  String get signUp => 'Đăng ký';

  @override
  String get signIn => 'Đăng nhập';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mật khẩu';

  @override
  String get confirmPassword => 'Xác nhận mật khẩu';

  @override
  String get fullName => 'Họ và tên';

  @override
  String get phoneNumber => 'Số điện thoại';

  @override
  String get loginSuccess => 'Đăng nhập thành công';

  @override
  String get registerSuccess => 'Đăng ký thành công';

  @override
  String get loginError => 'Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin.';

  @override
  String get registerError => 'Đăng ký thất bại. Vui lòng thử lại.';

  @override
  String get passwordNotMatch => 'Mật khẩu không khớp';

  @override
  String get forgotPasswordMessage => 'Nhập email để đặt lại mật khẩu';

  @override
  String get resetPassword => 'Đặt lại mật khẩu';

  @override
  String get resetPasswordSuccess => 'Đã gửi liên kết đặt lại mật khẩu';

  @override
  String get resetPasswordError => 'Gửi email đặt lại thất bại';

  @override
  String welcome(Object userName) {
    return 'Chào mừng, $userName!';
  }

  @override
  String get goodMorning => 'Chào buổi sáng';

  @override
  String get goodAfternoon => 'Chào buổi chiều';

  @override
  String get goodEvening => 'Chào buổi tối';

  @override
  String get today => 'Hôm nay';

  @override
  String get thisWeek => 'Tuần này';

  @override
  String get thisMonth => 'Tháng này';

  @override
  String get totalRooms => 'Tổng số phòng';

  @override
  String get occupiedRooms => 'Phòng đã thuê';

  @override
  String get availableRooms => 'Phòng trống';

  @override
  String get totalTenants => 'Tổng người thuê';

  @override
  String get activeTenants => 'Người thuê hiện tại';

  @override
  String get totalIncome => 'Tổng thu nhập';

  @override
  String get totalExpenses => 'Tổng chi phí';

  @override
  String get recentIncome => 'Lợi nhuận hiện tại';

  @override
  String get recentActivities => 'Hoạt động gần đây';

  @override
  String get viewAll => 'Xem tất cả';

  @override
  String get selectAll => 'Chọn tất cả';

  @override
  String get upcomingPayments => 'Khoản thanh toán sắp đến';

  @override
  String get overduePayments => 'Khoản thanh toán quá hạn';

  @override
  String get paid => 'Đã thanh toán';

  @override
  String get unpaid => 'Chưa thanh toán';

  @override
  String get overdue => 'Quá hạn';

  @override
  String get dueDate => 'Ngày đến hạn';

  @override
  String get amount => 'Số tiền';

  @override
  String get status => 'Trạng thái';

  @override
  String get action => 'Thao tác';

  @override
  String get noRecentActivities => 'Không có hoạt động gần đây';

  @override
  String get noUpcomingPayments => 'Không có khoản thanh toán sắp đến';

  @override
  String get noOverduePayments => 'Không có khoản thanh toán quá hạn';

  @override
  String get todayRevenue => 'Doanh thu ngày';

  @override
  String get checkInToday => 'Check-in ngày';

  @override
  String get occupancyRate => 'Tỷ lệ đầy';

  @override
  String get waitingDamaged => 'Chờ sửa';

  @override
  String get room => 'Phòng';

  @override
  String get roomName => 'Tên phòng';

  @override
  String get roomNumber => 'Số phòng';

  @override
  String get roomType => 'Loại phòng';

  @override
  String get roomStatus => 'Trạng thái phòng';

  @override
  String get roomStatusAvailable => 'Còn trống';

  @override
  String get roomStatusOccupied => 'Đã thuê';

  @override
  String get roomStatusVacant => 'Chưa thuê';

  @override
  String get roomStatusMaintenance => 'Đang bảo trì';

  @override
  String get roomStatusReserved => 'Đã đặt trước';

  @override
  String get roomDetails => 'Chi tiết phòng';

  @override
  String get roomInformation => 'Thông tin phòng';

  @override
  String get roomFeatures => 'Tiện ích phòng';

  @override
  String get roomSize => 'Diện tích';

  @override
  String get roomFloor => 'Tầng';

  @override
  String get roomCapacity => 'Sức chứa';

  @override
  String get roomPrice => 'Giá phòng';

  @override
  String get roomDescription => 'Mô tả';

  @override
  String get addRoom => 'Thêm phòng';

  @override
  String get editRoom => 'Sửa phòng';

  @override
  String get deleteRoom => 'Xóa phòng';

  @override
  String get deleteRoomConfirm => 'Bạn có chắc chắn muốn xóa phòng này?';

  @override
  String get roomAddSuccess => 'Thêm phòng thành công';

  @override
  String get roomUpdateSuccess => 'Cập nhật phòng thành công';

  @override
  String get roomDeleteSuccess => 'Xóa phòng thành công';

  @override
  String get noRoomsFound => 'Không tìm thấy phòng nào';

  @override
  String get tenant => 'Người thuê';

  @override
  String get tenantName => 'Tên người thuê';

  @override
  String get tenantPhone => 'Số điện thoại';

  @override
  String get tenantEmail => 'Email';

  @override
  String get tenantAddress => 'Địa chỉ';

  @override
  String get tenantIdNumber => 'Số CMND/CCCD';

  @override
  String get tenantEmergencyContact => 'Liên hệ khẩn cấp';

  @override
  String get tenantOccupation => 'Nghề nghiệp';

  @override
  String get tenantCompany => 'Công ty';

  @override
  String get tenantNotes => 'Ghi chú';

  @override
  String get tenantCheckInDate => 'Ngày nhận phòng';

  @override
  String get tenantCheckOutDate => 'Ngày trả phòng';

  @override
  String get tenantLeaseStart => 'Bắt đầu hợp đồng';

  @override
  String get tenantLeaseEnd => 'Kết thúc hợp đồng';

  @override
  String get tenantRentAmount => 'Tiền thuê';

  @override
  String get tenantRentDueDay => 'Ngày đóng tiền';

  @override
  String get tenantSecurityDeposit => 'Tiền đặt cọc';

  @override
  String get tenantStatus => 'Trạng thái';

  @override
  String get tenantStatusActive => 'Đang thuê';

  @override
  String get tenantStatusInactive => 'Ngừng thuê';

  @override
  String get tenantStatusOverdue => 'Quá hạn thanh toán';

  @override
  String get tenantStatusEvicted => 'Đã trục xuất';

  @override
  String get tenantStatusMovedOut => 'Đã chuyển đi';

  @override
  String get addTenant => 'Thêm người thuê';

  @override
  String get editTenant => 'Sửa thông tin';

  @override
  String get deleteTenant => 'Xóa người thuê';

  @override
  String get deleteTenantConfirm => 'Bạn có chắc chắn muốn xóa người thuê này?';

  @override
  String get tenantAddSuccess => 'Thêm người thuê thành công';

  @override
  String get tenantUpdateSuccess => 'Cập nhật thông tin thành công';

  @override
  String get tenantDeleteSuccess => 'Xóa người thuê thành công';

  @override
  String get noTenantsFound => 'Không tìm thấy người thuê nào';

  @override
  String get tenantDetails => 'Chi tiết người thuê';

  @override
  String get tenantInformation => 'Thông tin người thuê';

  @override
  String get tenantDocuments => 'Tài liệu';

  @override
  String get tenantPayments => 'Thanh toán';

  @override
  String get tenantMaintenanceRequests => 'Yêu cầu sửa chữa';

  @override
  String get tenantNotesAndHistory => 'Ghi chú và lịch sử';

  @override
  String get uploadDocument => 'Tải lên tài liệu';

  @override
  String get documentType => 'Loại tài liệu';

  @override
  String get documentName => 'Tên tài liệu';

  @override
  String get documentUploadDate => 'Ngày tải lên';

  @override
  String get noDocuments => 'Không có tài liệu nào';

  @override
  String get addDocument => 'Thêm tài liệu';

  @override
  String get documentAddSuccess => 'Thêm tài liệu thành công';

  @override
  String get documentDeleteSuccess => 'Xóa tài liệu thành công';

  @override
  String get documentDeleteConfirm => 'Bạn có chắc chắn muốn xóa tài liệu này?';

  @override
  String get asset => 'Tài sản';

  @override
  String get assetName => 'Tên tài sản';

  @override
  String get assetCategory => 'Danh mục';

  @override
  String get assetCondition => 'Tình trạng';

  @override
  String get assetStatus => 'Trạng thái';

  @override
  String get assetPurchaseDate => 'Ngày mua';

  @override
  String get assetPurchasePrice => 'Giá mua';

  @override
  String get assetSerialNumber => 'Số sê-ri';

  @override
  String get assetModel => 'Mẫu';

  @override
  String get assetBrand => 'Thương hiệu';

  @override
  String get assetSupplier => 'Nhà cung cấp';

  @override
  String get assetWarrantyExpiry => 'Hết hạn bảo hành';

  @override
  String get assetLocation => 'Vị trí';

  @override
  String get assetAssignedTo => 'Giao cho';

  @override
  String get assetNotes => 'Ghi chú';

  @override
  String get assetConditionNew => 'Mới';

  @override
  String get assetConditionGood => 'Tốt';

  @override
  String get assetConditionFair => 'Khá';

  @override
  String get assetConditionPoor => 'Kém';

  @override
  String get assetConditionDamaged => 'Hỏng';

  @override
  String get assetStatusAvailable => 'Có sẵn';

  @override
  String get assetStatusInUse => 'Đang sử dụng';

  @override
  String get assetStatusMaintenance => 'Đang bảo trì';

  @override
  String get assetStatusDisposed => 'Đã thanh lý';

  @override
  String get assetStatusLost => 'Đã mất';

  @override
  String get addAsset => 'Thêm tài sản';

  @override
  String get editAsset => 'Sửa tài sản';

  @override
  String get deleteAsset => 'Xóa tài sản';

  @override
  String get deleteAssetConfirm => 'Bạn có chắc chắn muốn xóa tài sản này?';

  @override
  String get assetAddSuccess => 'Thêm tài sản thành công';

  @override
  String get assetUpdateSuccess => 'Cập nhật tài sản thành công';

  @override
  String get assetDeleteSuccess => 'Xóa tài sản thành công';

  @override
  String get noAssetsFound => 'Không tìm thấy tài sản nào';

  @override
  String get assetDetails => 'Chi tiết tài sản';

  @override
  String get assetInformation => 'Thông tin tài sản';

  @override
  String get assetMaintenanceHistory => 'Lịch sử bảo trì';

  @override
  String get assetDepreciation => 'Khấu hao';

  @override
  String get assetValue => 'Giá trị hiện tại';

  @override
  String get assetPurchaseInfo => 'Thông tin mua hàng';

  @override
  String get assetWarrantyInfo => 'Thông tin bảo hành';

  @override
  String get assetLocationInfo => 'Thông tin vị trí';

  @override
  String get assetAssignmentHistory => 'Lịch sử giao nhận';

  @override
  String get assignAsset => 'Giao tài sản';

  @override
  String get unassignAsset => 'Hủy giao tài sản';

  @override
  String get assetAssignmentSuccess => 'Giao tài sản thành công';

  @override
  String get assetUnassignmentSuccess => 'Hủy giao tài sản thành công';

  @override
  String get scheduleMaintenance => 'Lên lịch bảo trì';

  @override
  String get maintenanceScheduled => 'Đã lên lịch bảo trì';

  @override
  String get maintenanceCompleted => 'Đã hoàn thành bảo trì';

  @override
  String get maintenanceCancelled => 'Đã hủy bảo trì';

  @override
  String get maintenanceHistory => 'Lịch sử bảo trì';

  @override
  String get noMaintenanceHistory => 'Không có lịch sử bảo trì';

  @override
  String get maintenanceType => 'Loại bảo trì';

  @override
  String get maintenanceDate => 'Ngày bảo trì';

  @override
  String get maintenanceCost => 'Chi phí';

  @override
  String get maintenanceDescription => 'Mô tả';

  @override
  String get maintenanceTechnician => 'Kỹ thuật viên';

  @override
  String get maintenanceStatus => 'Trạng thái';

  @override
  String get maintenanceStatusScheduled => 'Đã lên lịch';

  @override
  String get maintenanceStatusInProgress => 'Đang thực hiện';

  @override
  String get maintenanceStatusCompleted => 'Hoàn thành';

  @override
  String get maintenanceStatusCancelled => 'Đã hủy';

  @override
  String get addMaintenanceRecord => 'Thêm bản ghi bảo trì';

  @override
  String get editMaintenanceRecord => 'Sửa bản ghi bảo trì';

  @override
  String get deleteMaintenanceRecord => 'Xóa bản ghi bảo trì';

  @override
  String get deleteMaintenanceRecordConfirm => 'Bạn có chắc chắn muốn xóa bản ghi bảo trì này?';

  @override
  String get maintenanceRecordAddSuccess => 'Thêm bản ghi bảo trì thành công';

  @override
  String get maintenanceRecordUpdateSuccess => 'Cập nhật bản ghi bảo trì thành công';

  @override
  String get maintenanceRecordDeleteSuccess => 'Xóa bản ghi bảo trì thành công';

  @override
  String get payment => 'Thanh toán';

  @override
  String get paymentAmount => 'Số tiền';

  @override
  String get paymentDate => 'Ngày thanh toán';

  @override
  String get paymentMethod => 'Phương thức thanh toán';

  @override
  String get paymentStatus => 'Trạng thái';

  @override
  String get paymentReference => 'Mã tham chiếu';

  @override
  String get paymentNotes => 'Ghi chú';

  @override
  String get paymentFor => 'Thanh toán cho';

  @override
  String get paymentType => 'Loại thanh toán';

  @override
  String get paymentReceivedBy => 'Người nhận';

  @override
  String get paymentReceivedFrom => 'Người thanh toán';

  @override
  String get paymentStatusPaid => 'Đã thanh toán';

  @override
  String get paymentStatusUnpaid => 'Chưa thanh toán';

  @override
  String get paymentStatusOverdue => 'Quá hạn';

  @override
  String get paymentStatusPartial => 'Thanh toán một phần';

  @override
  String get paymentStatusRefunded => 'Đã hoàn tiền';

  @override
  String get paymentStatusCancelled => 'Đã hủy';

  @override
  String get paymentMethodCash => 'Tiền mặt';

  @override
  String get paymentMethodBankTransfer => 'Chuyển khoản ngân hàng';

  @override
  String get paymentMethodCheck => 'Séc';

  @override
  String get paymentMethodCreditCard => 'Thẻ tín dụng';

  @override
  String get paymentMethodDebitCard => 'Thẻ ghi nợ';

  @override
  String get paymentMethodMobileMoney => 'Ví điện tử';

  @override
  String get paymentMethodOther => 'Khác';

  @override
  String get paymentTypeRent => 'Tiền thuê';

  @override
  String get paymentTypeDeposit => 'Tiền đặt cọc';

  @override
  String get paymentTypeUtility => 'Tiện ích';

  @override
  String get paymentTypeMaintenance => 'Bảo trì';

  @override
  String get paymentTypePenalty => 'Phạt';

  @override
  String get paymentTypeOther => 'Khác';

  @override
  String get addPayment => 'Thêm thanh toán';

  @override
  String get editPayment => 'Sửa thanh toán';

  @override
  String get deletePayment => 'Xóa thanh toán';

  @override
  String get deletePaymentConfirm => 'Bạn có chắc chắn muốn xóa thanh toán này?';

  @override
  String get paymentAddSuccess => 'Thêm thanh toán thành công';

  @override
  String get paymentUpdateSuccess => 'Cập nhật thanh toán thành công';

  @override
  String get paymentDeleteSuccess => 'Xóa thanh toán thành công';

  @override
  String get noPaymentsFound => 'Không tìm thấy thanh toán nào';

  @override
  String get paymentDetails => 'Chi tiết thanh toán';

  @override
  String get paymentInformation => 'Thông tin thanh toán';

  @override
  String get paymentReceipt => 'Biên lai';

  @override
  String get generateReceipt => 'Tạo biên lai';

  @override
  String get sendReceipt => 'Gửi biên lai';

  @override
  String get receiptSent => 'Đã gửi biên lai';

  @override
  String get receiptGenerationFailed => 'Tạo biên lai thất bại';

  @override
  String get sendReceiptFailed => 'Gửi biên lai thất bại';

  @override
  String get paymentHistory => 'Lịch sử thanh toán';

  @override
  String get paymentSummary => 'Tổng kết thanh toán';

  @override
  String get totalPaid => 'Tổng đã thanh toán';

  @override
  String get totalDue => 'Tổng còn nợ';

  @override
  String get balance => 'Số dư';

  @override
  String get outstandingBalance => 'Số dư còn lại';

  @override
  String get paymentReminder => 'Nhắc nhở thanh toán';

  @override
  String get tasksReminder => 'Nhắc nhở công việc';

  @override
  String get sendReminder => 'Gửi nhắc nhở';

  @override
  String get reminderSent => 'Đã gửi nhắc nhở';

  @override
  String get sendReminderFailed => 'Gửi nhắc nhở thất bại';

  @override
  String paymentReminderMessage(Object amount, Object dueDate, Object purpose) {
    return 'Đây là lời nhắc thanh toán số tiền $amount cho $purpose đến hạn vào ngày $dueDate.';
  }

  @override
  String paymentOverdueMessage(Object amount, Object purpose) {
    return 'Khoản thanh toán $amount cho $purpose đã quá hạn. Vui lòng thanh toán sớm để tránh bất tiện.';
  }

  @override
  String paymentConfirmationMessage(Object amount, Object purpose) {
    return 'Cảm ơn bạn đã thanh toán số tiền $amount cho $purpose. Giao dịch đã được xử lý thành công.';
  }

  @override
  String paymentReceiptMessage(Object amount, Object purpose) {
    return 'Vui lòng xem tệp đính kèm biên lai thanh toán số tiền $amount cho $purpose. Cảm ơn bạn!';
  }

  @override
  String paymentReceiptSubject(Object receiptNumber) {
    return 'Biên lai thanh toán - $receiptNumber';
  }

  @override
  String paymentReminderSubject(Object invoiceNumber) {
    return 'Nhắc nhở thanh toán - $invoiceNumber';
  }

  @override
  String paymentOverdueSubject(Object invoiceNumber) {
    return 'Thanh toán quá hạn - $invoiceNumber';
  }

  @override
  String paymentConfirmationSubject(Object invoiceNumber) {
    return 'Xác nhận thanh toán - $invoiceNumber';
  }

  @override
  String invoiceNumber(Object number) {
    return 'Hóa đơn #$number';
  }

  @override
  String receiptNumber(Object number) {
    return 'Biên lai #$number';
  }

  @override
  String get issueDate => 'Ngày phát hành';

  @override
  String get description => 'Mô tả';

  @override
  String get quantity => 'Số lượng';

  @override
  String get unitPrice => 'Đơn giá';

  @override
  String get subtotal => 'Tạm tính';

  @override
  String get tax => 'Thuế';

  @override
  String get total => 'Tổng cộng';

  @override
  String get amountPaid => 'Đã thanh toán';

  @override
  String get amountDue => 'Còn lại';

  @override
  String get enterAmount => 'Nhập số lượng';

  @override
  String get pleaseEnterAmount => 'Vui Lòng nhập số lượng';

  @override
  String get pleaseEnterValidAmount => 'Vui Lòng nhập số hợp l';

  @override
  String get notes => 'Ghi chú';

  @override
  String get termsAndConditions => 'Điều khoản và điều kiện';

  @override
  String get thankYou => 'Cảm ơn!';

  @override
  String get contactUs => 'Liên hệ';

  @override
  String get phone => 'Điện thoại';

  @override
  String get website => 'Trang web';

  @override
  String get address => 'Địa chỉ';

  @override
  String get invoice => 'Hóa đơn';

  @override
  String get receipt => 'Biên lai';

  @override
  String get invoiceTo => 'Gửi đến';

  @override
  String get receiptFor => 'Biên lai cho';

  @override
  String get paidOn => 'Thanh toán ngày';

  @override
  String get paidBy => 'Người thanh toán';

  @override
  String get memo => 'Ghi nhớ';

  @override
  String get from => 'Từ';

  @override
  String get to => 'Đến';

  @override
  String get date => 'Ngày';

  @override
  String get dateTransfer => 'Ngày chuyển';

  @override
  String get item => 'Mục';

  @override
  String get rate => 'Đơn giá';

  @override
  String get balanceDue => 'Số dư còn lại';

  @override
  String get makePayment => 'Thanh toán';

  @override
  String get printReceipt => 'In biên lai';

  @override
  String get downloadPdf => 'Tải PDF';

  @override
  String get sendEmail => 'Gửi email';

  @override
  String get markAsPaid => 'Đánh dấu đã thanh toán';

  @override
  String get noPaymentHistory => 'Không có lịch sử thanh toán';

  @override
  String get paymentMethodDetails => 'Chi tiết phương thức thanh toán';

  @override
  String get cardNumber => 'Số thẻ';

  @override
  String get expiryDate => 'Ngày hết hạn';

  @override
  String get cvv => 'CVV';

  @override
  String get nameOnCard => 'Tên trên thẻ';

  @override
  String get bankName => 'Tên ngân hàng';

  @override
  String get accountNumber => 'Số tài khoản';

  @override
  String get routingNumber => 'Mã ngân hàng';

  @override
  String get checkNumber => 'Số séc';

  @override
  String get mobileNumber => 'Số điện thoại';

  @override
  String get network => 'Mạng';

  @override
  String get transactionId => 'Mã giao dịch';

  @override
  String get paymentConfirmation => 'Xác nhận thanh toán';

  @override
  String get paymentSuccessful => 'Thanh toán thành công';

  @override
  String get paymentFailed => 'Thanh toán thất bại';

  @override
  String get paymentProcessing => 'Đang xử lý thanh toán...';

  @override
  String get paymentVerification => 'Đang xác minh thanh toán...';

  @override
  String get paymentRedirect => 'Đang chuyển hướng đến cổng thanh toán...';

  @override
  String get paymentCancelled => 'Đã hủy thanh toán';

  @override
  String get paymentError => 'Lỗi thanh toán';

  @override
  String get contactSupport => 'Liên hệ hỗ trợ';

  @override
  String get paymentSecurityMessage => 'Giao dịch của bạn được bảo mật và mã hóa.';

  @override
  String get paymentPrivacyMessage => 'Chúng tôi không lưu trữ thông tin thanh toán của bạn.';

  @override
  String get paymentTerms => 'Bằng cách tiếp tục, bạn đồng ý với Điều khoản dịch vụ và Chính sách bảo mật của chúng tôi.';

  @override
  String get refundPolicy => 'Chính sách hoàn tiền';

  @override
  String get privacyPolicy => 'Chính sách bảo mật';

  @override
  String get termsOfService => 'Điều khoản dịch vụ';

  @override
  String get helpAndSupport => 'Trợ giúp & Hỗ trợ';

  @override
  String get frequentlyAskedQuestions => 'Câu hỏi thường gặp';

  @override
  String get contactCustomerSupport => 'Liên hệ hỗ trợ khách hàng';

  @override
  String get liveChat => 'Trò chuyện trực tuyến';

  @override
  String get phoneSupport => 'Hỗ trợ qua điện thoại';

  @override
  String get emailSupport => 'Hỗ trợ qua email';

  @override
  String get businessHours => 'Giờ làm việc';

  @override
  String get mondayToFriday => 'Thứ Hai - Thứ Sáu';

  @override
  String get saturday => 'Thứ Bảy';

  @override
  String get sunday => 'Chủ Nhật';

  @override
  String get closed => 'Đóng cửa';

  @override
  String get emergencySupport => 'Để được hỗ trợ khẩn cấp, vui lòng gọi đường dây nóng 24/7 của chúng tôi.';

  @override
  String get thankYouForContactingUs => 'Cảm ơn bạn đã liên hệ với chúng tôi. Chúng tôi sẽ phản hồi sớm nhất có thể!';

  @override
  String get yourMessageHasBeenSent => 'Tin nhắn của bạn đã được gửi thành công.';

  @override
  String get weAppreciateYourFeedback => 'Chúng tôi đánh giá cao phản hồi của bạn và sẽ sử dụng nó để cải thiện dịch vụ của chúng tôi.';

  @override
  String get sorryForTheInconvenience => 'Chúng tôi xin lỗi vì sự bất tiện này. Vui lòng thử lại sau hoặc liên hệ hỗ trợ nếu vấn đề vẫn tiếp diễn.';

  @override
  String get pageNotFound => 'Không tìm thấy trang';

  @override
  String get thePageYouAreLookingFor => 'Trang bạn đang tìm kiếm có thể đã bị xóa, đổi tên hoặc tạm thởi không khả dụng.';

  @override
  String get goToHomepage => 'Về trang chủ';

  @override
  String get oopsSomethingWentWrong => 'Rất tiếc! Đã xảy ra lỗi.';

  @override
  String get weAreWorkingOnIt => 'Chúng tôi đang khắc phục sự cố. Vui lòng thử lại sau.';

  @override
  String get serviceUnavailable => 'Dịch vụ không khả dụng';

  @override
  String get theServiceIsTemporarilyUnavailable => 'Dịch vụ tạm thởi không khả dụng. Vui lòng thử lại sau.';

  @override
  String get maintenanceInProgress => 'Đang bảo trì';

  @override
  String get weAreCurrentlyPerformingScheduledMaintenance => 'Chúng tôi đang thực hiện bảo trì theo lịch trình. Chúng tôi sẽ trở lại sớm.';

  @override
  String estimatedCompletionTime(Object time) {
    return 'Thời gian dự kiến hoàn thành: $time';
  }

  @override
  String get thankYouForYourPatience => 'Cảm ơn sự kiên nhẫn của bạn.';

  @override
  String get accessDenied => 'Từ chối truy cập';

  @override
  String get youDoNotHavePermission => 'Bạn không có quyền truy cập trang này.';

  @override
  String get pleaseContactYourAdministrator => 'Vui lòng liên hệ quản trị viên nếu bạn cho rằng đây là lỗi.';

  @override
  String get sessionExpired => 'Phiên đăng nhập hết hạn';

  @override
  String get yourSessionHasExpired => 'Phiên đăng nhập của bạn đã hết hạn. Vui lòng đăng nhập lại để tiếp tục.';

  @override
  String get logInAgain => 'Đăng nhập lại';

  @override
  String get youHaveBeenLoggedOut => 'Bạn đã đăng xuất thành công.';

  @override
  String get logInToContinue => 'Vui lòng đăng nhập để tiếp tục.';

  @override
  String get welcomeBack => 'Chào mừng trở lại!';

  @override
  String get enterYourCredentials => 'Nhập thông tin đăng nhập của bạn để truy cập tài khoản.';

  @override
  String get rememberMe => 'Ghi nhớ đăng nhập';

  @override
  String get forgotYourPassword => 'Quên mật khẩu?';

  @override
  String get dontHaveAnAccount => 'Chưa có tài khoản?';

  @override
  String get signUpNow => 'Đăng ký ngay';

  @override
  String get or => 'Hoặc';

  @override
  String get signInWithGoogle => 'Đăng nhập bằng Google';

  @override
  String get signInWithFacebook => 'Đăng nhập bằng Facebook';

  @override
  String get signInWithApple => 'Đăng nhập bằng Apple';

  @override
  String get bySigningInYouAgree => 'Bằng cách đăng nhập, bạn đồng ý với ';

  @override
  String get and => ' và ';

  @override
  String get createAnAccount => 'Tạo tài khoản';

  @override
  String get alreadyHaveAnAccount => 'Đã có tài khoản?';

  @override
  String get signInHere => 'Đăng nhập tại đây';

  @override
  String get iAgreeToThe => 'Tôi đồng ý với ';

  @override
  String get privacyPolicyAndTerms => 'Chính sách bảo mật và Điều khoản dịch vụ';

  @override
  String get createAccount => 'Tạo tài khoản';

  @override
  String get verificationCode => 'Mã xác minh';

  @override
  String enterTheVerificationCode(Object email) {
    return 'Nhập mã xác minh đã gửi đến $email';
  }

  @override
  String get didntReceiveTheCode => 'Không nhận được mã?';

  @override
  String get resendCode => 'Gửi lại mã';

  @override
  String get verify => 'Xác minh';

  @override
  String get verificationSuccessful => 'Xác minh thành công!';

  @override
  String get yourAccountHasBeenVerified => 'Tài khoản của bạn đã được xác minh thành công.';

  @override
  String get continueToDashboard => 'Tiếp tục đến Bảng điều khiển';

  @override
  String get resetYourPassword => 'Đặt lại mật khẩu';

  @override
  String get enterYourEmailAddress => 'Nhập địa chỉ email của bạn và chúng tôi sẽ gửi cho bạn liên kết đặt lại mật khẩu.';

  @override
  String get sendResetLink => 'Gửi liên kết đặt lại';

  @override
  String get backToSignIn => 'Quay lại đăng nhập';

  @override
  String get resetLinkSent => 'Đã gửi liên kết đặt lại!';

  @override
  String get weHaveSentYouAnEmail => 'Chúng tôi đã gửi cho bạn email hướng dẫn đặt lại mật khẩu.';

  @override
  String get checkYourEmail => 'Kiểm tra email của bạn';

  @override
  String get createNewPassword => 'Tạo mật khẩu mới';

  @override
  String get yourNewPasswordMustBeDifferent => 'Mật khẩu mới của bạn phải khác với mật khẩu trước đó.';

  @override
  String get activeUsers => 'Đang hoạt động';
}
