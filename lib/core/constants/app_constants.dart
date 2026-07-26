class AppConstants {
  AppConstants._();

  // Storage Keys
  static const String userIdKey = 'user_id';
  static const String userNameKey = 'user_name';
  static const String friendCodeKey = 'friend_code';
  static const String partnerIdKey = 'partner_id';
  static const String partnerNameKey = 'partner_name';
  static const String guideKey = 'guide';

  // Routes
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String gastosRoute = '/gastos';
  static const String ahorrosRoute = '/ahorros';

  // Animation Durations
  static const Duration shortDuration = Duration(milliseconds: 300);
  static const Duration mediumDuration = Duration(milliseconds: 500);
}