<div align="center">

# DocAppFlutter

**Documentacion tecnica de la aplicacion Aura**

</div>

---

## Tabla de contenidos

1. [Descripcion general](#descripcion-general)
2. [Arquitectura](#arquitectura)
3. [Estructura de carpetas](#estructura-de-carpetas)
4. [Configuracion de Supabase](#configuracion-de-supabase)
5. [Esquema de base de datos](#esquema-de-base-de-datos)
6. [Stored Procedures](#stored-procedures)
7. [Flujo de autenticacion](#flujo-de-autenticacion)
8. [Flujo de gastos](#flujo-de-gastos)
9. [Flujo de ahorros](#flujo-de-ahorros)
10. [Variables de entorno](#variables-de-entorno)
11. [Build y ejecucion](#build-y-ejecucion)
12. [Dependencias principales](#dependencias-principales)

---

## Descripcion general

**Aura** es una aplicacion movil desarrollada en Flutter para el control de finanzas personales. Permite a los usuarios:

- Autenticarse mediante llaves de acceso unicas
- Registrar y consultar gastos personales
- Crear metas de ahorro con progreso visual
- Depositar y retirar fondos de metas
- Exportar gastos a archivos Excel
- Alternar entre tema oscuro y pastel

**Backend:** Supabase (PostgreSQL + Stored Procedures)
**Arquitectura:** Clean Architecture Feature-First con BLoC

---

## Arquitectura

### Clean Architecture

La app sigue el patron **Clean Architecture** con separacion en tres capas:

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │    Pages     │  │   Widgets   │  │    BLoC (Estado)    │ │
│  │  (Pantallas) │  │ (Componentes)│  │  (Events + States) │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
├─────────────────────────────────────────────────────────────┤
│                      DOMAIN LAYER                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │  Entities    │  │ Repositories │  │    Use Cases        │ │
│  │ (Modelos)    │  │ (Interfaces) │  │  (Logica de negocio)│ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
├─────────────────────────────────────────────────────────────┤
│                       DATA LAYER                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │ Datasources  │  │    Models    │  │ Repository Impls    │ │
│  │ (Supabase)   │  │ (JSON/Cast)  │  │ (Implementaciones)  │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### Patron BLoC

Cada feature usa el patron **BLoC** (Business Logic Component):

- **Events:** Acciones del usuario (LoadGastos, CreateGasto, etc.)
- **States:** Estados de la UI (GastoLoading, GastoLoaded, GastoError)
- **BLoC:** Recibe events, ejecuta use cases, emite states

### Inyeccion de dependencias

Se usa **GetIt** como service locator. Todas las dependencias se registran en `lib/app/di/dependency_injection.dart`.

---

## Estructura de carpetas

```
Flutter-Finanzas/
├── .env                          # Variables de entorno (NO COMMITTEAR)
├── .env.example                  # Plantilla de variables
├── pubspec.yaml                  # Dependencias
├── scripts/
│   └── refactor_database.sql     # Migracion de Supabase
├── lib/
│   ├── main.dart                 # Punto de entrada
│   ├── app/
│   │   ├── app.dart              # MaterialApp + AuthGate
│   │   └── di/
│   │       └── dependency_injection.dart
│   ├── core/
│   │   ├── constants/
│   │   │   └── app_constants.dart
│   │   ├── errors/
│   │   │   ├── exceptions.dart   # AppAuthException, ServerException
│   │   │   └── failures.dart     # AuthFailure, ServerFailure
│   │   ├── supabase/
│   │   │   └── supabase_config.dart
│   │   ├── theme/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_palettes.dart
│   │   │   ├── app_theme.dart
│   │   │   ├── color_palette.dart
│   │   │   └── palette_provider.dart
│   │   ├── usecases/
│   │   │   └── usecase.dart
│   │   ├── utils/
│   │   │   ├── currency_formatter.dart
│   │   │   ├── currency_input_formatter.dart
│   │   │   ├── excel_generator.dart
│   │   │   └── slide_route_builder.dart
│   │   └── widgets/
│   │       ├── aura_logo.dart
│   │       └── theme_toggle.dart
│   └── features/
│       ├── auth/
│       │   ├── data/
│       │   │   ├── datasources/auth_remote_datasource.dart
│       │   │   ├── models/user_model.dart
│       │   │   └── repositories/auth_repository_impl.dart
│       │   ├── domain/
│       │   │   ├── entities/user.dart
│       │   │   ├── repositories/auth_repository.dart
│       │   │   └── usecases/activate_key_usecase.dart
│       │   └── presentation/
│       │       ├── bloc/auth_bloc.dart
│       │       ├── pages/login_page.dart
│       │       └── widgets/login_form.dart
│       ├── gastos/
│       │   ├── data/
│       │   │   ├── datasources/gasto_remote_datasource.dart
│       │   │   ├── models/gasto_model.dart
│       │   │   └── repositories/gasto_repository_impl.dart
│       │   ├── domain/
│       │   │   ├── entities/gasto.dart
│       │   │   ├── repositories/gasto_repository.dart
│       │   │   └── usecases/gasto_usecases.dart
│       │   └── presentation/
│       │       ├── bloc/gasto_bloc.dart
│       │       ├── pages/gastos_page.dart
│       │       └── widgets/
│       └── ahorros/
│           ├── data/
│           │   ├── datasources/ahorro_remote_datasource.dart
│           │   ├── models/ahorro_model.dart
│           │   ├── models/movement_model.dart
│           │   └── repositories/ahorro_repository_impl.dart
│           ├── domain/
│           │   ├── entities/ahorro.dart
│           │   ├── repositories/ahorro_repository.dart
│           │   └── usecases/ahorro_usecases.dart
│           └── presentation/
│               ├── bloc/ahorro_bloc.dart
│               ├── pages/ahorros_page.dart
│               └── widgets/
└── android/
    └── app/
        └── src/main/
            ├── AndroidManifest.xml
            └── res/xml/network_security_config.xml
```

---

## Configuracion de Supabase

### Conexion

La app se conecta directamente a Supabase usando `supabase_flutter`:

```dart
// lib/main.dart
await Supabase.initialize(
  url: SupabaseConfig.url,        // Desde .env
  publishableKey: SupabaseConfig.anonKey,  // Desde .env
);
```

### RLS (Row Level Security)

**RLS esta habilitado pero con politicas permisivas:**

```sql
CREATE POLICY "Allow all on users" ON users FOR ALL USING (true);
CREATE POLICY "Allow all on expenses" ON expenses FOR ALL USING (true);
-- etc.
```

Esto significa que la app maneja toda la logica de acceso via Stored Procedures, no via RLS policies.

---

## Esquema de base de datos

### users

```sql
CREATE TABLE users (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name text NOT NULL UNIQUE,
  created_at timestamptz DEFAULT now() NOT NULL
);
```

### access_keys

```sql
CREATE TABLE access_keys (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  key text NOT NULL UNIQUE,
  used boolean DEFAULT false NOT NULL,
  used_at timestamptz,
  created_at timestamptz DEFAULT now() NOT NULL
);
```

### expenses

```sql
CREATE TABLE expenses (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  usuario bigint NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  categoria text NOT NULL,
  fecha date NOT NULL,
  descripcion text NOT NULL,
  valor numeric(12,2) NOT NULL CHECK (valor >= 0),
  compartido boolean DEFAULT false NOT NULL,
  created_at timestamptz DEFAULT now() NOT NULL
);
```

### saving_goals

```sql
CREATE TABLE saving_goals (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  owner bigint NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name text NOT NULL,
  description text DEFAULT '' NOT NULL,
  target_amount numeric(15,2) NOT NULL CHECK (target_amount > 0),
  current_amount numeric(15,2) DEFAULT 0 NOT NULL CHECK (current_amount >= 0),
  currency text DEFAULT 'COP' NOT NULL,
  deadline date,
  is_shared boolean DEFAULT false NOT NULL,
  status text DEFAULT 'ACTIVE' NOT NULL CHECK (status IN ('ACTIVE','COMPLETED','PAUSED','CANCELLED')),
  created_at timestamptz DEFAULT now() NOT NULL,
  updated_at timestamptz DEFAULT now() NOT NULL
);
```

### saving_movements

```sql
CREATE TABLE saving_movements (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  goal bigint NOT NULL REFERENCES saving_goals(id) ON DELETE CASCADE,
  "user" bigint NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type text NOT NULL CHECK (type IN ('DEPOSIT','WITHDRAW','ADJUSTMENT')),
  amount numeric(15,2) NOT NULL CHECK (amount > 0),
  description text DEFAULT '' NOT NULL,
  created_at timestamptz DEFAULT now() NOT NULL
);
```

---

## Stored Procedures

### sp_activate_key

Activa una llave de acceso y crea/busca el usuario:

```sql
CREATE OR REPLACE FUNCTION sp_activate_key(p_key text, p_name text)
RETURNS json AS $$
DECLARE
  v_key_record record;
  v_user record;
BEGIN
  -- Buscar y bloquear la llave (FOR UPDATE)
  SELECT * INTO v_key_record
  FROM access_keys WHERE key = p_key FOR UPDATE;

  -- Verificar que existe
  IF v_key_record IS NULL THEN
    RETURN json_build_object('error', 'La llave ingresada no es valida.');
  END IF;

  -- Verificar que no fue usada
  IF v_key_record.used = true THEN
    RETURN json_build_object('error', 'La llave ya fue utilizada anteriormente.');
  END IF;

  -- Buscar o crear usuario
  SELECT * INTO v_user FROM users WHERE name = p_name;
  IF NOT FOUND THEN
    INSERT INTO users (name) VALUES (p_name) RETURNING * INTO v_user;
  END IF;

  -- Marcar llave como usada
  UPDATE access_keys SET used = true, used_at = now() WHERE id = v_key_record.id;

  -- Retornar usuario
  RETURN json_build_object('id', v_user.id, 'name', v_user.name);
END;
$$ LANGUAGE plpgsql;
```

### sp_deposit

Registra un deposito en una meta de ahorro:

```sql
CREATE OR REPLACE FUNCTION sp_deposit(
  p_goal_id bigint,
  p_user_id bigint,
  p_amount numeric,
  p_description text DEFAULT ''
)
RETURNS json AS $$
DECLARE
  v_goal record;
  v_new_amount numeric;
  v_movement record;
BEGIN
  -- Obtener y bloquear la meta (FOR UPDATE)
  SELECT * INTO v_goal FROM saving_goals WHERE id = p_goal_id FOR UPDATE;

  -- Verificar que existe
  IF v_goal IS NULL THEN
    RETURN json_build_object('error', 'Meta no encontrada.');
  END IF;

  -- Verificar estado ACTIVE
  IF v_goal.status != 'ACTIVE' THEN
    RETURN json_build_object('error', 'No se pueden registrar depositos en una meta que no esta activa.');
  END IF;

  -- Validar monto
  IF p_amount < 0.01 THEN
    RETURN json_build_object('error', 'El monto debe ser mayor a 0.');
  END IF;

  -- Crear movimiento
  INSERT INTO saving_movements (goal, "user", type, amount, description)
  VALUES (p_goal_id, p_user_id, 'DEPOSIT', p_amount, p_description)
  RETURNING * INTO v_movement;

  -- Actualizar monto actual
  v_new_amount := v_goal.current_amount + p_amount;
  UPDATE saving_goals SET current_amount = v_new_amount, updated_at = now() WHERE id = p_goal_id;

  -- Verificar si completo la meta
  IF v_new_amount >= v_goal.target_amount THEN
    UPDATE saving_goals SET status = 'COMPLETED' WHERE id = p_goal_id;
  END IF;

  -- Retornar resultado
  RETURN json_build_object(
    'detail', 'Deposito registrado exitosamente.',
    'movement', row_to_json(v_movement),
    'goal', (SELECT row_to_json(sg) FROM saving_goals sg WHERE id = p_goal_id)
  );
END;
$$ LANGUAGE plpgsql;
```

### sp_withdraw

Registra un retiro de una meta de ahorro:

```sql
CREATE OR REPLACE FUNCTION sp_withdraw(
  p_goal_id bigint,
  p_user_id bigint,
  p_amount numeric,
  p_description text DEFAULT ''
)
RETURNS json AS $$
DECLARE
  v_goal record;
  v_new_amount numeric;
  v_movement record;
BEGIN
  -- Obtener y bloquear la meta (FOR UPDATE)
  SELECT * INTO v_goal FROM saving_goals WHERE id = p_goal_id FOR UPDATE;

  -- Verificar que existe
  IF v_goal IS NULL THEN
    RETURN json_build_object('error', 'Meta no encontrada.');
  END IF;

  -- Verificar estado ACTIVE
  IF v_goal.status != 'ACTIVE' THEN
    RETURN json_build_object('error', 'No se pueden registrar retiros en una meta que no esta activa.');
  END IF;

  -- Verificar saldo suficiente
  IF p_amount > v_goal.current_amount THEN
    RETURN json_build_object('error', 'Saldo insuficiente para realizar este retiro.');
  END IF;

  -- Validar monto
  IF p_amount < 0.01 THEN
    RETURN json_build_object('error', 'El monto debe ser mayor a 0.');
  END IF;

  -- Crear movimiento
  INSERT INTO saving_movements (goal, "user", type, amount, description)
  VALUES (p_goal_id, p_user_id, 'WITHDRAW', p_amount, p_description)
  RETURNING * INTO v_movement;

  -- Actualizar monto actual
  v_new_amount := v_goal.current_amount - p_amount;
  UPDATE saving_goals SET current_amount = v_new_amount, updated_at = now() WHERE id = p_goal_id;

  -- Retornar resultado
  RETURN json_build_object(
    'detail', 'Retiro registrado exitosamente.',
    'movement', row_to_json(v_movement),
    'goal', (SELECT row_to_json(sg) FROM saving_goals sg WHERE id = p_goal_id)
  );
END;
$$ LANGUAGE plpgsql;
```

---

## Flujo de autenticacion

```
1. Usuario ingresa llave + nombre
       │
       ▼
2. AuthRemoteDataSource
   llama a rpc('sp_activate_key')
       │
       ▼
3. Supabase ejecuta SP
   ┌─────────────────────────────────────┐
   │ a. SELECT FOR UPDATE en access_keys │
   │ b. Verificar que llave existe       │
   │ c. Verificar que no fue usada       │
   │ d. Buscar o crear usuario           │
   │ e. Marcar llave como usada          │
   │ f. Retornar usuario                 │
   └─────────────────────────────────────┘
       │
       ▼
4. AuthBloc guarda en SharedPreferences
   (userId, userName)
       │
       ▼
5. AuthAuthenticated → HomePage
```

---

## Flujo de gastos

```
1. GastosPage carga
       │
       ▼
2. GastoBloc → LoadGastos
       │
       ▼
3. GastoRepository → Supabase
   SELECT * FROM expenses
   JOIN users ON usuario = users.id
   WHERE usuario = {userId}
   ORDER BY fecha DESC
       │
       ▼
4. GastoLoaded → Lista de gastos
       │
       ▼
5. Usuario crea gasto
   ┌─────────────────────────────────────┐
   │ a. INSERT en expenses               │
   │ b. Reload lista                     │
   │ c. Actualizar totales               │
   └─────────────────────────────────────┘
```

---

## Flujo de ahorros

```
1. AhorrosPage carga
       │
       ▼
2. AhorroBloc → LoadAhorros
       │
       ▼
3. AhorroRepository → Supabase
   SELECT * FROM saving_goals
   JOIN users ON owner = users.id
   WHERE owner = {userId}
       │
       ▼
4. AhorroLoaded → Lista de metas
       │
       ▼
5. Usuario deposita/retira
   ┌─────────────────────────────────────┐
   │ a. llama a rpc('sp_deposit')        │
   │    o rpc('sp_withdraw')             │
   │ b. SP valida y ejecuta transaccion  │
   │ c. Retorna resultado                │
   │ d. Reload lista                     │
   └─────────────────────────────────────┘
```

---

## Variables de entorno

El archivo `.env` contiene las credenciales de Supabase:

```env
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_ANON_KEY=tu-anon-key-aqui
```

**Nunca commitear el archivo `.env` al repositorio.**

Se carga en `main.dart` usando `flutter_dotenv`:

```dart
await dotenv.load();
```

---

## Build y ejecucion

### Desarrollo

```bash
flutter run
```

### Release APK

```bash
flutter build apk --release
```

### Release con variables personalizadas

```bash
flutter build apk --release \
  --dart-define=SUPABASE_URL=https://tu-proyecto.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=tu-key
```

---

## Dependencias principales

| Paquete | Uso |
|---------|-----|
| `flutter_bloc` | Gestion de estado (BLoC) |
| `get_it` | Inyeccion de dependencias |
| `dartz` | Programacion funcional (Either) |
| `supabase_flutter` | Conexion a Supabase |
| `shared_preferences` | Almacenamiento local (sesion) |
| `flutter_dotenv` | Variables de entorno |
| `intl` | Formateo de fechas y moneda |
| `excel` | Generacion de archivos Excel |
| `share_plus` | Compartir archivos nativamente |
| `google_fonts` | Tipografia DM Sans |

---

<div align="center">

Documentacion generada para Aura v1.0.0

</div>
