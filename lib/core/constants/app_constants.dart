class AppConstants {
  AppConstants._();

  // Storage Keys
  static const String userIdKey = 'user_id';
  static const String userNameKey = 'user_name';
  static const String friendCodeKey = 'friend_code';
  static const String partnerIdKey = 'partner_id';
  static const String partnerNameKey = 'partner_name';
  static const String guideKey = 'guide';
  static const String salaryKey = 'salary';
  static const String salaryTypeKey = 'salary_type';
  static const String accumulatedBalanceKey = 'accumulated_balance';
  static const String migratedKey = 'migrated';
  static const String authUserIdKey = 'auth_user_id';
  static const String emailKey = 'email';

  // Routes
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String gastosRoute = '/gastos';
  static const String ingresosRoute = '/ingresos';
  static const String ahorrosRoute = '/ahorros';
  static const String migrateRoute = '/migrate';
  static const String forgotPasswordRoute = '/forgot-password';
  static const String resetPasswordRoute = '/reset-password';

  // Animation Durations
  static const Duration shortDuration = Duration(milliseconds: 300);
  static const Duration mediumDuration = Duration(milliseconds: 500);
}
