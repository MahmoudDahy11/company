<p align="center">
  <img src="assets/dahycompany.png" alt="Dahy Factory Logo" width="120"/>
</p>

<h1 align="center">Dahy Factory Management System</h1>

<p align="center">
  Offline-first factory ERP for production tracking, payroll, inventory, and financial oversight.
</p>

<p align="center">
  <a href="#"><img src="https://img.shields.io/badge/Flutter-3.38+-02569B?logo=flutter&logoColor=white" alt="Flutter"></a>
  <a href="#"><img src="https://img.shields.io/badge/Dart-3.11+-0175C2?logo=dart&logoColor=white" alt="Dart"></a>
  <a href="#"><img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-blue" alt="Platforms"></a>
  <a href="#"><img src="https://img.shields.io/badge/Architecture-Clean%20Architecture-blueviolet" alt="Architecture"></a>
  <a href="#"><img src="https://img.shields.io/badge/State%20Management-Bloc%20%2B%20ValueNotifier-green" alt="State Management"></a>
  <a href="#"><img src="https://img.shields.io/badge/Database-Drift%20(SQLite)-orange" alt="Database"></a>
  <a href="#"><img src="https://img.shields.io/badge/Sync-Firestore-FFCA28?logo=firebase&logoColor=black" alt="Sync"></a>
  <a href="#"><img src="https://img.shields.io/badge/License-Proprietary-red" alt="License"></a>
</p>

---

## Overview

Dahy Factory Management System is an **offline-first** cross-platform application built for internal factory operations. It manages the full lifecycle of worker piecework payroll, fixed-salary staff, supplier thread inventory, client order fulfillment, and machine maintenance — all backed by a local SQLite database with automatic Firestore sync.

The application targets **6 platforms** from a single Flutter codebase: Android, iOS, Web, Windows, Linux, and macOS.

---

## Screenshots

> _Screenshots to be added. The application supports both light and dark themes with an adaptive layout for mobile and desktop form factors._

---

## Features

| Module | Capabilities |
|--------|-------------|
| **Dashboard** | Financial summary cards, bar/line/pie charts, annual tables for clients and threads, configurable year/month filtering |
| **Workers** | Piecework stitch tracking, configurable stitch rates, daily production entries, advances, deductions, absent days, auto carry-over of excess advances, monthly payroll calculation |
| **Women Staff** | Fixed monthly salary management, advances, deductions, auto carry-over, combined payroll export |
| **Threads & Suppliers** | Supplier records, thread purchase tracking with item name/color number/quantity, supplier payments, outstanding balance per supplier |
| **Clients** | Client records, order models (piece count, price per piece), payment tracking, outstanding balance |
| **Maintenance** | Machine fault records with cost tracking and total cost aggregation |
| **Auth** | Single-admin email/password login via Firebase Auth with "Remember Me" |
| **Excel Export** | Payroll (combined workers + staff), thread monthly/annual summaries, client summaries |
| **Sync** | Background Firestore sync with visual status indicator (synced/pending/syncing/failed) |
| **Localization** | Arabic (RTL, default) and English (LTR) with runtime switching |
| **Theming** | Material 3 with light/dark mode, teal seed palette |

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **Framework** | Flutter 3.38+ / Dart 3.11+ |
| **Architecture** | Clean Architecture (feature-first) |
| **State Management** | flutter_bloc (Cubit) + ValueNotifier |
| **Local Database** | Drift (SQLite) with type-safe DAOs and migrations |
| **Remote Sync** | Cloud Firestore |
| **Authentication** | Firebase Auth (email/password) |
| **Navigation** | GoRouter with StatefulShellRoute |
| **DI** | get_it + injectable (code-generated) |
| **Charts** | fl_chart |
| **Excel Export** | excel package + open_file |
| **Connectivity** | connectivity_plus |
| **Localization** | flutter_localizations + ARB files + intl |
| **Splash** | flutter_native_splash |
| **CI/CD** | GitHub Actions (APK build on push to main) |

---

## Architecture

The project follows **Clean Architecture** organized by feature, with strict separation of concerns:

