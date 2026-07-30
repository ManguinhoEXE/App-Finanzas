<div align="center">

# Aura

**Aplicacion movil para el control de finanzas personales**

[![Flutter](https://img.shields.io/badge/Flutter-3.7+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.7+-0175C2?logo=dart)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Database-3FCF8E?logo=supabase)](https://supabase.com)
[![Version](https://img.shields.io/badge/Version-1.0.2-blue)]()
[![License](https://img.shields.io/badge/License-Private-red)](#licencia)

### [Descargar APK (ultima version)](https://github.com/ManguinhoEXE/App-Finanzas/releases/latest/download/app-release.apk)

</div>

---

## Caracteristicas principales

- **Autenticacion unificada** — Inicio de sesion con nombre de usuario (legacy) o correo electronico (Supabase Auth JWT). El campo de login detecta automaticamente si contiene `@` para elegir el metodo.
- **Registro con correo** — Los nuevos usuarios se registran con email, creados directamente en Supabase Auth + base de datos local, sin necesidad de migracion.
- **Recuperacion de contrasena** — Enlace de restablecimiento via deep link (`aura://callback`) con pagina dedicada de cambio de contrasena.
- **Migracion de usuarios legacy** — Los usuarios existentes con autenticacion por nombre de usuario ven una pantalla de migracion para vincular su cuenta a Supabase Auth.
- **Onboarding interactivo** — Carrusel de bienvenida de 4 pantallas al primer inicio
- **Control de gastos** — Registra, consulta y exporta tus gastos a Excel
- **Control de ingresos** — Registra y consulta tus ingresos mensuales por categoria (Cliente, Inversion, Otro)
- **Metas de ahorro** — Crea metas con progreso visual, deposita y retira fondos
- **Sistema de parejas** — Conecta con tu pareja mediante codigo de amigo para finanzas compartidas
- **Configuracion de salario** — Tipo fijo o variable con calculo automatico de balance
- **Tema personalizable** — Alterna entre tema oscuro (black/gold) y tema pastel
- **Formato colombiano** — Numeros en pesos colombianos (COP), fechas en locale `es_CO`
- **Localizacion** — Soporte para espanol e ingles
- **Exportacion a Excel** — Genera archivos `.xlsx` con tus gastos y comparte directamente

---

## Stack tecnologico

| Capa | Tecnologia |
|------|------------|
| **Framework** | Flutter 3.7+ |
| **Lenguaje** | Dart 3.7+ |
| **Estado** | BLoC (flutter_bloc + equatable) |
| **Routing** | GoRouter |
| **Inyeccion de dependencias** | GetIt |
| **Programacion funcional** | Dartz (Either) |
| **Backend** | Supabase (PostgreSQL + RPC + RLS) |
| **Almacenamiento local** | SharedPreferences |
| **Variables de entorno** | flutter_dotenv |
| **Fuentes** | Google Fonts (DM Sans + Playfair Display) |
| **Formato de moneda** | intl (NumberFormat, locale es_CO) |
| **Localizacion** | flutter_localizations + gen_l10n |
| **Exportacion** | excel + share_plus |
| **HTTP/URLs** | http + url_launcher |

---

## Arquitectura del proyecto

```
lib/
├── app/                          # Configuracion de la app
│   ├── app.dart                  # MaterialApp.router + tema + localizacion
│   ├── di/                       # Dependencias (GetIt)
│   └── router/                   # GoRouter + redirect logic
├── core/                         # Modulos compartidos
│   ├── constants/                # Constantes de la app
│   ├── errors/                   # Excepciones y fallos
│   ├── services/                 # Servicios (local storage)
│   ├── supabase/                 # Configuracion de Supabase
│   ├── theme/                    # Temas, colores, paletas
│   ├── usecases/                 # Casos de uso base
│   ├── utils/                    # Utilidades (fecha, moneda, excel, extensiones)
│   └── widgets/                  # Widgets reutilizables (logo, theme toggle, feedback)
├── features/                     # Modulos por funcionalidad
│   ├── auth/                     # Autenticacion (registro, login, onboarding, recuperacion, migracion, pareja)
│   ├── gastos/                   # Gastos personales
│   ├── ingresos/                 # Ingresos personales
│   ├── ahorros/                  # Metas de ahorro
│   └── settings/                 # Configuracion (proximamente)
├── generated/                    # Codigo generado
│   └── l10n/                     # Traducciones (es, en)
└── main.dart                     # Punto de entrada
```

**Patron:** Clean Architecture (Feature-First) con BLoC

---

## Requisitos previos

- [Flutter SDK](https://flutter.dev/docs/get-started/install) 3.7+
- [Dart SDK](https://dart.dev/get-dart) 3.7+
- [Android Studio](https://developer.android.com/studio) o [VS Code](https://code.visualstudio.com/)
- Cuenta de [Supabase](https://supabase.com/) con un proyecto creado
- Dispositivo Android o emulador

---

## Instalacion y configuracion

### 1. Clonar el repositorio

```bash
git clone https://github.com/ManguinhoEXE/App-Finanzas.git
cd Flutter-Finanzas
```

### 2. Configurar variables de entorno

Copia el archivo `.env.example` y renombralo a `.env`:

```bash
cp .env.example .env
```

Edita `.env` con tus credenciales de Supabase:

```env
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_ANON_KEY=tu-anon-key-aqui
```

### 3. Instalar dependencias

```bash
flutter pub get
```

### 4. Configurar base de datos en Supabase

1. Ve al [Supabase Dashboard](https://supabase.com/dashboard)
2. Abre el **SQL Editor**
3. Ejecuta el script `scripts/refactor_database.sql`
4. Ejecuta el script `scripts/add_ingresos_feature.sql`
5. Verifica que todas las tablas se crearon correctamente

### 5. Ejecutar la app

```bash
flutter run
```

---

## Build de release (APK)

### Descargar APK pre-compilado

Ve a la pagina de [Releases](https://github.com/ManguinhoEXE/App-Finanzas/releases) y descarga el `app-release.apk`.

Para instalar en tu dispositivo Android:

1. Descarga el `app-release.apk` desde la pagina de releases
2. Abre el archivo en tu dispositivo
3. Si es la primera vez, habilita **"Fuentes desconocidas"** en Ajustes > Seguridad
4. Sigue las instrucciones para completar la instalacion

### Compilar desde el codigo fuente

```bash
flutter build apk --release
```

El APK se generara en:
```
build/app/outputs/flutter-apk/app-release.apk
```

Para instalar en un dispositivo:
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

---

## Base de datos

### Tablas

| Tabla | Descripcion |
|-------|-------------|
| `users` | Usuarios registrados (id, name, password_hash, email, friend_code, guide, salary, salary_type, accumulated_balance, partner_id, migrated, auth_user_id, created_at) |
| `access_keys` | Llaves de acceso unicas (id, key, used, used_at, created_at) |
| `expenses` | Gastos personales (id, usuario, categoria, fecha, descripcion, valor, compartido, created_at) |
| `incomes` | Ingresos personales (id, usuario, categoria, fecha, descripcion, valor, created_at) |
| `saving_goals` | Metas de ahorro (id, owner, name, description, target_amount, current_amount, currency, deadline, is_shared, status, created_at, updated_at) |
| `saving_movements` | Movimientos de ahorro (id, goal, user, type, amount, description, created_at) |

### Stored Procedures

| SP | Descripcion |
|----|-------------|
| `sp_register_user` | Registra un nuevo usuario con nombre, contrasena y email. Crea `auth.users` + `auth.identities` y establece `migrated = true` |
| `sp_login` | Autentica un usuario legacy por nombre de usuario y devuelve datos + info de pareja |
| `sp_add_partner` | Conecta dos usuarios como pareja mediante codigo de amigo |
| `sp_remove_partner` | Desconecta la pareja de un usuario |
| `sp_complete_guide` | Marca el onboarding como completado |
| `sp_update_salary` | Actualiza el tipo de salario (fijo/variable) y monto |
| `sp_update_accumulated_balance` | Actualiza el saldo acumulado del usuario |
| `sp_deposit` | Registra un deposito en una meta de ahorro (con lock pesimista) |
| `sp_withdraw` | Registra un retiro de una meta de ahorro (con validacion de saldo) |
| `sp_migrate_user` | Migra un usuario legacy a Supabase Auth (verifica bcrypt, crea `auth.users` + `auth.identities`) |

---

## Estructura de features

Cada feature sigue el patron **Clean Architecture**:

```
feature/
├── data/
│   ├── datasources/     # Fuente de datos (Supabase RPC/queries)
│   ├── models/          # Modelos con JSON serialization
│   └── repositories/    # Implementacion del repositorio
├── domain/
│   ├── entities/        # Entidades del dominio (Equatable)
│   ├── repositories/    # Interfaz del repositorio
│   └── usecases/        # Casos de uso
└── presentation/
    ├── bloc/            # Estado (BLoC: event, state, bloc)
    ├── pages/           # Pantallas
    └── widgets/         # Widgets de la feature
```

---

## Convenciones de codigo

- **Naming:** snake_case para archivos y variables, PascalCase para clases
- **Imports:** Ordenados por paquete (dart, flutter, third-party, local)
- **Linting:** Reglas de `flutter_lints`
- **Commits:** Mensajes descriptivos en ingles

---

## Licencia

**Todos los derechos reservados.** Este es un proyecto privado. No se permite la distribucion, modificacion o uso sin autorizacion escrita del propietario.

---

## Contacto

- **Autor:** Manguinho
- **GitHub:** [@ManguinhoEXE](https://github.com/ManguinhoEXE)

---

<div align="center">

Hecho con Flutter y Supabase

</div>
