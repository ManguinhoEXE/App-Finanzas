// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Aura';

  @override
  String get appTagline => 'Private Financial Network';

  @override
  String get loginUsernameLabel => 'Username';

  @override
  String get loginUsernameHint => 'Your username';

  @override
  String get loginUsernameValidationEmpty => 'Enter your username';

  @override
  String get loginPasswordLabel => 'PASSWORD';

  @override
  String get loginPasswordValidationEmpty => 'Enter your password';

  @override
  String get loginButton => 'LOG IN';

  @override
  String get loginNoAccountPrefix => 'Don\'t have an account? ';

  @override
  String get loginRegisterLink => 'Sign up';

  @override
  String get loginSecurityBadge => 'END-TO-END ENCRYPTION';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerSubtitle => 'JOIN AURA';

  @override
  String get registerUsernameLabel => 'Username';

  @override
  String get registerUsernameHint => 'Choose a username';

  @override
  String get registerUsernameValidationEmpty => 'Enter a username';

  @override
  String get registerUsernameValidationMinLength => 'Minimum 3 characters';

  @override
  String get registerPasswordLabel => 'PASSWORD';

  @override
  String get registerPasswordValidationEmpty => 'Enter a password';

  @override
  String get registerPasswordValidationMinLength => 'Minimum 6 characters';

  @override
  String get registerConfirmPasswordLabel => 'CONFIRM PASSWORD';

  @override
  String get registerConfirmPasswordValidationEmpty => 'Confirm your password';

  @override
  String get registerConfirmPasswordValidationMismatch => 'Passwords do not match';

  @override
  String get registerButton => 'CREATE ACCOUNT';

  @override
  String get registerHasAccountPrefix => 'Already have an account? ';

  @override
  String get registerLoginLink => 'Log in';

  @override
  String get friendCodeCopiedMessage => 'Code copied to clipboard';

  @override
  String get friendCodeEmptyValidation => 'Enter a friend code';

  @override
  String friendCodeLinkedMessage(Object partnerName) {
    return 'Linked with $partnerName';
  }

  @override
  String get friendCodeSheetTitle => 'FRIEND NETWORK';

  @override
  String get friendCodePartnerLabel => 'YOUR LINKED FRIEND';

  @override
  String get friendCodeUnlinkButton => 'UNLINK';

  @override
  String get friendCodeMyCodeLabel => 'MY FRIEND CODE';

  @override
  String get friendCodeTapToCopy => 'Tap to copy';

  @override
  String get friendCodeLinkFriendSection => 'LINK FRIEND';

  @override
  String get friendCodeLinkFriendDescription => 'Enter the friend code of the person you want to share with';

  @override
  String get friendCodeLinkButton => 'LINK';

  @override
  String get onboardingPage1Title => 'Welcome to Aura';

  @override
  String get onboardingPage1Description => 'Your personal financial assistant. Track your expenses and save to reach your goals.';

  @override
  String get onboardingPage2Title => 'Manage your Expenses';

  @override
  String get onboardingPage2Description => 'Record every expense, organize them by category and review your financial flow month by month.';

  @override
  String get onboardingPage3Title => 'Reach your Goals';

  @override
  String get onboardingPage3Description => 'Create savings goals, deposit funds and visualize your progress towards your objectives.';

  @override
  String get onboardingPage4Title => 'Share with Friends';

  @override
  String get onboardingPage4Description => 'Link your account with friends to share savings goals together.';

  @override
  String get onboardingStartButton => 'GET STARTED';

  @override
  String get onboardingNextButton => 'NEXT';

  @override
  String get gastosModuleTab => 'Expenses';

  @override
  String get ingresosModuleTab => 'Income';

  @override
  String get ahorrosModuleTab => 'Savings';

  @override
  String get gastosTotalLabel => 'TOTAL EXPENSES';

  @override
  String get gastosFinancialFlowTitle => 'Financial Flow';

  @override
  String get gastosEmptyMessage => 'No expenses recorded';

  @override
  String get retryButton => 'Retry';

  @override
  String get gastoCategoryTransport => 'Transport';

  @override
  String get gastoCategoryEntertainment => 'Entertainment';

  @override
  String get gastoCategoryFood => 'Food';

  @override
  String get gastoCategoryHousing => 'Housing';

  @override
  String get gastoEditTitle => 'EDIT EXPENSE';

  @override
  String get gastoCategoryLabel => 'CATEGORY';

  @override
  String get gastoCategoryHint => 'Select or type one...';

  @override
  String get gastoDescriptionLabel => 'DESCRIPTION';

  @override
  String get gastoDescriptionHint => 'e.g. Lunch at restaurant';

  @override
  String get gastoAmountLabel => 'AMOUNT';

  @override
  String get gastoDateLabel => 'DATE';

  @override
  String get gastoSharedLabel => 'Shared';

  @override
  String get gastoUpdateButton => 'UPDATE';

  @override
  String get gastoCreateTitle => 'NEW EXPENSE';

  @override
  String get gastoShareLabel => 'Share';

  @override
  String get gastoSaveButton => 'SAVE EXPENSE';

  @override
  String get validationRequired => 'Required';

  @override
  String get validationInvalidNumber => 'Invalid number';

  @override
  String get exportGastosTitle => 'EXPORT EXPENSES';

  @override
  String get exportGastosSubtitle => 'Choose the range to export';

  @override
  String get exportGastosCurrentMonth => 'Current month';

  @override
  String get exportGastosLast3Months => 'Last 3 months';

  @override
  String get exportGastosEmptyMonth => 'No expenses for this month';

  @override
  String get exportGastosEmpty3Months => 'No expenses in the last 3 months';

  @override
  String exportGastosShareSubject(Object fileName) {
    return 'Export expenses - $fileName';
  }

  @override
  String get exportGastosError => 'Error generating file';

  @override
  String get settingsTitle => 'SETTINGS';

  @override
  String get settingsSalaryLabel => 'MONTHLY SALARY';

  @override
  String get settingsSalaryTypeLabel => 'SALARY TYPE';

  @override
  String get settingsSalaryTypeFixed => 'Fixed';

  @override
  String get settingsSalaryTypeVariable => 'Variable';

  @override
  String get settingsSaveButton => 'SAVE';

  @override
  String get ingresosTotalLabel => 'TOTAL INCOME';

  @override
  String get ingresosListTitle => 'Income';

  @override
  String get ingresosEmptyMessage => 'No income recorded';

  @override
  String get ingresoCreateTitle => 'NEW INCOME';

  @override
  String get ingresoEditTitle => 'EDIT INCOME';

  @override
  String get ingresoCategoryLabel => 'CATEGORY';

  @override
  String get ingresoCategoryHint => 'Select or type one...';

  @override
  String get ingresoCategoryClient => 'Client';

  @override
  String get ingresoCategoryInvestment => 'Investment';

  @override
  String get ingresoCategoryOther => 'Other';

  @override
  String get ingresoDescriptionLabel => 'DESCRIPTION';

  @override
  String get ingresoDescriptionHint => 'e.g. Freelance project payment';

  @override
  String get ingresoAmountLabel => 'AMOUNT';

  @override
  String get ingresoDateLabel => 'DATE';

  @override
  String get ingresoUpdateButton => 'UPDATE';

  @override
  String get ingresoSaveButton => 'SAVE INCOME';

  @override
  String get ahorrosTotalLabel => 'TOTAL SAVED';

  @override
  String get ahorrosNewGoalButton => 'New Goal';

  @override
  String get ahorrosActiveGoalsTitle => 'Active Goals';

  @override
  String get ahorrosEmptyMessage => 'No savings goals';

  @override
  String ahorroCardDeadlineLabel(Object deadline) {
    return 'Goal: $deadline';
  }

  @override
  String ahorroCardTargetLabel(Object targetAmount) {
    return 'Target $targetAmount';
  }

  @override
  String get ahorroDetailCurrentLabel => 'CURRENT';

  @override
  String get ahorroDetailRemainingLabel => 'REMAINING';

  @override
  String get ahorroDepositButton => 'DEPOSIT';

  @override
  String get ahorroWithdrawButton => 'WITHDRAW';

  @override
  String get ahorroMovementsSection => 'MOVEMENTS';

  @override
  String get ahorroNoMovements => 'No movements';

  @override
  String get ahorroMovementDeposit => 'Deposit';

  @override
  String get ahorroMovementWithdraw => 'Withdrawal';

  @override
  String get ahorroAmountLabel => 'AMOUNT';

  @override
  String get ahorroDescriptionOptionalLabel => 'DESCRIPTION (OPTIONAL)';

  @override
  String get ahorroCreateTitle => 'NEW SAVINGS GOAL';

  @override
  String get ahorroNameLabel => 'NAME';

  @override
  String get ahorroNameHint => 'e.g. Beach trip';

  @override
  String get ahorroDescriptionLabel => 'DESCRIPTION';

  @override
  String get ahorroDescriptionHint => 'Savings for vacation...';

  @override
  String get ahorroTargetAmountLabel => 'TARGET AMOUNT';

  @override
  String get validationMustBeGreaterThanZero => 'Must be greater than 0';

  @override
  String get ahorroNoDeadline => 'No deadline';

  @override
  String get ahorroDeadlineOptionalLabel => 'DEADLINE (OPTIONAL)';

  @override
  String get ahorroSharedGoalLabel => 'Shared goal';

  @override
  String get ahorroCreateButton => 'CREATE GOAL';

  @override
  String get ahorroParticipantAddedMessage => 'Participant added';

  @override
  String get errorServer => 'Server error';

  @override
  String get errorCache => 'Cache error';

  @override
  String get errorAuth => 'Authentication error';

  @override
  String get errorNoInternet => 'No internet connection';

  @override
  String get errorInvalidData => 'Invalid data';

  @override
  String get errorUserNotAuthenticated => 'User not authenticated';

  @override
  String get errorUnexpectedServerResponse => 'Unexpected server response';

  @override
  String get errorSignUp => 'Error signing up';

  @override
  String get errorSignIn => 'Error signing in';

  @override
  String get errorAddPartner => 'Error adding friend';

  @override
  String get errorGetGastos => 'Error fetching expenses';

  @override
  String get errorGastoNotFound => 'Expense not found';

  @override
  String get errorGetGasto => 'Error fetching expense';

  @override
  String get errorCreateGasto => 'Error creating expense';

  @override
  String get errorGastoEditPermission => 'You don\'t have permission to edit this expense';

  @override
  String get errorUpdateGasto => 'Error updating expense';

  @override
  String get errorGetIngresos => 'Error fetching income';

  @override
  String get errorIngresoNotFound => 'Income not found';

  @override
  String get errorGetIngreso => 'Error fetching income';

  @override
  String get errorCreateIngreso => 'Error creating income';

  @override
  String get errorIngresoEditPermission => 'You don\'t have permission to edit this income';

  @override
  String get errorUpdateIngreso => 'Error updating income';

  @override
  String get errorGetAhorros => 'Error fetching savings';

  @override
  String get errorAhorroNotFound => 'Goal not found';

  @override
  String get errorGetAhorro => 'Error fetching goal';

  @override
  String get errorCreateAhorro => 'Error creating goal';

  @override
  String get errorAhorroEditPermission => 'You don\'t have permission to edit this goal';

  @override
  String get errorUpdateAhorro => 'Error updating goal';

  @override
  String get errorAhorroDeletePermission => 'You don\'t have permission to delete this goal';

  @override
  String get errorDeleteAhorro => 'Error deleting goal';

  @override
  String get errorDeposit => 'Error depositing';

  @override
  String get errorWithdraw => 'Error withdrawing';

  @override
  String get errorGetMovements => 'Error fetching movements';

  @override
  String get errorAddParticipantPermission => 'You don\'t have permission to add participants';

  @override
  String get errorOnlySharedGoalsCanAddParticipants => 'Participants can only be added to shared goals.';

  @override
  String get errorUserNotFound => 'The specified user does not exist.';

  @override
  String get errorAddParticipant => 'Error adding participant';

  @override
  String get errorExcelGeneration => 'Error generating Excel file';

  @override
  String get monthJan => 'Jan';

  @override
  String get monthFeb => 'Feb';

  @override
  String get monthMar => 'Mar';

  @override
  String get monthApr => 'Apr';

  @override
  String get monthMay => 'May';

  @override
  String get monthJun => 'Jun';

  @override
  String get monthJul => 'Jul';

  @override
  String get monthAgo => 'Aug';

  @override
  String get monthSep => 'Sep';

  @override
  String get monthOct => 'Oct';

  @override
  String get monthNov => 'Nov';

  @override
  String get monthDec => 'Dec';
}