```
lib/
├── main.dart                          # Entry point
├── bootstrap.dart                     # DI init, Firebase init, sync startup
├── app.dart                           # MaterialApp.router with GoRouter
├── firebase_options.dart              # Auto-generated Firebase config
│
├── core/
│   ├── auth/                          # Firebase Auth wrapper (ChangeNotifier)
│   ├── database/                      # Drift database definition + migrations
│   ├── di/                            # get_it + injectable wiring
│   ├── export/                        # Centralized Excel export service
│   ├── firebase/                      # Firebase init + provider
│   ├── localization/                  # AppLocaleController, ARB files, generated l10n
│   ├── router/                        # GoRouter config with auth redirect + adaptive shell
│   ├── sync/                          # Offline sync queue, connectivity, Firestore push/pull
│   ├── theme/                         # Material 3 light + dark themes
│   ├── ui/                            # Splash screen
│   └── utils/                         # Breakpoints, spacing, text styles, validation
│
└── features/
    ├── auth/                          # Login page + cubit
    ├── dashboard/                     # Dashboard page, charts, summary cards, filters
    ├── workers/                       # Worker CRUD, production entries, advances, deductions
    ├── women_staff/                   # Staff CRUD, salary management, advances, deductions
    ├── threads/                       # Supplier CRUD, thread purchases, payments
    ├── clients/                       # Client CRUD, order models, payments
    ├── maintenance/                   # Machine fault records
    └── shared/                        # Shared presentation widgets
```

Each feature follows a consistent internal structure:

```
feature/
├── data/
│   ├── datasources/        # Local DB queries
│   ├── models/             # Drift table definitions (code-generated DAOs)
│   └── repositories/       # Repository implementations
├── domain/
│   ├── entities/           # Domain models
│   ├── repositories/       # Abstract repository contracts
│   └── usecases/           # Business logic use cases
└── presentation/
    ├── bloc/               # Cubit + State classes
    ├── pages/              # Full-page widgets
    └── widgets/            # Reusable UI components
```

---

## State Management

The project uses a **dual-strategy** approach:

1. **flutter_bloc (Cubit)** — All feature-level state that crosses widget boundaries or involves async data loading. Each major feature has one or more Cubits (e.g., `WorkersCubit`, `WorkerDetailsCubit`, `DashboardCubit`).

2. **ValueNotifier + ValueListenableBuilder** — Local UI state such as theme mode toggles, locale selection, and simple visibility flags. `setState` is **not used** anywhere in the codebase.

The `AppLocaleController` manages both locale and theme mode via `ValueNotifier`, enabling app-wide reactivity without coupling to Bloc for simple UI concerns.

---

## Database

The local database uses **Drift** (SQLite) with 16 tables covering all application entities:

| Table | Purpose |
|-------|---------|
| `workers` | Active/inactive worker records |
| `worker_production_entries` | Daily stitch counts |
| `worker_advances` | Advances with carry-over |
| `worker_deductions` | Payroll deductions |
| `stitch_rates` | Rate per 100K stitches (dated) |
| `worker_absent_days` | Absence tracking |
| `women_staff_members` | Fixed-salary staff |
| `staff_advances` | Staff advances with carry-over |
| `staff_deductions` | Staff payroll deductions |
| `suppliers` | Thread supplier records |
| `thread_purchases` | Itemized thread purchases |
| `supplier_payments` | Payments to suppliers |
| `clients` | Client records |
| `client_models` | Order models (piece count, price) |
| `client_payments` | Payments from clients |
| `maintenance_fault_records` | Machine fault logs |
| `sync_queue` | Offline sync operation queue |

Current schema version: **8** (with incremental migration strategy).

---

## Offline-First Sync

All data operations write to the local Drift database immediately. The sync layer operates asynchronously:

