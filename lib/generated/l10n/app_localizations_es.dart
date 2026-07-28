// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Aura';

  @override
  String get appTagline => 'Red Financiera Privada';

  @override
  String get loginUsernameLabel => 'Usuario';

  @override
  String get loginUsernameHint => 'Tu nombre de usuario';

  @override
  String get loginUsernameValidationEmpty => 'Ingresa tu nombre de usuario';

  @override
  String get loginPasswordLabel => 'CONTRASEÑA';

  @override
  String get loginPasswordValidationEmpty => 'Ingresa tu contraseña';

  @override
  String get loginButton => 'ENTRAR';

  @override
  String get loginNoAccountPrefix => '¿No tienes cuenta? ';

  @override
  String get loginRegisterLink => 'Regístrate';

  @override
  String get loginSecurityBadge => 'CIFRADO DE EXTREMO A EXTREMO';

  @override
  String get registerTitle => 'Crear Cuenta';

  @override
  String get registerSubtitle => 'UNIRTE A AURA';

  @override
  String get registerUsernameLabel => 'Usuario';

  @override
  String get registerUsernameHint => 'Elige un nombre de usuario';

  @override
  String get registerUsernameValidationEmpty => 'Ingresa un nombre de usuario';

  @override
  String get registerUsernameValidationMinLength => 'Mínimo 3 caracteres';

  @override
  String get registerPasswordLabel => 'CONTRASEÑA';

  @override
  String get registerPasswordValidationEmpty => 'Ingresa una contraseña';

  @override
  String get registerPasswordValidationMinLength => 'Mínimo 6 caracteres';

  @override
  String get registerConfirmPasswordLabel => 'CONFIRMAR CONTRASEÑA';

  @override
  String get registerConfirmPasswordValidationEmpty => 'Confirma tu contraseña';

  @override
  String get registerConfirmPasswordValidationMismatch => 'Las contraseñas no coinciden';

  @override
  String get registerButton => 'CREAR CUENTA';

  @override
  String get registerHasAccountPrefix => '¿Ya tienes cuenta? ';

  @override
  String get registerLoginLink => 'Inicia sesión';

  @override
  String get friendCodeCopiedMessage => 'Código copiado al portapapeles';

  @override
  String get friendCodeEmptyValidation => 'Ingresa un código de amigo';

  @override
  String friendCodeLinkedMessage(Object partnerName) {
    return 'Vinculado con $partnerName';
  }

  @override
  String get friendCodeSheetTitle => 'RED DE AMIGOS';

  @override
  String get friendCodePartnerLabel => 'TU AMIGO VINCULADO';

  @override
  String get friendCodeUnlinkButton => 'DESVINCULAR';

  @override
  String get friendCodeMyCodeLabel => 'MI CÓDIGO DE AMIGO';

  @override
  String get friendCodeTapToCopy => 'Toca para copiar';

  @override
  String get friendCodeLinkFriendSection => 'VINCULAR AMIGO';

  @override
  String get friendCodeLinkFriendDescription => 'Ingresa el código de amigo de la persona con quien quieres compartir';

  @override
  String get friendCodeLinkButton => 'VINCULAR';

  @override
  String get onboardingPage1Title => 'Bienvenido a Aura';

  @override
  String get onboardingPage1Description => 'Tu asistente financiero personal. Controla tus gastos y ahorra para alcanzar tus metas.';

  @override
  String get onboardingPage2Title => 'Gestiona tus Gastos';

  @override
  String get onboardingPage2Description => 'Registra cada gasto, organízalos por categoría y revisa tu flujo financiero mes a mes.';

  @override
  String get onboardingPage3Title => 'Alcanza tus Metas';

  @override
  String get onboardingPage3Description => 'Crea metas de ahorro, deposita fondos y visualiza tu progreso hacia tus objetivos.';

  @override
  String get onboardingPage4Title => 'Comparte con Amigos';

  @override
  String get onboardingPage4Description => 'Vincula tu cuenta con amigos para compartir metas de ahorro juntos.';

  @override
  String get onboardingStartButton => 'EMPEZAR';

  @override
  String get onboardingNextButton => 'SIGUIENTE';

  @override
  String get gastosModuleTab => 'Gastos';

  @override
  String get ingresosModuleTab => 'Ingresos';

  @override
  String get ahorrosModuleTab => 'Ahorros';

  @override
  String get gastosTotalLabel => 'GASTOS TOTALES';

  @override
  String get gastosFinancialFlowTitle => 'Flujo Financiero';

  @override
  String get gastosEmptyMessage => 'No hay gastos registrados';

  @override
  String get retryButton => 'Reintentar';

  @override
  String get gastoCategoryTransport => 'Transporte';

  @override
  String get gastoCategoryEntertainment => 'Entretenimiento';

  @override
  String get gastoCategoryFood => 'Comida';

  @override
  String get gastoCategoryHousing => 'Vivienda';

  @override
  String get gastoEditTitle => 'EDITAR GASTO';

  @override
  String get gastoCategoryLabel => 'CATEGORÍA';

  @override
  String get gastoCategoryHint => 'Selecciona o escribe una...';

  @override
  String get gastoDescriptionLabel => 'DESCRIPCIÓN';

  @override
  String get gastoDescriptionHint => 'Ej: Almuerzo en restaurante';

  @override
  String get gastoAmountLabel => 'VALOR';

  @override
  String get gastoDateLabel => 'FECHA';

  @override
  String get gastoSharedLabel => 'Compartido';

  @override
  String get gastoUpdateButton => 'ACTUALIZAR';

  @override
  String get gastoCreateTitle => 'NUEVO GASTO';

  @override
  String get gastoShareLabel => 'Compartir';

  @override
  String get gastoSaveButton => 'GUARDAR GASTO';

  @override
  String get validationRequired => 'Requerido';

  @override
  String get validationInvalidNumber => 'Número inválido';

  @override
  String get exportGastosTitle => 'EXPORTAR GASTOS';

  @override
  String get exportGastosSubtitle => 'Elige el rango a exportar';

  @override
  String get exportGastosCurrentMonth => 'Mes actual';

  @override
  String get exportGastosLast3Months => 'Últimos 3 meses';

  @override
  String get exportGastosEmptyMonth => 'No hay gastos para este mes';

  @override
  String get exportGastosEmpty3Months => 'No hay gastos en los últimos 3 meses';

  @override
  String exportGastosShareSubject(Object fileName) {
    return 'Exportar gastos - $fileName';
  }

  @override
  String get exportGastosError => 'Error al generar el archivo';

  @override
  String get settingsTitle => 'AJUSTES';

  @override
  String get settingsSalaryLabel => 'SUELDO MENSUAL';

  @override
  String get settingsSalaryTypeLabel => 'TIPO DE SALARIO';

  @override
  String get settingsSalaryTypeFixed => 'Fijo';

  @override
  String get settingsSalaryTypeVariable => 'Variable';

  @override
  String get settingsSaveButton => 'GUARDAR';

  @override
  String get ingresosTotalLabel => 'INGRESOS TOTALES';

  @override
  String get ingresosListTitle => 'Ingresos';

  @override
  String get ingresosEmptyMessage => 'No hay ingresos registrados';

  @override
  String get ingresoCreateTitle => 'NUEVO INGRESO';

  @override
  String get ingresoEditTitle => 'EDITAR INGRESO';

  @override
  String get ingresoCategoryLabel => 'CATEGORÍA';

  @override
  String get ingresoCategoryHint => 'Selecciona o escribe una...';

  @override
  String get ingresoCategoryClient => 'Cliente';

  @override
  String get ingresoCategoryInvestment => 'Inversión';

  @override
  String get ingresoCategoryOther => 'Otro';

  @override
  String get ingresoDescriptionLabel => 'DESCRIPCIÓN';

  @override
  String get ingresoDescriptionHint => 'Ej: Pago de proyecto freelance';

  @override
  String get ingresoAmountLabel => 'VALOR';

  @override
  String get ingresoDateLabel => 'FECHA';

  @override
  String get ingresoUpdateButton => 'ACTUALIZAR';

  @override
  String get ingresoSaveButton => 'GUARDAR INGRESO';

  @override
  String get ahorrosTotalLabel => 'ACTIVOS AHORRADOS';

  @override
  String get ahorrosNewGoalButton => 'Nueva Meta';

  @override
  String get ahorrosActiveGoalsTitle => 'Metas Activas';

  @override
  String get ahorrosEmptyMessage => 'No hay metas de ahorro';

  @override
  String ahorroCardDeadlineLabel(Object deadline) {
    return 'Meta: $deadline';
  }

  @override
  String ahorroCardTargetLabel(Object targetAmount) {
    return 'Objetivo $targetAmount';
  }

  @override
  String get ahorroDetailCurrentLabel => 'ACTUAL';

  @override
  String get ahorroDetailRemainingLabel => 'RESTANTE';

  @override
  String get ahorroDepositButton => 'DEPOSITAR';

  @override
  String get ahorroWithdrawButton => 'RETIRAR';

  @override
  String get ahorroMovementsSection => 'MOVIMIENTOS';

  @override
  String get ahorroNoMovements => 'Sin movimientos';

  @override
  String get ahorroMovementDeposit => 'Depósito';

  @override
  String get ahorroMovementWithdraw => 'Retiro';

  @override
  String get ahorroAmountLabel => 'MONTO';

  @override
  String get ahorroDescriptionOptionalLabel => 'DESCRIPCIÓN (OPCIONAL)';

  @override
  String get ahorroCreateTitle => 'NUEVA META DE AHORRO';

  @override
  String get ahorroNameLabel => 'NOMBRE';

  @override
  String get ahorroNameHint => 'Ej: Viaje a la playa';

  @override
  String get ahorroDescriptionLabel => 'DESCRIPCIÓN';

  @override
  String get ahorroDescriptionHint => 'Ahorro para las vacaciones...';

  @override
  String get ahorroTargetAmountLabel => 'MONTO OBJETIVO';

  @override
  String get validationMustBeGreaterThanZero => 'Debe ser mayor a 0';

  @override
  String get ahorroNoDeadline => 'Sin fecha límite';

  @override
  String get ahorroDeadlineOptionalLabel => 'FECHA LÍMITE (OPCIONAL)';

  @override
  String get ahorroSharedGoalLabel => 'Meta compartida';

  @override
  String get ahorroCreateButton => 'CREAR META';

  @override
  String get ahorroParticipantAddedMessage => 'Participante agregado';

  @override
  String get errorServer => 'Error del servidor';

  @override
  String get errorCache => 'Error de caché';

  @override
  String get errorAuth => 'Error de autenticación';

  @override
  String get errorNoInternet => 'Sin conexión a internet';

  @override
  String get errorInvalidData => 'Datos inválidos';

  @override
  String get errorUserNotAuthenticated => 'Usuario no autenticado';

  @override
  String get errorUnexpectedServerResponse => 'Respuesta inesperada del servidor';

  @override
  String get errorSignUp => 'Error al registrar';

  @override
  String get errorSignIn => 'Error al iniciar sesión';

  @override
  String get errorAddPartner => 'Error al agregar amigo';

  @override
  String get errorGetGastos => 'Error al obtener gastos';

  @override
  String get errorGastoNotFound => 'Gasto no encontrado';

  @override
  String get errorGetGasto => 'Error al obtener gasto';

  @override
  String get errorCreateGasto => 'Error al crear gasto';

  @override
  String get errorGastoEditPermission => 'No tienes permiso para editar este gasto';

  @override
  String get errorUpdateGasto => 'Error al actualizar gasto';

  @override
  String get errorGetIngresos => 'Error al obtener ingresos';

  @override
  String get errorIngresoNotFound => 'Ingreso no encontrado';

  @override
  String get errorGetIngreso => 'Error al obtener ingreso';

  @override
  String get errorCreateIngreso => 'Error al crear ingreso';

  @override
  String get errorIngresoEditPermission => 'No tienes permiso para editar este ingreso';

  @override
  String get errorUpdateIngreso => 'Error al actualizar ingreso';

  @override
  String get errorGetAhorros => 'Error al obtener ahorros';

  @override
  String get errorAhorroNotFound => 'Meta no encontrada';

  @override
  String get errorGetAhorro => 'Error al obtener ahorro';

  @override
  String get errorCreateAhorro => 'Error al crear ahorro';

  @override
  String get errorAhorroEditPermission => 'No tienes permiso para editar esta meta';

  @override
  String get errorUpdateAhorro => 'Error al actualizar ahorro';

  @override
  String get errorAhorroDeletePermission => 'No tienes permiso para eliminar esta meta';

  @override
  String get errorDeleteAhorro => 'Error al eliminar ahorro';

  @override
  String get errorDeposit => 'Error al depositar';

  @override
  String get errorWithdraw => 'Error al retirar';

  @override
  String get errorGetMovements => 'Error al obtener movimientos';

  @override
  String get errorAddParticipantPermission => 'No tienes permiso para agregar participantes';

  @override
  String get errorOnlySharedGoalsCanAddParticipants => 'Solo se pueden agregar participantes a metas compartidas.';

  @override
  String get errorUserNotFound => 'El usuario especificado no existe.';

  @override
  String get errorAddParticipant => 'Error al agregar participante';

  @override
  String get errorExcelGeneration => 'Error al generar el archivo Excel';

  @override
  String get monthJan => 'Ene';

  @override
  String get monthFeb => 'Feb';

  @override
  String get monthMar => 'Mar';

  @override
  String get monthApr => 'Abr';

  @override
  String get monthMay => 'May';

  @override
  String get monthJun => 'Jun';

  @override
  String get monthJul => 'Jul';

  @override
  String get monthAgo => 'Ago';

  @override
  String get monthSep => 'Sep';

  @override
  String get monthOct => 'Oct';

  @override
  String get monthNov => 'Nov';

  @override
  String get monthDec => 'Dic';
}
