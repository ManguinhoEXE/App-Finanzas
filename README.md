<div align="center">

# Aura

**Aplicacion movil para el control de finanzas personales**

[![Flutter](https://img.shields.io/badge/Flutter-3.7+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.7+-0175C2?logo=dart)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Database-3FCF8E?logo=supabase)](https://supabase.com)
[![License](https://img.shields.io/badge/License-Private-red)](#licencia)

### [Descargar APK (ultima version)](https://github.com/ManguinhoEXE/App-Finanzas/releases/latest/download/app-release.apk)

</div>

---

## Caracteristicas principales

- **Autenticacion por llaves de acceso** — Login sin contrasenas, solo ingresa tu llave unica
- **Control de gastos** — Registra, consulta y exporta tus gastos a Excel
- **Metas de ahorro** — Crea metas con progreso visual, deposita y retira fondos
- **Tema personalizable** — Alterna entre tema oscuro (black/gold) y tema pastel
- **Formato colombiano** — Numeros en pesos colombianos (COP), fechas en locale `es_CO`
- **Exportacion a Excel** — Genera archivos `.xlsx` con tus gastos y comparte directamente

---

## Stack tecnologico

| Capa | Tecnologia |
|------|------------|
| **Framework** | Flutter 3.7+ |
| **Lenguaje** | Dart 3.7+ |
| **Estado** | BLoC (flutter_bloc) |
| **Inyeccion de dependencias** | GetIt |
| **Programacion funcional** | Dartz (Either) |
| **Backend** | Supabase (PostgreSQL + Stored Procedures) |
| **Almacenamiento local** | SharedPreferences |
| **Formato de moneda** | intl (NumberFormat) |
| **Exportacion** | excel + share_plus |

---

## Arquitectura del proyecto

```
lib/
├── app/                          # Configuracion de la app
│   ├── app.dart                  # MaterialApp + rutas
│   └── di/                       # Dependencias (GetIt)
├── core/                         # Modulos compartidos
│   ├── constants/                # Constantes de la app
│   ├── errors/                   # Excepciones y fallos
│   ├── supabase/                 # Configuracion de Supabase
│   ├── theme/                    # Temas, colores, paletas
│   ├── usecases/                 # Casos de uso base
│   ├── utils/                    # Utilidades (fechas, moneda, excel)
│   └── widgets/                  # Widgets reutilizables
├── features/                     # Modulos por funcionalidad
│   ├── auth/                     # Autenticacion (login con llave)
│   ├── gastos/                   # Gastos personales
│   ├── ahorros/                  # Metas de ahorro
│   └── settings/                 # Configuracion (proximo)
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
3. Ejecuta el script completo en `scripts/refactor_database.sql`
4. Verifica que las tablas se crearon correctamente

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
| `users` | Usuarios registrados (id, name, created_at) |
| `access_keys` | Llaves de acceso unicas (key, used, used_at) |
| `expenses` | Gastos personales (categoria, fecha, valor, compartido) |
| `saving_goals` | Metas de ahorro (target_amount, current_amount, status) |
| `saving_movements` | Movimientos de ahorro (DEPOSIT, WITHDRAW) |

### Stored Procedures

| SP | Descripcion |
|----|-------------|
| `sp_activate_key` | Activa una llave y crea/busca el usuario |
| `sp_deposit` | Registra un deposito en una meta |
| `sp_withdraw` | Registra un retiro de una meta |

---

## Estructura de features

Cada feature sigue el patron **Clean Architecture**:

```
feature/
├── data/
│   ├── datasources/     # Fuente de datos (Supabase)
│   ├── models/          # Modelos de datos
│   └── repositories/    # Implementacion del repositorio
├── domain/
│   ├── entities/        # Entidades del dominio
│   ├── repositories/    # Interfaz del repositorio
│   └── usecases/        # Casos de uso
└── presentation/
    ├── bloc/            # Estado (BLoC)
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