1. Every write is recorded in a `sync_queue` table with operation type, table name, record ID, and JSON payload.
2. `ConnectivityService` monitors network state via `connectivity_plus`.
3. When online, `SyncService` processes the queue FIFO, pushing to Firestore under `factory_backup/{tableName}/records/{recordId}`.
4. Failed operations retry up to 3 times, then are marked as `failed`.
5. A visual indicator in the app bar shows sync state: green (synced), spinning (syncing), orange (pending), red (failed).
6. On first launch, a one-time pull restores data from Firestore to the local database.

**Important:** There is no custom backend API. Firebase Auth handles authentication; Firestore is used exclusively as a remote backup target.

---

## Environment Variables

Create a `.env` file in the project root or configure via Firebase CLI:

```env
# Firebase configuration is auto-generated via `flutterfire configure`
# Run the following command to regenerate:
flutterfire configure --project=dahy-company

# For Android, ensure google-services.json exists in android/app/
# For iOS, ensure GoogleService-Info.plist exists in ios/Runner/
```

The project uses `flutterfire configure` output (`lib/firebase_options.dart`) for platform-specific Firebase initialization.

---

## Installation

### Prerequisites

- Flutter SDK >=3.38.4
- Dart >=3.11.4
- Firebase project (`dahy-company`) with Authentication and Firestore enabled

### Setup

```bash
# Clone the repository
git clone <repository-url>
cd company

# Install dependencies
flutter pub get

# Generate code (Drift DAOs, Injectable DI, Localization)
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n

# Generate native splash
flutter pub run flutter_native_splash:create

# Configure Firebase
flutterfire configure --project=dahy-company
```

### Running

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Web
flutter run -d chrome

# Linux
flutter run -d linux

# macOS
flutter run -d macos

# Windows
flutter run -d windows
```

> **Note:** Firebase is not supported on Linux. The app falls back to mock auth and disables sync with debug logging.

### Build

```bash
# Android APK (split by ABI)
flutter build apk --release --split-per-abi

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Desktop platforms
flutter build linux --release
flutter build macos --release
flutter build windows --release
```

---

## Responsive Design

The UI adapts to three breakpoints using `LayoutBuilder`:

| Breakpoint | Range | Layout |
|------------|-------|--------|
| Mobile | < 600px | BottomNavigationBar |
| Tablet | 600–1024px | Adaptive (condensed NavigationRail) |
| Desktop | > 1024px | Persistent NavigationRail sidebar |

All form sheets and dialogs use adaptive presentation (bottom sheet on mobile, centered dialog on desktop).

---

## Performance

- **Offline-first architecture** eliminates network latency for all read operations.
- **Drift** provides compiled, type-safe SQL queries with Stream-based reactive updates.
- **Bloc** ensures widgets rebuild only when their specific state changes.
- **`StatefulShellRoute.indexedStack`** preserves tab state and prevents unnecessary rebuilds on navigation.
- Code-generated DI (`injectable`) avoids reflection and resolves dependencies at compile time.

---

## Roadmap

- [ ] Unit and widget test coverage for all features
- [ ] Integration tests for critical workflows (worker payroll, client invoicing)
- [ ] Rich notifications for sync failures
- [ ] Data export via email/cloud share
- [ ] Multi-user support with role-based access
- [ ] Barcode/QR scanning for inventory items
- [ ] Automated backup to additional cloud providers
- [ ] Performance profiling for large datasets (10K+ records)

---

## Contributing

This is an internal project. External contributions are not currently accepted.

For internal contributors:

1. Follow the existing architecture and code conventions documented in `plan.md`.
2. Do **not** use `setState` — prefer Bloc or ValueNotifier.
3. Run `dart run build_runner build` after modifying Drift tables or Injectable modules.
4. Run `flutter gen-l10n` after modifying ARB files in `lib/core/localization/arb/`.
5. Ensure the project analyzes cleanly: `flutter analyze`.

---

## License

Proprietary — All rights reserved. This software is for internal use only and is not publicly licensed for distribution or modification.

---

## Contact

**Dahy Company**  
Maintained by the internal development team.

For questions or support, refer to the project planning documents:

- [`plan.md`](plan.md) — Full technical specification and architecture guide
- [`dash.md`](dash.md) — Dashboard design and financial reporting spec
