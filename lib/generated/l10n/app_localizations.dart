import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('es')
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Aura'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In es, this message translates to:
  /// **'Red Financiera Privada'**
  String get appTagline;

  /// No description provided for @loginUsernameLabel.
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get loginUsernameLabel;

  /// No description provided for @loginUsernameHint.
  ///
  /// In es, this message translates to:
  /// **'Tu nombre de usuario'**
  String get loginUsernameHint;

  /// No description provided for @loginUsernameValidationEmpty.
  ///
  /// In es, this message translates to:
  /// **'Ingresa tu nombre de usuario'**
  String get loginUsernameValidationEmpty;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In es, this message translates to:
  /// **'CONTRASEÑA'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordValidationEmpty.
  ///
  /// In es, this message translates to:
  /// **'Ingresa tu contraseña'**
  String get loginPasswordValidationEmpty;

  /// No description provided for @loginButton.
  ///
  /// In es, this message translates to:
  /// **'ENTRAR'**
  String get loginButton;

  /// No description provided for @loginNoAccountPrefix.
  ///
  /// In es, this message translates to:
  /// **'¿No tienes cuenta? '**
  String get loginNoAccountPrefix;

  /// No description provided for @loginRegisterLink.
  ///
  /// In es, this message translates to:
  /// **'Regístrate'**
  String get loginRegisterLink;

  /// No description provided for @loginSecurityBadge.
  ///
  /// In es, this message translates to:
  /// **'CIFRADO DE EXTREMO A EXTREMO'**
  String get loginSecurityBadge;

  /// No description provided for @registerTitle.
  ///
  /// In es, this message translates to:
  /// **'Crear Cuenta'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In es, this message translates to:
  /// **'UNIRTE A AURA'**
  String get registerSubtitle;

  /// No description provided for @registerUsernameLabel.
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get registerUsernameLabel;

  /// No description provided for @registerUsernameHint.
  ///
  /// In es, this message translates to:
  /// **'Elige un nombre de usuario'**
  String get registerUsernameHint;

  /// No description provided for @registerUsernameValidationEmpty.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un nombre de usuario'**
  String get registerUsernameValidationEmpty;

  /// No description provided for @registerUsernameValidationMinLength.
  ///
  /// In es, this message translates to:
  /// **'Mínimo 3 caracteres'**
  String get registerUsernameValidationMinLength;

  /// No description provided for @registerPasswordLabel.
  ///
  /// In es, this message translates to:
  /// **'CONTRASEÑA'**
  String get registerPasswordLabel;

  /// No description provided for @registerPasswordValidationEmpty.
  ///
  /// In es, this message translates to:
  /// **'Ingresa una contraseña'**
  String get registerPasswordValidationEmpty;

  /// No description provided for @registerPasswordValidationMinLength.
  ///
  /// In es, this message translates to:
  /// **'Mínimo 6 caracteres'**
  String get registerPasswordValidationMinLength;

  /// No description provided for @registerConfirmPasswordLabel.
  ///
  /// In es, this message translates to:
  /// **'CONFIRMAR CONTRASEÑA'**
  String get registerConfirmPasswordLabel;

  /// No description provided for @registerConfirmPasswordValidationEmpty.
  ///
  /// In es, this message translates to:
  /// **'Confirma tu contraseña'**
  String get registerConfirmPasswordValidationEmpty;

  /// No description provided for @registerConfirmPasswordValidationMismatch.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get registerConfirmPasswordValidationMismatch;

  /// No description provided for @registerButton.
  ///
  /// In es, this message translates to:
  /// **'CREAR CUENTA'**
  String get registerButton;

  /// No description provided for @registerHasAccountPrefix.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tienes cuenta? '**
  String get registerHasAccountPrefix;

  /// No description provided for @registerLoginLink.
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión'**
  String get registerLoginLink;

  /// No description provided for @friendCodeCopiedMessage.
  ///
  /// In es, this message translates to:
  /// **'Código copiado al portapapeles'**
  String get friendCodeCopiedMessage;

  /// No description provided for @friendCodeEmptyValidation.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un código de amigo'**
  String get friendCodeEmptyValidation;

  /// No description provided for @friendCodeLinkedMessage.
  ///
  /// In es, this message translates to:
  /// **'Vinculado con {partnerName}'**
  String friendCodeLinkedMessage(Object partnerName);

  /// No description provided for @friendCodeSheetTitle.
  ///
  /// In es, this message translates to:
  /// **'RED DE AMIGOS'**
  String get friendCodeSheetTitle;

  /// No description provided for @friendCodePartnerLabel.
  ///
  /// In es, this message translates to:
  /// **'TU AMIGO VINCULADO'**
  String get friendCodePartnerLabel;

  /// No description provided for @friendCodeUnlinkButton.
  ///
  /// In es, this message translates to:
  /// **'DESVINCULAR'**
  String get friendCodeUnlinkButton;

  /// No description provided for @friendCodeMyCodeLabel.
  ///
  /// In es, this message translates to:
  /// **'MI CÓDIGO DE AMIGO'**
  String get friendCodeMyCodeLabel;

  /// No description provided for @friendCodeTapToCopy.
  ///
  /// In es, this message translates to:
  /// **'Toca para copiar'**
  String get friendCodeTapToCopy;

  /// No description provided for @friendCodeLinkFriendSection.
  ///
  /// In es, this message translates to:
  /// **'VINCULAR AMIGO'**
  String get friendCodeLinkFriendSection;

  /// No description provided for @friendCodeLinkFriendDescription.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el código de amigo de la persona con quien quieres compartir'**
  String get friendCodeLinkFriendDescription;

  /// No description provided for @friendCodeLinkButton.
  ///
  /// In es, this message translates to:
  /// **'VINCULAR'**
  String get friendCodeLinkButton;

  /// No description provided for @onboardingPage1Title.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido a Aura'**
  String get onboardingPage1Title;

  /// No description provided for @onboardingPage1Description.
  ///
  /// In es, this message translates to:
  /// **'Tu asistente financiero personal. Controla tus gastos y ahorra para alcanzar tus metas.'**
  String get onboardingPage1Description;

  /// No description provided for @onboardingPage2Title.
  ///
  /// In es, this message translates to:
  /// **'Gestiona tus Gastos'**
  String get onboardingPage2Title;

  /// No description provided for @onboardingPage2Description.
  ///
  /// In es, this message translates to:
  /// **'Registra cada gasto, organízalos por categoría y revisa tu flujo financiero mes a mes.'**
  String get onboardingPage2Description;

  /// No description provided for @onboardingPage3Title.
  ///
  /// In es, this message translates to:
  /// **'Alcanza tus Metas'**
  String get onboardingPage3Title;

  /// No description provided for @onboardingPage3Description.
  ///
  /// In es, this message translates to:
  /// **'Crea metas de ahorro, deposita fondos y visualiza tu progreso hacia tus objetivos.'**
  String get onboardingPage3Description;

  /// No description provided for @onboardingPage4Title.
  ///
  /// In es, this message translates to:
  /// **'Comparte con Amigos'**
  String get onboardingPage4Title;

  /// No description provided for @onboardingPage4Description.
  ///
  /// In es, this message translates to:
  /// **'Vincula tu cuenta con amigos para compartir metas de ahorro juntos.'**
  String get onboardingPage4Description;

  /// No description provided for @onboardingStartButton.
  ///
  /// In es, this message translates to:
  /// **'EMPEZAR'**
  String get onboardingStartButton;

  /// No description provided for @onboardingNextButton.
  ///
  /// In es, this message translates to:
  /// **'SIGUIENTE'**
  String get onboardingNextButton;

  /// No description provided for @gastosModuleTab.
  ///
  /// In es, this message translates to:
  /// **'Gastos'**
  String get gastosModuleTab;

  /// No description provided for @ahorrosModuleTab.
  ///
  /// In es, this message translates to:
  /// **'Ahorros'**
  String get ahorrosModuleTab;

  /// No description provided for @gastosTotalLabel.
  ///
  /// In es, this message translates to:
  /// **'GASTOS TOTALES'**
  String get gastosTotalLabel;

  /// No description provided for @gastosFinancialFlowTitle.
  ///
  /// In es, this message translates to:
  /// **'Flujo Financiero'**
  String get gastosFinancialFlowTitle;

  /// No description provided for @gastosEmptyMessage.
  ///
  /// In es, this message translates to:
  /// **'No hay gastos registrados'**
  String get gastosEmptyMessage;

  /// No description provided for @retryButton.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retryButton;

  /// No description provided for @gastoCategoryTransport.
  ///
  /// In es, this message translates to:
  /// **'Transporte'**
  String get gastoCategoryTransport;

  /// No description provided for @gastoCategoryEntertainment.
  ///
  /// In es, this message translates to:
  /// **'Entretenimiento'**
  String get gastoCategoryEntertainment;

  /// No description provided for @gastoCategoryFood.
  ///
  /// In es, this message translates to:
  /// **'Comida'**
  String get gastoCategoryFood;

  /// No description provided for @gastoCategoryHousing.
  ///
  /// In es, this message translates to:
  /// **'Vivienda'**
  String get gastoCategoryHousing;

  /// No description provided for @gastoEditTitle.
  ///
  /// In es, this message translates to:
  /// **'EDITAR GASTO'**
  String get gastoEditTitle;

  /// No description provided for @gastoCategoryLabel.
  ///
  /// In es, this message translates to:
  /// **'CATEGORÍA'**
  String get gastoCategoryLabel;

  /// No description provided for @gastoCategoryHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona o escribe una...'**
  String get gastoCategoryHint;

  /// No description provided for @gastoDescriptionLabel.
  ///
  /// In es, this message translates to:
  /// **'DESCRIPCIÓN'**
  String get gastoDescriptionLabel;

  /// No description provided for @gastoDescriptionHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Almuerzo en restaurante'**
  String get gastoDescriptionHint;

  /// No description provided for @gastoAmountLabel.
  ///
  /// In es, this message translates to:
  /// **'VALOR'**
  String get gastoAmountLabel;

  /// No description provided for @gastoDateLabel.
  ///
  /// In es, this message translates to:
  /// **'FECHA'**
  String get gastoDateLabel;

  /// No description provided for @gastoSharedLabel.
  ///
  /// In es, this message translates to:
  /// **'Compartido'**
  String get gastoSharedLabel;

  /// No description provided for @gastoUpdateButton.
  ///
  /// In es, this message translates to:
  /// **'ACTUALIZAR'**
  String get gastoUpdateButton;

  /// No description provided for @gastoCreateTitle.
  ///
  /// In es, this message translates to:
  /// **'NUEVO GASTO'**
  String get gastoCreateTitle;

  /// No description provided for @gastoShareLabel.
  ///
  /// In es, this message translates to:
  /// **'Compartir'**
  String get gastoShareLabel;

  /// No description provided for @gastoSaveButton.
  ///
  /// In es, this message translates to:
  /// **'GUARDAR GASTO'**
  String get gastoSaveButton;

  /// No description provided for @validationRequired.
  ///
  /// In es, this message translates to:
  /// **'Requerido'**
  String get validationRequired;

  /// No description provided for @validationInvalidNumber.
  ///
  /// In es, this message translates to:
  /// **'Número inválido'**
  String get validationInvalidNumber;

  /// No description provided for @exportGastosTitle.
  ///
  /// In es, this message translates to:
  /// **'EXPORTAR GASTOS'**
  String get exportGastosTitle;

  /// No description provided for @exportGastosSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Elige el rango a exportar'**
  String get exportGastosSubtitle;

  /// No description provided for @exportGastosCurrentMonth.
  ///
  /// In es, this message translates to:
  /// **'Mes actual'**
  String get exportGastosCurrentMonth;

  /// No description provided for @exportGastosLast3Months.
  ///
  /// In es, this message translates to:
  /// **'Últimos 3 meses'**
  String get exportGastosLast3Months;

  /// No description provided for @exportGastosEmptyMonth.
  ///
  /// In es, this message translates to:
  /// **'No hay gastos para este mes'**
  String get exportGastosEmptyMonth;

  /// No description provided for @exportGastosEmpty3Months.
  ///
  /// In es, this message translates to:
  /// **'No hay gastos en los últimos 3 meses'**
  String get exportGastosEmpty3Months;

  /// No description provided for @exportGastosShareSubject.
  ///
  /// In es, this message translates to:
  /// **'Exportar gastos - {fileName}'**
  String exportGastosShareSubject(Object fileName);

  /// No description provided for @exportGastosError.
  ///
  /// In es, this message translates to:
  /// **'Error al generar el archivo'**
  String get exportGastosError;

  /// No description provided for @settingsTitle.
  ///
  /// In es, this message translates to:
  /// **'AJUSTES'**
  String get settingsTitle;

  /// No description provided for @settingsSalaryLabel.
  ///
  /// In es, this message translates to:
  /// **'SUELDO MENSUAL'**
  String get settingsSalaryLabel;

  /// No description provided for @settingsSaveButton.
  ///
  /// In es, this message translates to:
  /// **'GUARDAR'**
  String get settingsSaveButton;

  /// No description provided for @ahorrosTotalLabel.
  ///
  /// In es, this message translates to:
  /// **'ACTIVOS AHORRADOS'**
  String get ahorrosTotalLabel;

  /// No description provided for @ahorrosNewGoalButton.
  ///
  /// In es, this message translates to:
  /// **'Nueva Meta'**
  String get ahorrosNewGoalButton;

  /// No description provided for @ahorrosActiveGoalsTitle.
  ///
  /// In es, this message translates to:
  /// **'Metas Activas'**
  String get ahorrosActiveGoalsTitle;

  /// No description provided for @ahorrosEmptyMessage.
  ///
  /// In es, this message translates to:
  /// **'No hay metas de ahorro'**
  String get ahorrosEmptyMessage;

  /// No description provided for @ahorroCardDeadlineLabel.
  ///
  /// In es, this message translates to:
  /// **'Meta: {deadline}'**
  String ahorroCardDeadlineLabel(Object deadline);

  /// No description provided for @ahorroCardTargetLabel.
  ///
  /// In es, this message translates to:
  /// **'Objetivo {targetAmount}'**
  String ahorroCardTargetLabel(Object targetAmount);

  /// No description provided for @ahorroDetailCurrentLabel.
  ///
  /// In es, this message translates to:
  /// **'ACTUAL'**
  String get ahorroDetailCurrentLabel;

  /// No description provided for @ahorroDetailRemainingLabel.
  ///
  /// In es, this message translates to:
  /// **'RESTANTE'**
  String get ahorroDetailRemainingLabel;

  /// No description provided for @ahorroDepositButton.
  ///
  /// In es, this message translates to:
  /// **'DEPOSITAR'**
  String get ahorroDepositButton;

  /// No description provided for @ahorroWithdrawButton.
  ///
  /// In es, this message translates to:
  /// **'RETIRAR'**
  String get ahorroWithdrawButton;

  /// No description provided for @ahorroMovementsSection.
  ///
  /// In es, this message translates to:
  /// **'MOVIMIENTOS'**
  String get ahorroMovementsSection;

  /// No description provided for @ahorroNoMovements.
  ///
  /// In es, this message translates to:
  /// **'Sin movimientos'**
  String get ahorroNoMovements;

  /// No description provided for @ahorroMovementDeposit.
  ///
  /// In es, this message translates to:
  /// **'Depósito'**
  String get ahorroMovementDeposit;

  /// No description provided for @ahorroMovementWithdraw.
  ///
  /// In es, this message translates to:
  /// **'Retiro'**
  String get ahorroMovementWithdraw;

  /// No description provided for @ahorroAmountLabel.
  ///
  /// In es, this message translates to:
  /// **'MONTO'**
  String get ahorroAmountLabel;

  /// No description provided for @ahorroDescriptionOptionalLabel.
  ///
  /// In es, this message translates to:
  /// **'DESCRIPCIÓN (OPCIONAL)'**
  String get ahorroDescriptionOptionalLabel;

  /// No description provided for @ahorroCreateTitle.
  ///
  /// In es, this message translates to:
  /// **'NUEVA META DE AHORRO'**
  String get ahorroCreateTitle;

  /// No description provided for @ahorroNameLabel.
  ///
  /// In es, this message translates to:
  /// **'NOMBRE'**
  String get ahorroNameLabel;

  /// No description provided for @ahorroNameHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Viaje a la playa'**
  String get ahorroNameHint;

  /// No description provided for @ahorroDescriptionLabel.
  ///
  /// In es, this message translates to:
  /// **'DESCRIPCIÓN'**
  String get ahorroDescriptionLabel;

  /// No description provided for @ahorroDescriptionHint.
  ///
  /// In es, this message translates to:
  /// **'Ahorro para las vacaciones...'**
  String get ahorroDescriptionHint;

  /// No description provided for @ahorroTargetAmountLabel.
  ///
  /// In es, this message translates to:
  /// **'MONTO OBJETIVO'**
  String get ahorroTargetAmountLabel;

  /// No description provided for @validationMustBeGreaterThanZero.
  ///
  /// In es, this message translates to:
  /// **'Debe ser mayor a 0'**
  String get validationMustBeGreaterThanZero;

  /// No description provided for @ahorroNoDeadline.
  ///
  /// In es, this message translates to:
  /// **'Sin fecha límite'**
  String get ahorroNoDeadline;

  /// No description provided for @ahorroDeadlineOptionalLabel.
  ///
  /// In es, this message translates to:
  /// **'FECHA LÍMITE (OPCIONAL)'**
  String get ahorroDeadlineOptionalLabel;

  /// No description provided for @ahorroSharedGoalLabel.
  ///
  /// In es, this message translates to:
  /// **'Meta compartida'**
  String get ahorroSharedGoalLabel;

  /// No description provided for @ahorroCreateButton.
  ///
  /// In es, this message translates to:
  /// **'CREAR META'**
  String get ahorroCreateButton;

  /// No description provided for @ahorroParticipantAddedMessage.
  ///
  /// In es, this message translates to:
  /// **'Participante agregado'**
  String get ahorroParticipantAddedMessage;

  /// No description provided for @errorServer.
  ///
  /// In es, this message translates to:
  /// **'Error del servidor'**
  String get errorServer;

  /// No description provided for @errorCache.
  ///
  /// In es, this message translates to:
  /// **'Error de caché'**
  String get errorCache;

  /// No description provided for @errorAuth.
  ///
  /// In es, this message translates to:
  /// **'Error de autenticación'**
  String get errorAuth;

  /// No description provided for @errorNoInternet.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión a internet'**
  String get errorNoInternet;

  /// No description provided for @errorInvalidData.
  ///
  /// In es, this message translates to:
  /// **'Datos inválidos'**
  String get errorInvalidData;

  /// No description provided for @errorUserNotAuthenticated.
  ///
  /// In es, this message translates to:
  /// **'Usuario no autenticado'**
  String get errorUserNotAuthenticated;

  /// No description provided for @errorUnexpectedServerResponse.
  ///
  /// In es, this message translates to:
  /// **'Respuesta inesperada del servidor'**
  String get errorUnexpectedServerResponse;

  /// No description provided for @errorSignUp.
  ///
  /// In es, this message translates to:
  /// **'Error al registrar'**
  String get errorSignUp;

  /// No description provided for @errorSignIn.
  ///
  /// In es, this message translates to:
  /// **'Error al iniciar sesión'**
  String get errorSignIn;

  /// No description provided for @errorAddPartner.
  ///
  /// In es, this message translates to:
  /// **'Error al agregar amigo'**
  String get errorAddPartner;

  /// No description provided for @errorGetGastos.
  ///
  /// In es, this message translates to:
  /// **'Error al obtener gastos'**
  String get errorGetGastos;

  /// No description provided for @errorGastoNotFound.
  ///
  /// In es, this message translates to:
  /// **'Gasto no encontrado'**
  String get errorGastoNotFound;

  /// No description provided for @errorGetGasto.
  ///
  /// In es, this message translates to:
  /// **'Error al obtener gasto'**
  String get errorGetGasto;

  /// No description provided for @errorCreateGasto.
  ///
  /// In es, this message translates to:
  /// **'Error al crear gasto'**
  String get errorCreateGasto;

  /// No description provided for @errorGastoEditPermission.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para editar este gasto'**
  String get errorGastoEditPermission;

  /// No description provided for @errorUpdateGasto.
  ///
  /// In es, this message translates to:
  /// **'Error al actualizar gasto'**
  String get errorUpdateGasto;

  /// No description provided for @errorGetAhorros.
  ///
  /// In es, this message translates to:
  /// **'Error al obtener ahorros'**
  String get errorGetAhorros;

  /// No description provided for @errorAhorroNotFound.
  ///
  /// In es, this message translates to:
  /// **'Meta no encontrada'**
  String get errorAhorroNotFound;

  /// No description provided for @errorGetAhorro.
  ///
  /// In es, this message translates to:
  /// **'Error al obtener ahorro'**
  String get errorGetAhorro;

  /// No description provided for @errorCreateAhorro.
  ///
  /// In es, this message translates to:
  /// **'Error al crear ahorro'**
  String get errorCreateAhorro;

  /// No description provided for @errorAhorroEditPermission.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para editar esta meta'**
  String get errorAhorroEditPermission;

  /// No description provided for @errorUpdateAhorro.
  ///
  /// In es, this message translates to:
  /// **'Error al actualizar ahorro'**
  String get errorUpdateAhorro;

  /// No description provided for @errorAhorroDeletePermission.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para eliminar esta meta'**
  String get errorAhorroDeletePermission;

  /// No description provided for @errorDeleteAhorro.
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar ahorro'**
  String get errorDeleteAhorro;

  /// No description provided for @errorDeposit.
  ///
  /// In es, this message translates to:
  /// **'Error al depositar'**
  String get errorDeposit;

  /// No description provided for @errorWithdraw.
  ///
  /// In es, this message translates to:
  /// **'Error al retirar'**
  String get errorWithdraw;

  /// No description provided for @errorGetMovements.
  ///
  /// In es, this message translates to:
  /// **'Error al obtener movimientos'**
  String get errorGetMovements;

  /// No description provided for @errorAddParticipantPermission.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para agregar participantes'**
  String get errorAddParticipantPermission;

  /// No description provided for @errorOnlySharedGoalsCanAddParticipants.
  ///
  /// In es, this message translates to:
  /// **'Solo se pueden agregar participantes a metas compartidas.'**
  String get errorOnlySharedGoalsCanAddParticipants;

  /// No description provided for @errorUserNotFound.
  ///
  /// In es, this message translates to:
  /// **'El usuario especificado no existe.'**
  String get errorUserNotFound;

  /// No description provided for @errorAddParticipant.
  ///
  /// In es, this message translates to:
  /// **'Error al agregar participante'**
  String get errorAddParticipant;

  /// No description provided for @errorExcelGeneration.
  ///
  /// In es, this message translates to:
  /// **'Error al generar el archivo Excel'**
  String get errorExcelGeneration;

  /// No description provided for @monthJan.
  ///
  /// In es, this message translates to:
  /// **'Ene'**
  String get monthJan;

  /// No description provided for @monthFeb.
  ///
  /// In es, this message translates to:
  /// **'Feb'**
  String get monthFeb;

  /// No description provided for @monthMar.
  ///
  /// In es, this message translates to:
  /// **'Mar'**
  String get monthMar;

  /// No description provided for @monthApr.
  ///
  /// In es, this message translates to:
  /// **'Abr'**
  String get monthApr;

  /// No description provided for @monthMay.
  ///
  /// In es, this message translates to:
  /// **'May'**
  String get monthMay;

  /// No description provided for @monthJun.
  ///
  /// In es, this message translates to:
  /// **'Jun'**
  String get monthJun;

  /// No description provided for @monthJul.
  ///
  /// In es, this message translates to:
  /// **'Jul'**
  String get monthJul;

  /// No description provided for @monthAgo.
  ///
  /// In es, this message translates to:
  /// **'Ago'**
  String get monthAgo;

  /// No description provided for @monthSep.
  ///
  /// In es, this message translates to:
  /// **'Sep'**
  String get monthSep;

  /// No description provided for @monthOct.
  ///
  /// In es, this message translates to:
  /// **'Oct'**
  String get monthOct;

  /// No description provided for @monthNov.
  ///
  /// In es, this message translates to:
  /// **'Nov'**
  String get monthNov;

  /// No description provided for @monthDec.
  ///
  /// In es, this message translates to:
  /// **'Dic'**
  String get monthDec;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
