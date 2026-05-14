<p align="center">
  <img src="assets/dahycompany.png" alt="Dahy Factory Logo" width="120"/>
</p>

<h1 align="center">Factory Management System</h1>

<p align="center">
  A production-grade, offline-first ERP built with Flutter — managing payroll, inventory, client orders, and financials across 6 platforms from a single codebase.
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

## About This Project

This is a **real-world client project** I designed and built end-to-end for a garment manufacturing factory. The client needed to replace a fully manual, paper-based workflow covering worker payroll, thread inventory, client orders, and machine maintenance — with a reliable digital system that works without internet.

The core challenge was building something that **non-technical factory staff could operate daily**, while maintaining production-grade code quality behind the scenes.

> ⚠️ Source code is private (proprietary client work). This README documents architecture, technical decisions, and outcomes for portfolio purposes.

---

## Screenshots

<div align="center">
  <table>
    <tr>
      <td width="50%"><img src="https://github.com/user-attachments/assets/d8c471b4-ca3a-4201-a643-d34392a6d413" alt="Dashboard Overview"/><br/><em>Dashboard — financial summary and charts</em></td>
      <td width="50%"><img src="https://github.com/user-attachments/assets/f3bae7cd-a584-4920-a0cc-65be9f738493" alt="Dashboard Annual Tables"/><br/><em>Dashboard — annual client and thread tables</em></td>
    </tr>
    <tr>
      <td width="50%"><img src="https://github.com/user-attachments/assets/d631e967-e3c3-4f83-8c98-673cab8b7eb1" alt="Dashboard Charts"/><br/><em>Dashboard — bar and pie chart visualizations</em></td>
      <td width="50%"><img src="https://github.com/user-attachments/assets/50191b17-75a4-4129-913f-d9baf9d072f2" alt="Dashboard Financial Section"/><br/><em>Dashboard — detailed financial breakdown</em></td>
    </tr>
    <tr>
      <td width="50%"><img src="https://github.com/user-attachments/assets/47c7faf1-cc89-483b-85f2-9d96a3346fce" alt="Workers"/><br/><em>Workers — production tracking and payroll</em></td>
      <td width="50%"><img src="https://github.com/user-attachments/assets/82655aa1-f144-486b-a4b4-85ac42e3d723" alt="Women Staff"/><br/><em>Women Staff — salary and advance management</em></td>
    </tr>
    <tr>
      <td width="50%"><img src="https://github.com/user-attachments/assets/21d0dc28-450f-4c3a-9972-1ecd9bb526a6" alt="Threads & Suppliers"/><br/><em>Threads & Suppliers — inventory and payments</em></td>
      <td width="50%"><img src="https://github.com/user-attachments/assets/4ebfe7eb-f3e4-4d61-b9d7-75cabbfa7cf0" alt="Clients"/><br/><em>Clients — order models and payment tracking</em></td>
    </tr>
    <tr>
      <td width="50%"><img src="https://github.com/user-attachments/assets/ac6f387e-b191-40a7-baef-b3eda73e8b55" alt="Maintenance"/><br/><em>Maintenance — machine fault records</em></td>
      <td width="50%"><img src="https://github.com/user-attachments/assets/0e1e1302-76cb-4eb1-8871-fc37fcca5c60" alt="Authentication"/><br/><em>Authentication — admin login screen</em></td>
    </tr>
  </table>
</div>

---

## Key Technical Decisions

### Why Offline-First?
The factory floor has unreliable connectivity. A network-dependent app would be unusable. The decision was to make **local SQLite the source of truth** and treat Firestore as a passive backup — not the primary data layer. This means zero latency on reads/writes and full functionality with no internet.

### Why Clean Architecture?
This was a conscious decision to future-proof the codebase. The domain layer has zero Flutter/Firebase dependencies — business logic is entirely framework-agnostic. This made it straightforward to, for example, swap the local DB from Drift to another SQLite wrapper without touching a single use case.

### Why Bloc + ValueNotifier (not just Bloc)?
Not everything needs the full Bloc overhead. Theme mode and locale are simple, synchronous, app-wide values — `ValueNotifier` is the right tool. Bloc is reserved for async feature state (data loading, mutations, errors). `setState` is **not used anywhere** in the codebase.

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

## Offline-First Sync

All data operations write to the local Drift database immediately. The sync layer operates asynchronously:

1. Every write is recorded in a `sync_queue` table with operation type, table name, record ID, and JSON payload.
2. `ConnectivityService` monitors network state via `connectivity_plus`.
3. When online, `SyncService` processes the queue FIFO, pushing to Firestore under `factory_backup/{tableName}/records/{recordId}`.
4. Failed operations retry up to 3 times, then are marked as `failed`.
5. A visual indicator in the app bar shows sync state: green (synced), spinning (syncing), orange (pending), red (failed).
6. On first launch, a one-time pull restores data from Firestore to the local database.

> **No custom backend.** Firebase Auth handles authentication; Firestore is used exclusively as a remote backup target.

---

## Database Schema

Local database uses **Drift** (SQLite) with 17 tables across schema version **8** (incremental migrations):

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

---

## Responsive Design

| Breakpoint | Range | Layout |
|------------|-------|--------|
| Mobile | < 600px | BottomNavigationBar |
| Tablet | 600–1024px | Adaptive condensed NavigationRail |
| Desktop | > 1024px | Persistent NavigationRail sidebar |

All form sheets and dialogs use adaptive presentation (bottom sheet on mobile, centered dialog on desktop).

---

## Performance Highlights

- Offline-first eliminates network latency for all reads.
- Drift provides compiled, type-safe SQL with Stream-based reactive updates.
- Bloc ensures widgets rebuild only on their specific state slice.
- `StatefulShellRoute.indexedStack` preserves tab state across navigation.
- Code-generated DI (`injectable`) resolves dependencies at compile time — no reflection.

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

## License

Proprietary — All rights reserved. Built for a private client; not licensed for public distribution or modification.

---

## Contact

Built by **Mahmoud Dahy**
📧 dahym2028@gmail.com | 💼 [linkedin.com/in/mahmoud-dahy](https://www.linkedin.com/in/mahmoud-dahy/) | 🐙 [github.com/MahmoudDahy11](https://github.com/MahmoudDahy11)
