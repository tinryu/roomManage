import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Room Management'**
  String get appTitle;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'load More'**
  String get loadMore;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @nope.
  ///
  /// In en, this message translates to:
  /// **'Nope'**
  String get nope;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @selectImage.
  ///
  /// In en, this message translates to:
  /// **'Select image'**
  String get selectImage;

  /// No description provided for @selectExactlyOne.
  ///
  /// In en, this message translates to:
  /// **'Select exactly one item'**
  String get selectExactlyOne;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get unknownError;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternet;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please try again'**
  String get tryAgain;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get requiredField;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhone;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get invalidNumber;

  /// No description provided for @deleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Delete failed'**
  String get deleteFailed;

  /// No description provided for @defaultDateFormat.
  ///
  /// In en, this message translates to:
  /// **'MM/dd/yyyy'**
  String get defaultDateFormat;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @tenants.
  ///
  /// In en, this message translates to:
  /// **'Tenants'**
  String get tenants;

  /// No description provided for @resources.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get resources;

  /// No description provided for @assets.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get assets;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @payments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments;

  /// No description provided for @financeSummary.
  ///
  /// In en, this message translates to:
  /// **'Finance Summary'**
  String get financeSummary;

  /// No description provided for @rooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get rooms;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @upcomingTask.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Tasks'**
  String get upcomingTask;

  /// No description provided for @noTask.
  ///
  /// In en, this message translates to:
  /// **'No task'**
  String get noTask;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccess;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get registerSuccess;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please check your credentials.'**
  String get loginError;

  /// No description provided for @registerError.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get registerError;

  /// No description provided for @passwordNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordNotMatch;

  /// No description provided for @forgotPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to reset your password'**
  String get forgotPasswordMessage;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @resetPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent'**
  String get resetPasswordSuccess;

  /// No description provided for @resetPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Failed to send password reset email'**
  String get resetPasswordError;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {userName}!'**
  String welcome(Object userName);

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// No description provided for @totalRooms.
  ///
  /// In en, this message translates to:
  /// **'Total rooms'**
  String get totalRooms;

  /// No description provided for @occupiedRooms.
  ///
  /// In en, this message translates to:
  /// **'Occupied rooms'**
  String get occupiedRooms;

  /// No description provided for @availableRooms.
  ///
  /// In en, this message translates to:
  /// **'Available rooms'**
  String get availableRooms;

  /// No description provided for @totalTenants.
  ///
  /// In en, this message translates to:
  /// **'Total tenants'**
  String get totalTenants;

  /// No description provided for @activeTenants.
  ///
  /// In en, this message translates to:
  /// **'Active tenants'**
  String get activeTenants;

  /// No description provided for @totalIncome.
  ///
  /// In en, this message translates to:
  /// **'Total income'**
  String get totalIncome;

  /// No description provided for @totalExpenses.
  ///
  /// In en, this message translates to:
  /// **'Total expenses'**
  String get totalExpenses;

  /// No description provided for @recentIncome.
  ///
  /// In en, this message translates to:
  /// **'Recent income'**
  String get recentIncome;

  /// No description provided for @recentActivities.
  ///
  /// In en, this message translates to:
  /// **'Recent activities'**
  String get recentActivities;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get selectAll;

  /// No description provided for @upcomingPayments.
  ///
  /// In en, this message translates to:
  /// **'Upcoming payments'**
  String get upcomingPayments;

  /// No description provided for @overduePayments.
  ///
  /// In en, this message translates to:
  /// **'Overdue payments'**
  String get overduePayments;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @unpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get dueDate;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @action.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get action;

  /// No description provided for @noRecentActivities.
  ///
  /// In en, this message translates to:
  /// **'No recent activities'**
  String get noRecentActivities;

  /// No description provided for @noUpcomingPayments.
  ///
  /// In en, this message translates to:
  /// **'No upcoming payments'**
  String get noUpcomingPayments;

  /// No description provided for @noOverduePayments.
  ///
  /// In en, this message translates to:
  /// **'No overdue payments'**
  String get noOverduePayments;

  /// No description provided for @todayRevenue.
  ///
  /// In en, this message translates to:
  /// **'Today Revenue'**
  String get todayRevenue;

  /// No description provided for @checkInToday.
  ///
  /// In en, this message translates to:
  /// **'Check-in Today'**
  String get checkInToday;

  /// No description provided for @occupancyRate.
  ///
  /// In en, this message translates to:
  /// **'Occupancy Rate'**
  String get occupancyRate;

  /// No description provided for @waitingDamaged.
  ///
  /// In en, this message translates to:
  /// **'Waiting damaged'**
  String get waitingDamaged;

  /// No description provided for @room.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get room;

  /// No description provided for @roomName.
  ///
  /// In en, this message translates to:
  /// **'Room name'**
  String get roomName;

  /// No description provided for @roomNumber.
  ///
  /// In en, this message translates to:
  /// **'Room number'**
  String get roomNumber;

  /// No description provided for @roomType.
  ///
  /// In en, this message translates to:
  /// **'Room type'**
  String get roomType;

  /// No description provided for @roomStatus.
  ///
  /// In en, this message translates to:
  /// **'Room status'**
  String get roomStatus;

  /// No description provided for @roomStatusAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get roomStatusAvailable;

  /// No description provided for @roomStatusOccupied.
  ///
  /// In en, this message translates to:
  /// **'Occupied'**
  String get roomStatusOccupied;

  /// No description provided for @roomStatusVacant.
  ///
  /// In en, this message translates to:
  /// **'Vacant'**
  String get roomStatusVacant;

  /// No description provided for @roomStatusMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Under maintenance'**
  String get roomStatusMaintenance;

  /// No description provided for @roomStatusReserved.
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get roomStatusReserved;

  /// No description provided for @roomDetails.
  ///
  /// In en, this message translates to:
  /// **'Room details'**
  String get roomDetails;

  /// No description provided for @roomInformation.
  ///
  /// In en, this message translates to:
  /// **'Room information'**
  String get roomInformation;

  /// No description provided for @roomFeatures.
  ///
  /// In en, this message translates to:
  /// **'Room features'**
  String get roomFeatures;

  /// No description provided for @roomSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get roomSize;

  /// No description provided for @roomFloor.
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get roomFloor;

  /// No description provided for @roomCapacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get roomCapacity;

  /// No description provided for @roomPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get roomPrice;

  /// No description provided for @roomDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get roomDescription;

  /// No description provided for @addRoom.
  ///
  /// In en, this message translates to:
  /// **'Add room'**
  String get addRoom;

  /// No description provided for @editRoom.
  ///
  /// In en, this message translates to:
  /// **'Edit room'**
  String get editRoom;

  /// No description provided for @deleteRoom.
  ///
  /// In en, this message translates to:
  /// **'Delete room'**
  String get deleteRoom;

  /// No description provided for @deleteRoomConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this room?'**
  String get deleteRoomConfirm;

  /// No description provided for @roomAddSuccess.
  ///
  /// In en, this message translates to:
  /// **'Room added successfully'**
  String get roomAddSuccess;

  /// No description provided for @roomUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Room updated successfully'**
  String get roomUpdateSuccess;

  /// No description provided for @roomDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Room deleted successfully'**
  String get roomDeleteSuccess;

  /// No description provided for @noRoomsFound.
  ///
  /// In en, this message translates to:
  /// **'No rooms found'**
  String get noRoomsFound;

  /// No description provided for @tenant.
  ///
  /// In en, this message translates to:
  /// **'Tenant'**
  String get tenant;

  /// No description provided for @tenantName.
  ///
  /// In en, this message translates to:
  /// **'Tenant name'**
  String get tenantName;

  /// No description provided for @tenantPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get tenantPhone;

  /// No description provided for @tenantEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get tenantEmail;

  /// No description provided for @tenantAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get tenantAddress;

  /// No description provided for @tenantIdNumber.
  ///
  /// In en, this message translates to:
  /// **'ID number'**
  String get tenantIdNumber;

  /// No description provided for @tenantEmergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency contact'**
  String get tenantEmergencyContact;

  /// No description provided for @tenantOccupation.
  ///
  /// In en, this message translates to:
  /// **'Occupation'**
  String get tenantOccupation;

  /// No description provided for @tenantCompany.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get tenantCompany;

  /// No description provided for @tenantNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get tenantNotes;

  /// No description provided for @tenantCheckInDate.
  ///
  /// In en, this message translates to:
  /// **'Check-in date'**
  String get tenantCheckInDate;

  /// No description provided for @tenantCheckOutDate.
  ///
  /// In en, this message translates to:
  /// **'Check-out date'**
  String get tenantCheckOutDate;

  /// No description provided for @tenantLeaseStart.
  ///
  /// In en, this message translates to:
  /// **'Lease start'**
  String get tenantLeaseStart;

  /// No description provided for @tenantLeaseEnd.
  ///
  /// In en, this message translates to:
  /// **'Lease end'**
  String get tenantLeaseEnd;

  /// No description provided for @tenantRentAmount.
  ///
  /// In en, this message translates to:
  /// **'Rent amount'**
  String get tenantRentAmount;

  /// No description provided for @tenantRentDueDay.
  ///
  /// In en, this message translates to:
  /// **'Rent due day'**
  String get tenantRentDueDay;

  /// No description provided for @tenantSecurityDeposit.
  ///
  /// In en, this message translates to:
  /// **'Security deposit'**
  String get tenantSecurityDeposit;

  /// No description provided for @tenantStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get tenantStatus;

  /// No description provided for @tenantStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get tenantStatusActive;

  /// No description provided for @tenantStatusInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get tenantStatusInactive;

  /// No description provided for @tenantStatusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Payment overdue'**
  String get tenantStatusOverdue;

  /// No description provided for @tenantStatusEvicted.
  ///
  /// In en, this message translates to:
  /// **'Evicted'**
  String get tenantStatusEvicted;

  /// No description provided for @tenantStatusMovedOut.
  ///
  /// In en, this message translates to:
  /// **'Moved out'**
  String get tenantStatusMovedOut;

  /// No description provided for @addTenant.
  ///
  /// In en, this message translates to:
  /// **'Add tenant'**
  String get addTenant;

  /// No description provided for @editTenant.
  ///
  /// In en, this message translates to:
  /// **'Edit tenant'**
  String get editTenant;

  /// No description provided for @deleteTenant.
  ///
  /// In en, this message translates to:
  /// **'Delete tenant'**
  String get deleteTenant;

  /// No description provided for @deleteTenantConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this tenant?'**
  String get deleteTenantConfirm;

  /// No description provided for @tenantAddSuccess.
  ///
  /// In en, this message translates to:
  /// **'Tenant added successfully'**
  String get tenantAddSuccess;

  /// No description provided for @tenantUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Tenant updated successfully'**
  String get tenantUpdateSuccess;

  /// No description provided for @tenantDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Tenant deleted successfully'**
  String get tenantDeleteSuccess;

  /// No description provided for @noTenantsFound.
  ///
  /// In en, this message translates to:
  /// **'No tenants found'**
  String get noTenantsFound;

  /// No description provided for @tenantDetails.
  ///
  /// In en, this message translates to:
  /// **'Tenant details'**
  String get tenantDetails;

  /// No description provided for @tenantInformation.
  ///
  /// In en, this message translates to:
  /// **'Tenant information'**
  String get tenantInformation;

  /// No description provided for @tenantDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get tenantDocuments;

  /// No description provided for @tenantPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get tenantPayments;

  /// No description provided for @tenantMaintenanceRequests.
  ///
  /// In en, this message translates to:
  /// **'Maintenance requests'**
  String get tenantMaintenanceRequests;

  /// No description provided for @tenantNotesAndHistory.
  ///
  /// In en, this message translates to:
  /// **'Notes and history'**
  String get tenantNotesAndHistory;

  /// No description provided for @uploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload document'**
  String get uploadDocument;

  /// No description provided for @documentType.
  ///
  /// In en, this message translates to:
  /// **'Document type'**
  String get documentType;

  /// No description provided for @documentName.
  ///
  /// In en, this message translates to:
  /// **'Document name'**
  String get documentName;

  /// No description provided for @documentUploadDate.
  ///
  /// In en, this message translates to:
  /// **'Upload date'**
  String get documentUploadDate;

  /// No description provided for @noDocuments.
  ///
  /// In en, this message translates to:
  /// **'No documents'**
  String get noDocuments;

  /// No description provided for @addDocument.
  ///
  /// In en, this message translates to:
  /// **'Add document'**
  String get addDocument;

  /// No description provided for @documentAddSuccess.
  ///
  /// In en, this message translates to:
  /// **'Document added successfully'**
  String get documentAddSuccess;

  /// No description provided for @documentDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Document deleted successfully'**
  String get documentDeleteSuccess;

  /// No description provided for @documentDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this document?'**
  String get documentDeleteConfirm;

  /// No description provided for @asset.
  ///
  /// In en, this message translates to:
  /// **'Asset'**
  String get asset;

  /// No description provided for @assetName.
  ///
  /// In en, this message translates to:
  /// **'Asset name'**
  String get assetName;

  /// No description provided for @assetCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get assetCategory;

  /// No description provided for @assetCondition.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get assetCondition;

  /// No description provided for @assetStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get assetStatus;

  /// No description provided for @assetPurchaseDate.
  ///
  /// In en, this message translates to:
  /// **'Purchase date'**
  String get assetPurchaseDate;

  /// No description provided for @assetPurchasePrice.
  ///
  /// In en, this message translates to:
  /// **'Purchase price'**
  String get assetPurchasePrice;

  /// No description provided for @assetSerialNumber.
  ///
  /// In en, this message translates to:
  /// **'Serial number'**
  String get assetSerialNumber;

  /// No description provided for @assetModel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get assetModel;

  /// No description provided for @assetBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get assetBrand;

  /// No description provided for @assetSupplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get assetSupplier;

  /// No description provided for @assetWarrantyExpiry.
  ///
  /// In en, this message translates to:
  /// **'Warranty expiry'**
  String get assetWarrantyExpiry;

  /// No description provided for @assetLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get assetLocation;

  /// No description provided for @assetAssignedTo.
  ///
  /// In en, this message translates to:
  /// **'Assigned to'**
  String get assetAssignedTo;

  /// No description provided for @assetNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get assetNotes;

  /// No description provided for @assetConditionNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get assetConditionNew;

  /// No description provided for @assetConditionGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get assetConditionGood;

  /// No description provided for @assetConditionFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get assetConditionFair;

  /// No description provided for @assetConditionPoor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get assetConditionPoor;

  /// No description provided for @assetConditionDamaged.
  ///
  /// In en, this message translates to:
  /// **'Damaged'**
  String get assetConditionDamaged;

  /// No description provided for @assetStatusAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get assetStatusAvailable;

  /// No description provided for @assetStatusInUse.
  ///
  /// In en, this message translates to:
  /// **'In use'**
  String get assetStatusInUse;

  /// No description provided for @assetStatusMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Under maintenance'**
  String get assetStatusMaintenance;

  /// No description provided for @assetStatusDisposed.
  ///
  /// In en, this message translates to:
  /// **'Disposed'**
  String get assetStatusDisposed;

  /// No description provided for @assetStatusLost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get assetStatusLost;

  /// No description provided for @addAsset.
  ///
  /// In en, this message translates to:
  /// **'Add asset'**
  String get addAsset;

  /// No description provided for @editAsset.
  ///
  /// In en, this message translates to:
  /// **'Edit asset'**
  String get editAsset;

  /// No description provided for @deleteAsset.
  ///
  /// In en, this message translates to:
  /// **'Delete asset'**
  String get deleteAsset;

  /// No description provided for @deleteAssetConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this asset?'**
  String get deleteAssetConfirm;

  /// No description provided for @assetAddSuccess.
  ///
  /// In en, this message translates to:
  /// **'Asset added successfully'**
  String get assetAddSuccess;

  /// No description provided for @assetUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Asset updated successfully'**
  String get assetUpdateSuccess;

  /// No description provided for @assetDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Asset deleted successfully'**
  String get assetDeleteSuccess;

  /// No description provided for @noAssetsFound.
  ///
  /// In en, this message translates to:
  /// **'No assets found'**
  String get noAssetsFound;

  /// No description provided for @assetDetails.
  ///
  /// In en, this message translates to:
  /// **'Asset details'**
  String get assetDetails;

  /// No description provided for @assetInformation.
  ///
  /// In en, this message translates to:
  /// **'Asset information'**
  String get assetInformation;

  /// No description provided for @assetMaintenanceHistory.
  ///
  /// In en, this message translates to:
  /// **'Maintenance history'**
  String get assetMaintenanceHistory;

  /// No description provided for @assetDepreciation.
  ///
  /// In en, this message translates to:
  /// **'Depreciation'**
  String get assetDepreciation;

  /// No description provided for @assetValue.
  ///
  /// In en, this message translates to:
  /// **'Current value'**
  String get assetValue;

  /// No description provided for @assetPurchaseInfo.
  ///
  /// In en, this message translates to:
  /// **'Purchase information'**
  String get assetPurchaseInfo;

  /// No description provided for @assetWarrantyInfo.
  ///
  /// In en, this message translates to:
  /// **'Warranty information'**
  String get assetWarrantyInfo;

  /// No description provided for @assetLocationInfo.
  ///
  /// In en, this message translates to:
  /// **'Location information'**
  String get assetLocationInfo;

  /// No description provided for @assetAssignmentHistory.
  ///
  /// In en, this message translates to:
  /// **'Assignment history'**
  String get assetAssignmentHistory;

  /// No description provided for @assignAsset.
  ///
  /// In en, this message translates to:
  /// **'Assign asset'**
  String get assignAsset;

  /// No description provided for @unassignAsset.
  ///
  /// In en, this message translates to:
  /// **'Unassign asset'**
  String get unassignAsset;

  /// No description provided for @assetAssignmentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Asset assigned successfully'**
  String get assetAssignmentSuccess;

  /// No description provided for @assetUnassignmentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Asset unassigned successfully'**
  String get assetUnassignmentSuccess;

  /// No description provided for @scheduleMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Schedule maintenance'**
  String get scheduleMaintenance;

  /// No description provided for @maintenanceScheduled.
  ///
  /// In en, this message translates to:
  /// **'Maintenance scheduled'**
  String get maintenanceScheduled;

  /// No description provided for @maintenanceCompleted.
  ///
  /// In en, this message translates to:
  /// **'Maintenance completed'**
  String get maintenanceCompleted;

  /// No description provided for @maintenanceCancelled.
  ///
  /// In en, this message translates to:
  /// **'Maintenance cancelled'**
  String get maintenanceCancelled;

  /// No description provided for @maintenanceHistory.
  ///
  /// In en, this message translates to:
  /// **'Maintenance history'**
  String get maintenanceHistory;

  /// No description provided for @noMaintenanceHistory.
  ///
  /// In en, this message translates to:
  /// **'No maintenance history'**
  String get noMaintenanceHistory;

  /// No description provided for @maintenanceType.
  ///
  /// In en, this message translates to:
  /// **'Maintenance type'**
  String get maintenanceType;

  /// No description provided for @maintenanceDate.
  ///
  /// In en, this message translates to:
  /// **'Maintenance date'**
  String get maintenanceDate;

  /// No description provided for @maintenanceCost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get maintenanceCost;

  /// No description provided for @maintenanceDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get maintenanceDescription;

  /// No description provided for @maintenanceTechnician.
  ///
  /// In en, this message translates to:
  /// **'Technician'**
  String get maintenanceTechnician;

  /// No description provided for @maintenanceStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get maintenanceStatus;

  /// No description provided for @maintenanceStatusScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get maintenanceStatusScheduled;

  /// No description provided for @maintenanceStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get maintenanceStatusInProgress;

  /// No description provided for @maintenanceStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get maintenanceStatusCompleted;

  /// No description provided for @maintenanceStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get maintenanceStatusCancelled;

  /// No description provided for @addMaintenanceRecord.
  ///
  /// In en, this message translates to:
  /// **'Add maintenance record'**
  String get addMaintenanceRecord;

  /// No description provided for @editMaintenanceRecord.
  ///
  /// In en, this message translates to:
  /// **'Edit maintenance record'**
  String get editMaintenanceRecord;

  /// No description provided for @deleteMaintenanceRecord.
  ///
  /// In en, this message translates to:
  /// **'Delete maintenance record'**
  String get deleteMaintenanceRecord;

  /// No description provided for @deleteMaintenanceRecordConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this maintenance record?'**
  String get deleteMaintenanceRecordConfirm;

  /// No description provided for @maintenanceRecordAddSuccess.
  ///
  /// In en, this message translates to:
  /// **'Maintenance record added successfully'**
  String get maintenanceRecordAddSuccess;

  /// No description provided for @maintenanceRecordUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Maintenance record updated successfully'**
  String get maintenanceRecordUpdateSuccess;

  /// No description provided for @maintenanceRecordDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Maintenance record deleted successfully'**
  String get maintenanceRecordDeleteSuccess;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @paymentAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get paymentAmount;

  /// No description provided for @paymentDate.
  ///
  /// In en, this message translates to:
  /// **'Payment date'**
  String get paymentDate;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethod;

  /// No description provided for @paymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get paymentStatus;

  /// No description provided for @paymentReference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get paymentReference;

  /// No description provided for @paymentNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get paymentNotes;

  /// No description provided for @paymentFor.
  ///
  /// In en, this message translates to:
  /// **'Payment for'**
  String get paymentFor;

  /// No description provided for @paymentType.
  ///
  /// In en, this message translates to:
  /// **'Payment type'**
  String get paymentType;

  /// No description provided for @paymentReceivedBy.
  ///
  /// In en, this message translates to:
  /// **'Received by'**
  String get paymentReceivedBy;

  /// No description provided for @paymentReceivedFrom.
  ///
  /// In en, this message translates to:
  /// **'Received from'**
  String get paymentReceivedFrom;

  /// No description provided for @paymentStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paymentStatusPaid;

  /// No description provided for @paymentStatusUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get paymentStatusUnpaid;

  /// No description provided for @paymentStatusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get paymentStatusOverdue;

  /// No description provided for @paymentStatusPartial.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get paymentStatusPartial;

  /// No description provided for @paymentStatusRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get paymentStatusRefunded;

  /// No description provided for @paymentStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get paymentStatusCancelled;

  /// No description provided for @paymentMethodCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentMethodCash;

  /// No description provided for @paymentMethodBankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank transfer'**
  String get paymentMethodBankTransfer;

  /// No description provided for @paymentMethodCheck.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get paymentMethodCheck;

  /// No description provided for @paymentMethodCreditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit card'**
  String get paymentMethodCreditCard;

  /// No description provided for @paymentMethodDebitCard.
  ///
  /// In en, this message translates to:
  /// **'Debit card'**
  String get paymentMethodDebitCard;

  /// No description provided for @paymentMethodMobileMoney.
  ///
  /// In en, this message translates to:
  /// **'Mobile money'**
  String get paymentMethodMobileMoney;

  /// No description provided for @paymentMethodOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get paymentMethodOther;

  /// No description provided for @paymentTypeRent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get paymentTypeRent;

  /// No description provided for @paymentTypeDeposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get paymentTypeDeposit;

  /// No description provided for @paymentTypeUtility.
  ///
  /// In en, this message translates to:
  /// **'Utility'**
  String get paymentTypeUtility;

  /// No description provided for @paymentTypeMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get paymentTypeMaintenance;

  /// No description provided for @paymentTypePenalty.
  ///
  /// In en, this message translates to:
  /// **'Penalty'**
  String get paymentTypePenalty;

  /// No description provided for @paymentTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get paymentTypeOther;

  /// No description provided for @addPayment.
  ///
  /// In en, this message translates to:
  /// **'Add payment'**
  String get addPayment;

  /// No description provided for @editPayment.
  ///
  /// In en, this message translates to:
  /// **'Edit payment'**
  String get editPayment;

  /// No description provided for @deletePayment.
  ///
  /// In en, this message translates to:
  /// **'Delete payment'**
  String get deletePayment;

  /// No description provided for @deletePaymentConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this payment?'**
  String get deletePaymentConfirm;

  /// No description provided for @paymentAddSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment added successfully'**
  String get paymentAddSuccess;

  /// No description provided for @paymentUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment updated successfully'**
  String get paymentUpdateSuccess;

  /// No description provided for @paymentDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment deleted successfully'**
  String get paymentDeleteSuccess;

  /// No description provided for @noPaymentsFound.
  ///
  /// In en, this message translates to:
  /// **'No payments found'**
  String get noPaymentsFound;

  /// No description provided for @paymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Payment details'**
  String get paymentDetails;

  /// No description provided for @paymentInformation.
  ///
  /// In en, this message translates to:
  /// **'Payment information'**
  String get paymentInformation;

  /// No description provided for @paymentReceipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get paymentReceipt;

  /// No description provided for @generateReceipt.
  ///
  /// In en, this message translates to:
  /// **'Generate receipt'**
  String get generateReceipt;

  /// No description provided for @sendReceipt.
  ///
  /// In en, this message translates to:
  /// **'Send receipt'**
  String get sendReceipt;

  /// No description provided for @receiptSent.
  ///
  /// In en, this message translates to:
  /// **'Receipt sent'**
  String get receiptSent;

  /// No description provided for @receiptGenerationFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate receipt'**
  String get receiptGenerationFailed;

  /// No description provided for @sendReceiptFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send receipt'**
  String get sendReceiptFailed;

  /// No description provided for @paymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment history'**
  String get paymentHistory;

  /// No description provided for @paymentSummary.
  ///
  /// In en, this message translates to:
  /// **'Payment summary'**
  String get paymentSummary;

  /// No description provided for @totalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total paid'**
  String get totalPaid;

  /// No description provided for @totalDue.
  ///
  /// In en, this message translates to:
  /// **'Total due'**
  String get totalDue;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @outstandingBalance.
  ///
  /// In en, this message translates to:
  /// **'Outstanding balance'**
  String get outstandingBalance;

  /// No description provided for @paymentReminder.
  ///
  /// In en, this message translates to:
  /// **'Payment reminder'**
  String get paymentReminder;

  /// No description provided for @tasksReminder.
  ///
  /// In en, this message translates to:
  /// **'Tasks reminder'**
  String get tasksReminder;

  /// No description provided for @sendReminder.
  ///
  /// In en, this message translates to:
  /// **'Send reminder'**
  String get sendReminder;

  /// No description provided for @reminderSent.
  ///
  /// In en, this message translates to:
  /// **'Reminder sent'**
  String get reminderSent;

  /// No description provided for @sendReminderFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send reminder'**
  String get sendReminderFailed;

  /// No description provided for @paymentReminderMessage.
  ///
  /// In en, this message translates to:
  /// **'This is a reminder for payment of {amount} for {purpose} due on {dueDate}.'**
  String paymentReminderMessage(Object amount, Object dueDate, Object purpose);

  /// No description provided for @paymentOverdueMessage.
  ///
  /// In en, this message translates to:
  /// **'The payment of {amount} for {purpose} is overdue. Please pay as soon as possible to avoid inconvenience.'**
  String paymentOverdueMessage(Object amount, Object purpose);

  /// No description provided for @paymentConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your payment of {amount} for {purpose}. The transaction has been processed successfully.'**
  String paymentConfirmationMessage(Object amount, Object purpose);

  /// No description provided for @paymentReceiptMessage.
  ///
  /// In en, this message translates to:
  /// **'Please find attached the receipt for the payment of {amount} for {purpose}. Thank you!'**
  String paymentReceiptMessage(Object amount, Object purpose);

  /// No description provided for @paymentReceiptSubject.
  ///
  /// In en, this message translates to:
  /// **'Payment Receipt - {receiptNumber}'**
  String paymentReceiptSubject(Object receiptNumber);

  /// No description provided for @paymentReminderSubject.
  ///
  /// In en, this message translates to:
  /// **'Payment Reminder - {invoiceNumber}'**
  String paymentReminderSubject(Object invoiceNumber);

  /// No description provided for @paymentOverdueSubject.
  ///
  /// In en, this message translates to:
  /// **'Payment Overdue - {invoiceNumber}'**
  String paymentOverdueSubject(Object invoiceNumber);

  /// No description provided for @paymentConfirmationSubject.
  ///
  /// In en, this message translates to:
  /// **'Payment Confirmation - {invoiceNumber}'**
  String paymentConfirmationSubject(Object invoiceNumber);

  /// No description provided for @invoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Invoice #{number}'**
  String invoiceNumber(Object number);

  /// No description provided for @receiptNumber.
  ///
  /// In en, this message translates to:
  /// **'Receipt #{number}'**
  String receiptNumber(Object number);

  /// No description provided for @issueDate.
  ///
  /// In en, this message translates to:
  /// **'Issue date'**
  String get issueDate;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @unitPrice.
  ///
  /// In en, this message translates to:
  /// **'Unit price'**
  String get unitPrice;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @amountPaid.
  ///
  /// In en, this message translates to:
  /// **'Amount paid'**
  String get amountPaid;

  /// No description provided for @amountDue.
  ///
  /// In en, this message translates to:
  /// **'Amount due'**
  String get amountDue;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter Amount'**
  String get enterAmount;

  /// No description provided for @pleaseEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount'**
  String get pleaseEnterAmount;

  /// No description provided for @pleaseEnterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get pleaseEnterValidAmount;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get termsAndConditions;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you!'**
  String get thankYou;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactUs;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @invoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoice;

  /// No description provided for @receipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get receipt;

  /// No description provided for @invoiceTo.
  ///
  /// In en, this message translates to:
  /// **'Invoice to'**
  String get invoiceTo;

  /// No description provided for @receiptFor.
  ///
  /// In en, this message translates to:
  /// **'Receipt for'**
  String get receiptFor;

  /// No description provided for @paidOn.
  ///
  /// In en, this message translates to:
  /// **'Paid on'**
  String get paidOn;

  /// No description provided for @paidBy.
  ///
  /// In en, this message translates to:
  /// **'Paid by'**
  String get paidBy;

  /// No description provided for @memo.
  ///
  /// In en, this message translates to:
  /// **'Memo'**
  String get memo;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @dateTransfer.
  ///
  /// In en, this message translates to:
  /// **'Date transfer'**
  String get dateTransfer;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @balanceDue.
  ///
  /// In en, this message translates to:
  /// **'Balance due'**
  String get balanceDue;

  /// No description provided for @makePayment.
  ///
  /// In en, this message translates to:
  /// **'Make payment'**
  String get makePayment;

  /// No description provided for @printReceipt.
  ///
  /// In en, this message translates to:
  /// **'Print receipt'**
  String get printReceipt;

  /// No description provided for @downloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get downloadPdf;

  /// No description provided for @sendEmail.
  ///
  /// In en, this message translates to:
  /// **'Send email'**
  String get sendEmail;

  /// No description provided for @markAsPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark as paid'**
  String get markAsPaid;

  /// No description provided for @noPaymentHistory.
  ///
  /// In en, this message translates to:
  /// **'No payment history'**
  String get noPaymentHistory;

  /// No description provided for @paymentMethodDetails.
  ///
  /// In en, this message translates to:
  /// **'Payment method details'**
  String get paymentMethodDetails;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card number'**
  String get cardNumber;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry date'**
  String get expiryDate;

  /// No description provided for @cvv.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get cvv;

  /// No description provided for @nameOnCard.
  ///
  /// In en, this message translates to:
  /// **'Name on card'**
  String get nameOnCard;

  /// No description provided for @bankName.
  ///
  /// In en, this message translates to:
  /// **'Bank name'**
  String get bankName;

  /// No description provided for @accountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account number'**
  String get accountNumber;

  /// No description provided for @routingNumber.
  ///
  /// In en, this message translates to:
  /// **'Routing number'**
  String get routingNumber;

  /// No description provided for @checkNumber.
  ///
  /// In en, this message translates to:
  /// **'Check number'**
  String get checkNumber;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get mobileNumber;

  /// No description provided for @network.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get network;

  /// No description provided for @transactionId.
  ///
  /// In en, this message translates to:
  /// **'Transaction ID'**
  String get transactionId;

  /// No description provided for @paymentConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Payment confirmation'**
  String get paymentConfirmation;

  /// No description provided for @paymentSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Payment successful'**
  String get paymentSuccessful;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed'**
  String get paymentFailed;

  /// No description provided for @paymentProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing payment...'**
  String get paymentProcessing;

  /// No description provided for @paymentVerification.
  ///
  /// In en, this message translates to:
  /// **'Verifying payment...'**
  String get paymentVerification;

  /// No description provided for @paymentRedirect.
  ///
  /// In en, this message translates to:
  /// **'Redirecting to payment gateway...'**
  String get paymentRedirect;

  /// No description provided for @paymentCancelled.
  ///
  /// In en, this message translates to:
  /// **'Payment cancelled'**
  String get paymentCancelled;

  /// No description provided for @paymentError.
  ///
  /// In en, this message translates to:
  /// **'Payment error'**
  String get paymentError;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get contactSupport;

  /// No description provided for @paymentSecurityMessage.
  ///
  /// In en, this message translates to:
  /// **'Your transaction is secure and encrypted.'**
  String get paymentSecurityMessage;

  /// No description provided for @paymentPrivacyMessage.
  ///
  /// In en, this message translates to:
  /// **'We do not store your payment information.'**
  String get paymentPrivacyMessage;

  /// No description provided for @paymentTerms.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms of Service and Privacy Policy.'**
  String get paymentTerms;

  /// No description provided for @refundPolicy.
  ///
  /// In en, this message translates to:
  /// **'Refund policy'**
  String get refundPolicy;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get termsOfService;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @frequentlyAskedQuestions.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get frequentlyAskedQuestions;

  /// No description provided for @contactCustomerSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact customer support'**
  String get contactCustomerSupport;

  /// No description provided for @liveChat.
  ///
  /// In en, this message translates to:
  /// **'Live chat'**
  String get liveChat;

  /// No description provided for @phoneSupport.
  ///
  /// In en, this message translates to:
  /// **'Phone support'**
  String get phoneSupport;

  /// No description provided for @emailSupport.
  ///
  /// In en, this message translates to:
  /// **'Email support'**
  String get emailSupport;

  /// No description provided for @businessHours.
  ///
  /// In en, this message translates to:
  /// **'Business hours'**
  String get businessHours;

  /// No description provided for @mondayToFriday.
  ///
  /// In en, this message translates to:
  /// **'Monday - Friday'**
  String get mondayToFriday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @emergencySupport.
  ///
  /// In en, this message translates to:
  /// **'For emergency support, please call our 24/7 hotline.'**
  String get emergencySupport;

  /// No description provided for @thankYouForContactingUs.
  ///
  /// In en, this message translates to:
  /// **'Thank you for contacting us. We will reply as soon as possible!'**
  String get thankYouForContactingUs;

  /// No description provided for @yourMessageHasBeenSent.
  ///
  /// In en, this message translates to:
  /// **'Your message has been sent successfully.'**
  String get yourMessageHasBeenSent;

  /// No description provided for @weAppreciateYourFeedback.
  ///
  /// In en, this message translates to:
  /// **'We appreciate your feedback and will get back to you shortly.'**
  String get weAppreciateYourFeedback;

  /// No description provided for @sorryForTheInconvenience.
  ///
  /// In en, this message translates to:
  /// **'We apologize for the inconvenience. Please try again later or contact support if the issue persists.'**
  String get sorryForTheInconvenience;

  /// No description provided for @pageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFound;

  /// No description provided for @thePageYouAreLookingFor.
  ///
  /// In en, this message translates to:
  /// **'The page you are looking for may have been removed, renamed, or is temporarily unavailable.'**
  String get thePageYouAreLookingFor;

  /// No description provided for @goToHomepage.
  ///
  /// In en, this message translates to:
  /// **'Go to homepage'**
  String get goToHomepage;

  /// No description provided for @oopsSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong.'**
  String get oopsSomethingWentWrong;

  /// No description provided for @weAreWorkingOnIt.
  ///
  /// In en, this message translates to:
  /// **'We\'re working on it. Please try later.'**
  String get weAreWorkingOnIt;

  /// No description provided for @serviceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Service unavailable'**
  String get serviceUnavailable;

  /// No description provided for @theServiceIsTemporarilyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The service is temporarily unavailable. Please try again later.'**
  String get theServiceIsTemporarilyUnavailable;

  /// No description provided for @maintenanceInProgress.
  ///
  /// In en, this message translates to:
  /// **'Maintenance in progress'**
  String get maintenanceInProgress;

  /// No description provided for @weAreCurrentlyPerformingScheduledMaintenance.
  ///
  /// In en, this message translates to:
  /// **'We are currently performing scheduled maintenance. We\'ll be back soon.'**
  String get weAreCurrentlyPerformingScheduledMaintenance;

  /// No description provided for @estimatedCompletionTime.
  ///
  /// In en, this message translates to:
  /// **'Estimated completion time: {time}'**
  String estimatedCompletionTime(Object time);

  /// No description provided for @thankYouForYourPatience.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your patience.'**
  String get thankYouForYourPatience;

  /// No description provided for @accessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get accessDenied;

  /// No description provided for @youDoNotHavePermission.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to access this page.'**
  String get youDoNotHavePermission;

  /// No description provided for @pleaseContactYourAdministrator.
  ///
  /// In en, this message translates to:
  /// **'Please contact your administrator if you believe this is an error.'**
  String get pleaseContactYourAdministrator;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired'**
  String get sessionExpired;

  /// No description provided for @yourSessionHasExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again to continue.'**
  String get yourSessionHasExpired;

  /// No description provided for @logInAgain.
  ///
  /// In en, this message translates to:
  /// **'Sign in again'**
  String get logInAgain;

  /// No description provided for @youHaveBeenLoggedOut.
  ///
  /// In en, this message translates to:
  /// **'You have been logged out successfully.'**
  String get youHaveBeenLoggedOut;

  /// No description provided for @logInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to continue.'**
  String get logInToContinue;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// No description provided for @enterYourCredentials.
  ///
  /// In en, this message translates to:
  /// **'Enter your credentials to access your account.'**
  String get enterYourCredentials;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgotYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotYourPassword;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAnAccount;

  /// No description provided for @signUpNow.
  ///
  /// In en, this message translates to:
  /// **'Sign up now'**
  String get signUpNow;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get or;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @signInWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Facebook'**
  String get signInWithFacebook;

  /// No description provided for @signInWithApple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signInWithApple;

  /// No description provided for @bySigningInYouAgree.
  ///
  /// In en, this message translates to:
  /// **'By signing in you agree to '**
  String get bySigningInYouAgree;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @createAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAnAccount;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAnAccount;

  /// No description provided for @signInHere.
  ///
  /// In en, this message translates to:
  /// **'Sign in here'**
  String get signInHere;

  /// No description provided for @iAgreeToThe.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get iAgreeToThe;

  /// No description provided for @privacyPolicyAndTerms.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy and Terms of Service'**
  String get privacyPolicyAndTerms;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get verificationCode;

  /// No description provided for @enterTheVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code sent to {email}'**
  String enterTheVerificationCode(Object email);

  /// No description provided for @didntReceiveTheCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get didntReceiveTheCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @verificationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Verification successful!'**
  String get verificationSuccessful;

  /// No description provided for @yourAccountHasBeenVerified.
  ///
  /// In en, this message translates to:
  /// **'Your account has been verified successfully.'**
  String get yourAccountHasBeenVerified;

  /// No description provided for @continueToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Continue to Dashboard'**
  String get continueToDashboard;

  /// No description provided for @resetYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get resetYourPassword;

  /// No description provided for @enterYourEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get enterYourEmailAddress;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get sendResetLink;

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get backToSignIn;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Reset link sent!'**
  String get resetLinkSent;

  /// No description provided for @weHaveSentYouAnEmail.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent you an email with password reset instructions.'**
  String get weHaveSentYouAnEmail;

  /// No description provided for @checkYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get checkYourEmail;

  /// No description provided for @createNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create new password'**
  String get createNewPassword;

  /// No description provided for @yourNewPasswordMustBeDifferent.
  ///
  /// In en, this message translates to:
  /// **'Your new password must be different from the previous one.'**
  String get yourNewPasswordMustBeDifferent;

  /// No description provided for @activeUsers.
  ///
  /// In en, this message translates to:
  /// **'Active Users'**
  String get activeUsers;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'vi': return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
