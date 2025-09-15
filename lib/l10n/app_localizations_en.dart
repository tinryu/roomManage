// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Room Management';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get search => 'Search';

  @override
  String get loading => 'Loading...';

  @override
  String get loadMore => 'load More';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get retry => 'Retry';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String get nope => 'Nope';

  @override
  String get confirm => 'Confirm';

  @override
  String get select => 'Select';

  @override
  String get selectImage => 'Select image';

  @override
  String get selectExactlyOne => 'Select exactly one item';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get noData => 'No data';

  @override
  String get unknownError => 'An unknown error occurred';

  @override
  String get noInternet => 'No internet connection';

  @override
  String get tryAgain => 'Please try again';

  @override
  String get requiredField => 'Required field';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get invalidPhone => 'Invalid phone number';

  @override
  String get invalidNumber => 'Invalid number';

  @override
  String get deleteFailed => 'Delete failed';

  @override
  String get defaultDateFormat => 'MM/dd/yyyy';

  @override
  String get settingsSaved => 'Settings saved successfully';

  @override
  String get errorSavingSettings => 'Error saving settings';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get home => 'Home';

  @override
  String get dashboard => 'Dashboard';

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
  String get payments => 'Payments';

  @override
  String get financeSummary => 'Finance Summary';

  @override
  String get rooms => 'Rooms';

  @override
  String get tasks => 'Tasks';

  @override
  String get upcomingTask => 'Upcoming Tasks';

  @override
  String get noTask => 'No task';

  @override
  String get reports => 'Reports';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get logout => 'Log out';

  @override
  String get login => 'Log in';

  @override
  String get register => 'Register';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get signUp => 'Sign up';

  @override
  String get signIn => 'Sign in';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get fullName => 'Full name';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get loginSuccess => 'Login successful';

  @override
  String get registerSuccess => 'Registration successful';

  @override
  String get loginError => 'Login failed. Please check your credentials.';

  @override
  String get registerError => 'Registration failed. Please try again.';

  @override
  String get passwordNotMatch => 'Passwords do not match';

  @override
  String get forgotPasswordMessage => 'Enter your email to reset your password';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get resetPasswordSuccess => 'Password reset link sent';

  @override
  String get resetPasswordError => 'Failed to send password reset email';

  @override
  String welcome(Object userName) {
    return 'Welcome, $userName!';
  }

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get today => 'Today';

  @override
  String get thisWeek => 'This week';

  @override
  String get thisMonth => 'This month';

  @override
  String get totalRooms => 'Total rooms';

  @override
  String get occupiedRooms => 'Occupied rooms';

  @override
  String get availableRooms => 'Available rooms';

  @override
  String get totalTenants => 'Total tenants';

  @override
  String get activeTenants => 'Active tenants';

  @override
  String get totalIncome => 'Total income';

  @override
  String get totalExpenses => 'Total expenses';

  @override
  String get recentIncome => 'Recent income';

  @override
  String get recentActivities => 'Recent activities';

  @override
  String get viewAll => 'View all';

  @override
  String get selectAll => 'Select all';

  @override
  String get upcomingPayments => 'Upcoming payments';

  @override
  String get overduePayments => 'Overdue payments';

  @override
  String get paid => 'Paid';

  @override
  String get unpaid => 'Unpaid';

  @override
  String get overdue => 'Overdue';

  @override
  String get dueDate => 'Due date';

  @override
  String get amount => 'Amount';

  @override
  String get status => 'Status';

  @override
  String get action => 'Action';

  @override
  String get noRecentActivities => 'No recent activities';

  @override
  String get noUpcomingPayments => 'No upcoming payments';

  @override
  String get noOverduePayments => 'No overdue payments';

  @override
  String get todayRevenue => 'Today Revenue';

  @override
  String get checkInToday => 'Check-in Today';

  @override
  String get occupancyRate => 'Occupancy Rate';

  @override
  String get waitingDamaged => 'Waiting damaged';

  @override
  String get room => 'Room';

  @override
  String get roomName => 'Room name';

  @override
  String get roomNumber => 'Room number';

  @override
  String get roomType => 'Room type';

  @override
  String get roomStatus => 'Room status';

  @override
  String get roomStatusAvailable => 'Available';

  @override
  String get roomStatusOccupied => 'Occupied';

  @override
  String get roomStatusVacant => 'Vacant';

  @override
  String get roomStatusMaintenance => 'Under maintenance';

  @override
  String get roomStatusReserved => 'Reserved';

  @override
  String get roomDetails => 'Room details';

  @override
  String get roomInformation => 'Room information';

  @override
  String get roomFeatures => 'Room features';

  @override
  String get roomSize => 'Size';

  @override
  String get roomFloor => 'Floor';

  @override
  String get roomCapacity => 'Capacity';

  @override
  String get roomPrice => 'Price';

  @override
  String get roomDescription => 'Description';

  @override
  String get addRoom => 'Add room';

  @override
  String get editRoom => 'Edit room';

  @override
  String get deleteRoom => 'Delete room';

  @override
  String get deleteRoomConfirm => 'Are you sure you want to delete this room?';

  @override
  String get roomAddSuccess => 'Room added successfully';

  @override
  String get roomUpdateSuccess => 'Room updated successfully';

  @override
  String get roomDeleteSuccess => 'Room deleted successfully';

  @override
  String get noRoomsFound => 'No rooms found';

  @override
  String get tenant => 'Tenant';

  @override
  String get tenantName => 'Tenant name';

  @override
  String get tenantPhone => 'Phone number';

  @override
  String get tenantEmail => 'Email';

  @override
  String get tenantAddress => 'Address';

  @override
  String get tenantIdNumber => 'ID number';

  @override
  String get tenantEmergencyContact => 'Emergency contact';

  @override
  String get tenantOccupation => 'Occupation';

  @override
  String get tenantCompany => 'Company';

  @override
  String get tenantNotes => 'Notes';

  @override
  String get tenantCheckInDate => 'Check-in date';

  @override
  String get tenantCheckOutDate => 'Check-out date';

  @override
  String get tenantLeaseStart => 'Lease start';

  @override
  String get tenantLeaseEnd => 'Lease end';

  @override
  String get tenantRentAmount => 'Rent amount';

  @override
  String get tenantRentDueDay => 'Rent due day';

  @override
  String get tenantSecurityDeposit => 'Security deposit';

  @override
  String get tenantStatus => 'Status';

  @override
  String get tenantStatusActive => 'Active';

  @override
  String get tenantStatusInactive => 'Inactive';

  @override
  String get tenantStatusOverdue => 'Payment overdue';

  @override
  String get tenantStatusEvicted => 'Evicted';

  @override
  String get tenantStatusMovedOut => 'Moved out';

  @override
  String get addTenant => 'Add tenant';

  @override
  String get editTenant => 'Edit tenant';

  @override
  String get deleteTenant => 'Delete tenant';

  @override
  String get deleteTenantConfirm => 'Are you sure you want to delete this tenant?';

  @override
  String get tenantAddSuccess => 'Tenant added successfully';

  @override
  String get tenantUpdateSuccess => 'Tenant updated successfully';

  @override
  String get tenantDeleteSuccess => 'Tenant deleted successfully';

  @override
  String get noTenantsFound => 'No tenants found';

  @override
  String get tenantDetails => 'Tenant details';

  @override
  String get tenantInformation => 'Tenant information';

  @override
  String get tenantDocuments => 'Documents';

  @override
  String get tenantPayments => 'Payments';

  @override
  String get tenantMaintenanceRequests => 'Maintenance requests';

  @override
  String get tenantNotesAndHistory => 'Notes and history';

  @override
  String get uploadDocument => 'Upload document';

  @override
  String get documentType => 'Document type';

  @override
  String get documentName => 'Document name';

  @override
  String get documentUploadDate => 'Upload date';

  @override
  String get noDocuments => 'No documents';

  @override
  String get addDocument => 'Add document';

  @override
  String get documentAddSuccess => 'Document added successfully';

  @override
  String get documentDeleteSuccess => 'Document deleted successfully';

  @override
  String get documentDeleteConfirm => 'Are you sure you want to delete this document?';

  @override
  String get asset => 'Asset';

  @override
  String get assetName => 'Asset name';

  @override
  String get assetCategory => 'Category';

  @override
  String get assetCondition => 'Condition';

  @override
  String get assetStatus => 'Status';

  @override
  String get assetPurchaseDate => 'Purchase date';

  @override
  String get assetPurchasePrice => 'Purchase price';

  @override
  String get assetSerialNumber => 'Serial number';

  @override
  String get assetModel => 'Model';

  @override
  String get assetBrand => 'Brand';

  @override
  String get assetSupplier => 'Supplier';

  @override
  String get assetWarrantyExpiry => 'Warranty expiry';

  @override
  String get assetLocation => 'Location';

  @override
  String get assetAssignedTo => 'Assigned to';

  @override
  String get assetNotes => 'Notes';

  @override
  String get assetConditionNew => 'New';

  @override
  String get assetConditionGood => 'Good';

  @override
  String get assetConditionFair => 'Fair';

  @override
  String get assetConditionPoor => 'Poor';

  @override
  String get assetConditionDamaged => 'Damaged';

  @override
  String get assetStatusAvailable => 'Available';

  @override
  String get assetStatusInUse => 'In use';

  @override
  String get assetStatusMaintenance => 'Under maintenance';

  @override
  String get assetStatusDisposed => 'Disposed';

  @override
  String get assetStatusLost => 'Lost';

  @override
  String get addAsset => 'Add asset';

  @override
  String get editAsset => 'Edit asset';

  @override
  String get deleteAsset => 'Delete asset';

  @override
  String get deleteAssetConfirm => 'Are you sure you want to delete this asset?';

  @override
  String get assetAddSuccess => 'Asset added successfully';

  @override
  String get assetUpdateSuccess => 'Asset updated successfully';

  @override
  String get assetDeleteSuccess => 'Asset deleted successfully';

  @override
  String get noAssetsFound => 'No assets found';

  @override
  String get assetDetails => 'Asset details';

  @override
  String get assetInformation => 'Asset information';

  @override
  String get assetMaintenanceHistory => 'Maintenance history';

  @override
  String get assetDepreciation => 'Depreciation';

  @override
  String get assetValue => 'Current value';

  @override
  String get assetPurchaseInfo => 'Purchase information';

  @override
  String get assetWarrantyInfo => 'Warranty information';

  @override
  String get assetLocationInfo => 'Location information';

  @override
  String get assetAssignmentHistory => 'Assignment history';

  @override
  String get assignAsset => 'Assign asset';

  @override
  String get unassignAsset => 'Unassign asset';

  @override
  String get assetAssignmentSuccess => 'Asset assigned successfully';

  @override
  String get assetUnassignmentSuccess => 'Asset unassigned successfully';

  @override
  String get scheduleMaintenance => 'Schedule maintenance';

  @override
  String get maintenanceScheduled => 'Maintenance scheduled';

  @override
  String get maintenanceCompleted => 'Maintenance completed';

  @override
  String get maintenanceCancelled => 'Maintenance cancelled';

  @override
  String get maintenanceHistory => 'Maintenance history';

  @override
  String get noMaintenanceHistory => 'No maintenance history';

  @override
  String get maintenanceType => 'Maintenance type';

  @override
  String get maintenanceDate => 'Maintenance date';

  @override
  String get maintenanceCost => 'Cost';

  @override
  String get maintenanceDescription => 'Description';

  @override
  String get maintenanceTechnician => 'Technician';

  @override
  String get maintenanceStatus => 'Status';

  @override
  String get maintenanceStatusScheduled => 'Scheduled';

  @override
  String get maintenanceStatusInProgress => 'In progress';

  @override
  String get maintenanceStatusCompleted => 'Completed';

  @override
  String get maintenanceStatusCancelled => 'Cancelled';

  @override
  String get addMaintenanceRecord => 'Add maintenance record';

  @override
  String get editMaintenanceRecord => 'Edit maintenance record';

  @override
  String get deleteMaintenanceRecord => 'Delete maintenance record';

  @override
  String get deleteMaintenanceRecordConfirm => 'Are you sure you want to delete this maintenance record?';

  @override
  String get maintenanceRecordAddSuccess => 'Maintenance record added successfully';

  @override
  String get maintenanceRecordUpdateSuccess => 'Maintenance record updated successfully';

  @override
  String get maintenanceRecordDeleteSuccess => 'Maintenance record deleted successfully';

  @override
  String get payment => 'Payment';

  @override
  String get paymentAmount => 'Amount';

  @override
  String get paymentDate => 'Payment date';

  @override
  String get paymentMethod => 'Payment method';

  @override
  String get paymentStatus => 'Status';

  @override
  String get paymentReference => 'Reference';

  @override
  String get paymentNotes => 'Notes';

  @override
  String get paymentFor => 'Payment for';

  @override
  String get paymentType => 'Payment type';

  @override
  String get paymentReceivedBy => 'Received by';

  @override
  String get paymentReceivedFrom => 'Received from';

  @override
  String get paymentStatusPaid => 'Paid';

  @override
  String get paymentStatusUnpaid => 'Unpaid';

  @override
  String get paymentStatusOverdue => 'Overdue';

  @override
  String get paymentStatusPartial => 'Partial';

  @override
  String get paymentStatusRefunded => 'Refunded';

  @override
  String get paymentStatusCancelled => 'Cancelled';

  @override
  String get paymentMethodCash => 'Cash';

  @override
  String get paymentMethodBankTransfer => 'Bank transfer';

  @override
  String get paymentMethodCheck => 'Check';

  @override
  String get paymentMethodCreditCard => 'Credit card';

  @override
  String get paymentMethodDebitCard => 'Debit card';

  @override
  String get paymentMethodMobileMoney => 'Mobile money';

  @override
  String get paymentMethodOther => 'Other';

  @override
  String get paymentTypeRent => 'Rent';

  @override
  String get paymentTypeDeposit => 'Deposit';

  @override
  String get paymentTypeUtility => 'Utility';

  @override
  String get paymentTypeMaintenance => 'Maintenance';

  @override
  String get paymentTypePenalty => 'Penalty';

  @override
  String get paymentTypeOther => 'Other';

  @override
  String get addPayment => 'Add payment';

  @override
  String get editPayment => 'Edit payment';

  @override
  String get deletePayment => 'Delete payment';

  @override
  String get deletePaymentConfirm => 'Are you sure you want to delete this payment?';

  @override
  String get paymentAddSuccess => 'Payment added successfully';

  @override
  String get paymentUpdateSuccess => 'Payment updated successfully';

  @override
  String get paymentDeleteSuccess => 'Payment deleted successfully';

  @override
  String get noPaymentsFound => 'No payments found';

  @override
  String get paymentDetails => 'Payment details';

  @override
  String get paymentInformation => 'Payment information';

  @override
  String get paymentReceipt => 'Receipt';

  @override
  String get generateReceipt => 'Generate receipt';

  @override
  String get sendReceipt => 'Send receipt';

  @override
  String get receiptSent => 'Receipt sent';

  @override
  String get receiptGenerationFailed => 'Failed to generate receipt';

  @override
  String get sendReceiptFailed => 'Failed to send receipt';

  @override
  String get paymentHistory => 'Payment history';

  @override
  String get paymentSummary => 'Payment summary';

  @override
  String get totalPaid => 'Total paid';

  @override
  String get totalDue => 'Total due';

  @override
  String get balance => 'Balance';

  @override
  String get outstandingBalance => 'Outstanding balance';

  @override
  String get paymentReminder => 'Payment reminder';

  @override
  String get tasksReminder => 'Tasks reminder';

  @override
  String get sendReminder => 'Send reminder';

  @override
  String get reminderSent => 'Reminder sent';

  @override
  String get sendReminderFailed => 'Failed to send reminder';

  @override
  String paymentReminderMessage(Object amount, Object dueDate, Object purpose) {
    return 'This is a reminder for payment of $amount for $purpose due on $dueDate.';
  }

  @override
  String paymentOverdueMessage(Object amount, Object purpose) {
    return 'The payment of $amount for $purpose is overdue. Please pay as soon as possible to avoid inconvenience.';
  }

  @override
  String paymentConfirmationMessage(Object amount, Object purpose) {
    return 'Thank you for your payment of $amount for $purpose. The transaction has been processed successfully.';
  }

  @override
  String paymentReceiptMessage(Object amount, Object purpose) {
    return 'Please find attached the receipt for the payment of $amount for $purpose. Thank you!';
  }

  @override
  String paymentReceiptSubject(Object receiptNumber) {
    return 'Payment Receipt - $receiptNumber';
  }

  @override
  String paymentReminderSubject(Object invoiceNumber) {
    return 'Payment Reminder - $invoiceNumber';
  }

  @override
  String paymentOverdueSubject(Object invoiceNumber) {
    return 'Payment Overdue - $invoiceNumber';
  }

  @override
  String paymentConfirmationSubject(Object invoiceNumber) {
    return 'Payment Confirmation - $invoiceNumber';
  }

  @override
  String invoiceNumber(Object number) {
    return 'Invoice #$number';
  }

  @override
  String receiptNumber(Object number) {
    return 'Receipt #$number';
  }

  @override
  String get issueDate => 'Issue date';

  @override
  String get description => 'Description';

  @override
  String get quantity => 'Quantity';

  @override
  String get unitPrice => 'Unit price';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get tax => 'Tax';

  @override
  String get total => 'Total';

  @override
  String get amountPaid => 'Amount paid';

  @override
  String get amountDue => 'Amount due';

  @override
  String get enterAmount => 'Enter Amount';

  @override
  String get pleaseEnterAmount => 'Please enter an amount';

  @override
  String get pleaseEnterValidAmount => 'Please enter a valid amount';

  @override
  String get notes => 'Notes';

  @override
  String get termsAndConditions => 'Terms and conditions';

  @override
  String get thankYou => 'Thank you!';

  @override
  String get contactUs => 'Contact us';

  @override
  String get phone => 'Phone';

  @override
  String get website => 'Website';

  @override
  String get address => 'Address';

  @override
  String get invoice => 'Invoice';

  @override
  String get receipt => 'Receipt';

  @override
  String get invoiceTo => 'Invoice to';

  @override
  String get receiptFor => 'Receipt for';

  @override
  String get paidOn => 'Paid on';

  @override
  String get paidBy => 'Paid by';

  @override
  String get memo => 'Memo';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get date => 'Date';

  @override
  String get dateTransfer => 'Date transfer';

  @override
  String get item => 'Item';

  @override
  String get rate => 'Rate';

  @override
  String get balanceDue => 'Balance due';

  @override
  String get makePayment => 'Make payment';

  @override
  String get printReceipt => 'Print receipt';

  @override
  String get downloadPdf => 'Download PDF';

  @override
  String get sendEmail => 'Send email';

  @override
  String get markAsPaid => 'Mark as paid';

  @override
  String get noPaymentHistory => 'No payment history';

  @override
  String get paymentMethodDetails => 'Payment method details';

  @override
  String get cardNumber => 'Card number';

  @override
  String get expiryDate => 'Expiry date';

  @override
  String get cvv => 'CVV';

  @override
  String get nameOnCard => 'Name on card';

  @override
  String get bankName => 'Bank name';

  @override
  String get accountNumber => 'Account number';

  @override
  String get routingNumber => 'Routing number';

  @override
  String get checkNumber => 'Check number';

  @override
  String get mobileNumber => 'Mobile number';

  @override
  String get network => 'Network';

  @override
  String get transactionId => 'Transaction ID';

  @override
  String get paymentConfirmation => 'Payment confirmation';

  @override
  String get paymentSuccessful => 'Payment successful';

  @override
  String get paymentFailed => 'Payment failed';

  @override
  String get paymentProcessing => 'Processing payment...';

  @override
  String get paymentVerification => 'Verifying payment...';

  @override
  String get paymentRedirect => 'Redirecting to payment gateway...';

  @override
  String get paymentCancelled => 'Payment cancelled';

  @override
  String get paymentError => 'Payment error';

  @override
  String get contactSupport => 'Contact support';

  @override
  String get paymentSecurityMessage => 'Your transaction is secure and encrypted.';

  @override
  String get paymentPrivacyMessage => 'We do not store your payment information.';

  @override
  String get paymentTerms => 'By continuing, you agree to our Terms of Service and Privacy Policy.';

  @override
  String get refundPolicy => 'Refund policy';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get termsOfService => 'Terms of service';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get frequentlyAskedQuestions => 'Frequently Asked Questions';

  @override
  String get contactCustomerSupport => 'Contact customer support';

  @override
  String get liveChat => 'Live chat';

  @override
  String get phoneSupport => 'Phone support';

  @override
  String get emailSupport => 'Email support';

  @override
  String get businessHours => 'Business hours';

  @override
  String get mondayToFriday => 'Monday - Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get closed => 'Closed';

  @override
  String get emergencySupport => 'For emergency support, please call our 24/7 hotline.';

  @override
  String get thankYouForContactingUs => 'Thank you for contacting us. We will reply as soon as possible!';

  @override
  String get yourMessageHasBeenSent => 'Your message has been sent successfully.';

  @override
  String get weAppreciateYourFeedback => 'We appreciate your feedback and will get back to you shortly.';

  @override
  String get sorryForTheInconvenience => 'We apologize for the inconvenience. Please try again later or contact support if the issue persists.';

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get thePageYouAreLookingFor => 'The page you are looking for may have been removed, renamed, or is temporarily unavailable.';

  @override
  String get goToHomepage => 'Go to homepage';

  @override
  String get oopsSomethingWentWrong => 'Oops! Something went wrong.';

  @override
  String get weAreWorkingOnIt => 'We\'re working on it. Please try later.';

  @override
  String get serviceUnavailable => 'Service unavailable';

  @override
  String get theServiceIsTemporarilyUnavailable => 'The service is temporarily unavailable. Please try again later.';

  @override
  String get maintenanceInProgress => 'Maintenance in progress';

  @override
  String get weAreCurrentlyPerformingScheduledMaintenance => 'We are currently performing scheduled maintenance. We\'ll be back soon.';

  @override
  String estimatedCompletionTime(Object time) {
    return 'Estimated completion time: $time';
  }

  @override
  String get thankYouForYourPatience => 'Thank you for your patience.';

  @override
  String get accessDenied => 'Access denied';

  @override
  String get youDoNotHavePermission => 'You do not have permission to access this page.';

  @override
  String get pleaseContactYourAdministrator => 'Please contact your administrator if you believe this is an error.';

  @override
  String get sessionExpired => 'Session expired';

  @override
  String get yourSessionHasExpired => 'Your session has expired. Please sign in again to continue.';

  @override
  String get logInAgain => 'Sign in again';

  @override
  String get youHaveBeenLoggedOut => 'You have been logged out successfully.';

  @override
  String get logInToContinue => 'Please sign in to continue.';

  @override
  String get welcomeBack => 'Welcome back!';

  @override
  String get enterYourCredentials => 'Enter your credentials to access your account.';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotYourPassword => 'Forgot your password?';

  @override
  String get dontHaveAnAccount => 'Don\'t have an account?';

  @override
  String get signUpNow => 'Sign up now';

  @override
  String get or => 'Or';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signInWithFacebook => 'Sign in with Facebook';

  @override
  String get signInWithApple => 'Sign in with Apple';

  @override
  String get bySigningInYouAgree => 'By signing in you agree to ';

  @override
  String get and => ' and ';

  @override
  String get createAnAccount => 'Create an account';

  @override
  String get alreadyHaveAnAccount => 'Already have an account?';

  @override
  String get signInHere => 'Sign in here';

  @override
  String get iAgreeToThe => 'I agree to the ';

  @override
  String get privacyPolicyAndTerms => 'Privacy Policy and Terms of Service';

  @override
  String get createAccount => 'Create account';

  @override
  String get verificationCode => 'Verification code';

  @override
  String enterTheVerificationCode(Object email) {
    return 'Enter the verification code sent to $email';
  }

  @override
  String get didntReceiveTheCode => 'Didn\'t receive the code?';

  @override
  String get resendCode => 'Resend code';

  @override
  String get verify => 'Verify';

  @override
  String get verificationSuccessful => 'Verification successful!';

  @override
  String get yourAccountHasBeenVerified => 'Your account has been verified successfully.';

  @override
  String get continueToDashboard => 'Continue to Dashboard';

  @override
  String get resetYourPassword => 'Reset your password';

  @override
  String get enterYourEmailAddress => 'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get sendResetLink => 'Send reset link';

  @override
  String get backToSignIn => 'Back to sign in';

  @override
  String get resetLinkSent => 'Reset link sent!';

  @override
  String get weHaveSentYouAnEmail => 'We\'ve sent you an email with password reset instructions.';

  @override
  String get checkYourEmail => 'Check your email';

  @override
  String get createNewPassword => 'Create new password';

  @override
  String get yourNewPasswordMustBeDifferent => 'Your new password must be different from the previous one.';

  @override
  String get activeUsers => 'Active Users';
}
