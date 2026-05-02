# 🏭 Factory Management System — Project Specification

---

## 📌 Overview

| Item | Details |
|------|---------|
| **Platform** | Mobile + Desktop (Flutter) |
| **Type** | Internal factory system (not published) |
| **Language** | Arabic + English (Localization with switch) |
| **Direction** | RTL (Arabic default) |
| **Auth** | Admin only — single user login |

---

## 🏗️ Architecture

**Pattern:** Clean Architecture (per feature)

```
lib/
├── core/
│   ├── di/                  # Dependency Injection (get_it + injectable)
│   ├── database/            # Drift local DB setup
│   ├── firebase/            # Firebase init + sync
│   ├── localization/        # ARB files — Arabic + English
│   ├── router/              # GoRouter navigation
│   ├── theme/               # App theme (light/dark)
│   └── utils/               # Helpers, extensions, constants
│
├── features/
│   ├── dashboard/           # Admin panel (home screen)
│   ├── workers/             # Feature 1
│   ├── women_staff/         # Feature 2
│   ├── threads/             # Feature 3
│   └── clients/             # Feature 4
│
└── main.dart
```

### Responsive & Adaptive Design Rules

The app runs on **mobile and desktop** — the UI must adapt to every screen size without breaking.

#### Breakpoints

| Name | Width | Target |
|------|-------|--------|
| `mobile` | < 600px | Android / iOS phones |
| `tablet` | 600px – 1024px | tablets |
| `desktop` | > 1024px | Windows / Linux / macOS |

#### Layout Strategy

- **Never hardcode widths or heights** — use `MediaQuery`, `LayoutBuilder`, or `constraints` from `BoxConstraints`
- Use `LayoutBuilder` at the screen level to switch between mobile and desktop layouts
- On mobile → `BottomNavigationBar` for navigation
- On desktop → `NavigationRail` or `NavigationDrawer` (sidebar) for navigation
- Lists and grids adapt: mobile = 1 column, tablet = 2 columns, desktop = 3+ columns
- Dashboard cards: `Wrap` or `GridView` with adaptive cross-axis count

```dart
// Pattern used across all screens
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 1024) return DesktopLayout();
    if (constraints.maxWidth > 600)  return TabletLayout();
    return MobileLayout();
  },
);
```

#### Adaptive Components

- **Text:** use relative sizes via a `AppTextStyles` class — never hardcode `fontSize`
- **Spacing:** define spacing constants (`AppSpacing.sm`, `.md`, `.lg`) — never hardcode padding values
- **Dialogs:** on mobile → `BottomSheet`, on desktop → centered `Dialog`
- **Forms:** on desktop, form fields appear side-by-side in rows; on mobile, stacked vertically
- **Tables (Excel-like views):** use `SingleChildScrollView` horizontally on mobile, full-width on desktop

#### Package

- Use `flutter_adaptive_scaffold` or manual `LayoutBuilder` — no third-party responsive packages that add unnecessary abstraction

---

### State Management Rules

- **`setState` is strictly forbidden** anywhere in the codebase
- For simple local UI state (toggle, visibility, counter) → use `ValueNotifier` + `ValueListenableBuilder`
- For feature-level state (data loading, form submission, errors) → use `Bloc` / `Cubit`
- Rule of thumb: if the state lives inside one widget → `ValueNotifier`, if it crosses widgets or involves business logic → `Cubit`

```dart
// WRONG — never do this
setState(() => isLoading = true);

// RIGHT — local UI state
final isLoading = ValueNotifier<bool>(false);
// in build:
ValueListenableBuilder<bool>(
  valueListenable: isLoading,
  builder: (context, value, _) => value
    ? const CircularProgressIndicator()
    : const SizedBox.shrink(),
);
```

---

**Per-feature structure (Clean Architecture):**
```
feature/
├── data/
│   ├── models/              # Drift table models + JSON serialization
│   ├── datasources/         # Local (Drift) + Remote (Firebase)
│   └── repositories/        # Repository implementation
├── domain/
│   ├── entities/            # Pure Dart entities
│   ├── repositories/        # Abstract repository interface
│   └── usecases/            # One class per use case
└── presentation/
    ├── bloc/                # Bloc + Cubit (state management)
    ├── pages/               # Full screens
    └── widgets/             # Reusable UI components
```

---

## 📦 Tech Stack

| Layer | Package |
|-------|---------|
| State Management | `flutter_bloc` |
| Local Database | `drift` (SQLite — relational, type-safe) |
| Remote Database | `firebase_core` + `cloud_firestore` |
| Dependency Injection | `get_it` + `injectable` |
| Navigation | `go_router` |
| Localization | `flutter_localizations` + ARB files |
| Excel Export | `excel` |
| Charts | `fl_chart` |
| Connectivity Detection | `connectivity_plus` |
| Date Picker | `table_calendar` |
| PDF (future) | `pdf` package |

---

## 🔄 Offline-First Strategy

### Core Principle
**The admin never interacts with Firebase directly.** Every read and write goes through Drift (local DB) first. Firebase is purely a background sync target. The admin experience is 100% identical whether online or offline.

```
Admin action
    │
    ▼
Drift (local DB)  ──► UI updates instantly from Drift
    │
    ▼
sync_queue table  ──► background SyncService watches connectivity
    │                        │
    │              (offline) │ (online)
    │                        ▼
    └──────────────► Firestore upload → mark as synced
```

### sync_queue Table (Drift)

| Column | Type | Notes |
|--------|------|-------|
| id | int PK | auto-increment |
| operation | String | `INSERT` / `UPDATE` / `DELETE` |
| table_name | String | e.g. `worker_production` |
| record_id | int | local Drift record ID |
| payload | String | JSON snapshot of the record |
| created_at | DateTime | when the operation happened |
| status | String | `pending` / `synced` / `failed` |
| retry_count | int | increments on each failed attempt |

### How It Works — Step by Step

**1. Admin adds/edits/deletes any record (online or offline):**
- Drift writes the record immediately
- A `SyncQueueEntry` is inserted into `sync_queue` with status `pending`
- UI reads from Drift → admin sees the data instantly, no waiting

**2. SyncService (background service):**
- Listens to `connectivity_plus` stream
- When connection is detected → starts processing the `sync_queue`
- Processes entries in order of `created_at` (FIFO)
- On success → marks entry as `synced`
- On failure → increments `retry_count`, retries up to 3 times, then marks `failed`

**3. Sync status indicator (UI):**
- Small icon in the app bar showing sync status:
  - ✅ Green cloud → all synced
  - 🔄 Spinning → syncing in progress
  - ⚠️ Orange → pending items (offline)
  - ❌ Red → failed items (needs attention)
- Admin can tap the icon to see a list of pending/failed items

### Folder Addition to Core

```
lib/
├── core/
│   ├── sync/
│   │   ├── sync_queue_table.dart      # Drift table definition
│   │   ├── sync_service.dart          # Background sync logic
│   │   ├── connectivity_service.dart  # Wraps connectivity_plus
│   │   └── sync_status_cubit.dart     # Exposes sync state to UI
```

### Repository Pattern with Offline-First

Every repository follows this pattern — the domain layer never knows whether data came from local or remote:

```dart
// Example: WorkerRepository implementation
Future<void> addProduction(WorkerProduction production) async {
  // 1. Write to local DB immediately
  final id = await localDataSource.insertProduction(production);

  // 2. Queue for Firebase sync
  await syncQueue.add(SyncQueueEntry(
    operation: 'INSERT',
    tableName: 'worker_production',
    recordId: id,
    payload: production.toJson(),
  ));

  // SyncService handles the rest in the background
}
```

### Conflict Resolution
Since there is **one admin and one device**, conflicts cannot happen. No merge logic is needed. Last-write always wins — Firestore is only a backup copy.

### What Happens on First Launch (fresh install)
- If Firestore already has data (e.g. reinstall): `SyncService` does a one-time **pull** from Firestore into Drift on first login
- After that: Drift is always the source of truth, Firestore is the backup

---

## 🖥️ Navigation Structure

**Bottom Navigation Bar** (custom styled) — 5 tabs:

| # | Tab | Arabic Label | Icon |
|---|-----|-------------|------|
| 1 | Dashboard | لوحة التحكم | dashboard |
| 2 | Workers | العمال | construction |
| 3 | Women Staff | الحريم | group |
| 4 | Threads | الخيوط | inventory |
| 5 | Clients | الزبايين | handshake |

---

## 📊 Feature 0 — Admin Dashboard (لوحة التحكم)

**Screen type:** Home screen — first screen after login.

### Displayed Statistics (Current Month by default):

#### Summary Cards (top row):
- 💰 **إجمالي أجور العمال** — total worker wages this month
- 👩 **إجمالي أجور الحريم** — total women staff wages this month
- 🧵 **إجمالي مشتريات الخيوط** — total thread purchases this month
- 👥 **إجمالي على الزبايين** — total amount owed by clients

#### Charts:
- **Bar chart** — monthly worker production comparison (top 5 workers)
- **Line chart** — thread purchases over the year (monthly)
- **Pie chart** — client balance distribution (how much each client owes)
- **Bar chart** — women staff advances taken this month

#### Quick Info:
- Number of workers registered
- Number of absent days this month (all workers combined)
- Pending client balances (clients with unpaid amounts)
- Thread suppliers with outstanding balance

#### Filter:
- Month/Year selector to view any historical period

---

## 👷 Feature 1 — Workers (العمال)

### Concept:
Each worker produces a number of stitches per day. The rate is configurable by the admin. Payment is calculated as:

```
Daily earnings = (stitch count / 100,000) × rate (EGP)
Monthly total  = sum of all daily earnings
Net salary     = monthly total − advances taken this month
Carry-over     = if advances > monthly total → difference rolls to next month
```

### Database Tables (Drift):

**workers**
| Column | Type | Notes |
|--------|------|-------|
| id | int PK | auto-increment |
| name | String | worker full name |
| created_at | DateTime | registration date |
| is_active | bool | soft delete |

**worker_production**
| Column | Type | Notes |
|--------|------|-------|
| id | int PK | |
| worker_id | int FK | → workers.id |
| date | DateTime | production date |
| stitch_count | int | number of stitches |
| notes | String? | optional notes |

**worker_advances**
| Column | Type | Notes |
|--------|------|-------|
| id | int PK | |
| worker_id | int FK | → workers.id |
| amount | double | advance amount (EGP) |
| date | DateTime | date taken |
| notes | String? | reason/notes |
| carried_over | bool | true if rolled from previous month |

**stitch_rate**
| Column | Type | Notes |
|--------|------|-------|
| id | int PK | |
| rate | double | EGP per 100,000 stitches |
| effective_from | DateTime | when this rate became active |

### Screens:

#### 1. Workers List (قائمة العمال)
- List of all active workers
- Each card shows: name, this month's total earnings, advances taken
- Search bar to find worker by name
- FAB to add new worker

#### 2. Worker Details (تفاصيل العامل)
- Worker name + registration date
- **Monthly summary tab:**
  - Total stitch count this month
  - Total earnings (calculated)
  - Total advances this month
  - Carry-over amount (from previous month if any)
  - Net salary = earnings − advances − carry-over
- **Production log tab:**
  - Daily table: date | stitch count | daily earnings
  - Add production entry (date picker + stitch count input)
  - Edit / delete entry
- **Advances tab:**
  - List of all advances with dates
  - Add new advance (amount + date + optional note)
  - Carried-over advances marked visually

#### 3. Absent Days
- Per-worker: input number of absent days per month
- Shown in worker details and in dashboard summary

### Excel Export (monthly sheet):
| Column | Content |
|--------|---------|
| الاسم | Worker name |
| إجمالي الغرز | Total stitch count |
| الأرباح | Total earnings |
| السلف | Total advances |
| الترحيل | Carry-over from last month |
| أيام الغياب | Absent days |
| الصافي | Net salary |

- All workers in one sheet
- One sheet per month (tabs named by month/year)
- Top worker highlighted
- Color: teal/green rows

### Charts (within feature):
- Bar chart: monthly production comparison across workers
- Line chart: individual worker's production over months

### Business Rules:
- Stitch rate is global but can be updated anytime — old records keep old rate
- If advances > earnings: difference auto-carries to next month (shown as carry-over)
- Absent days are informational only (no automatic deduction unless admin applies manually)

---

## 👩 Feature 2 — Women Staff (الحريم)

### Concept:
Fixed monthly salary for each staff member. Admin can change the salary at any time. Advances are tracked and deducted from salary.

```
Net salary = fixed monthly salary − advances taken this month
Carry-over = if advances > salary → difference rolls to next month
```

### Database Tables (Drift):

**women_staff**
| Column | Type | Notes |
|--------|------|-------|
| id | int PK | |
| name | String | full name |
| monthly_salary | double | current fixed salary |
| created_at | DateTime | |
| is_active | bool | soft delete |

**staff_advances**
| Column | Type | Notes |
|--------|------|-------|
| id | int PK | |
| staff_id | int FK | → women_staff.id |
| amount | double | advance amount (EGP) |
| date | DateTime | date taken |
| notes | String? | |
| carried_over | bool | rolled from previous month |

### Screens:

#### 1. Staff List (قائمة الحريم)
- List of all active staff
- Each card: name, fixed salary, this month's advances, net salary
- FAB to add new staff member

#### 2. Staff Details (تفاصيل الموظفة)
- Name + monthly salary (editable by admin)
- **Monthly summary:**
  - Fixed salary
  - Total advances this month
  - Carry-over (if any)
  - Net salary
- **Advances tab:**
  - List of advances with date + amount
  - Add / delete advance
  - Carried-over advances marked

### Excel Export (monthly sheet — combined with workers):
- Women staff rows in the **same sheet** as workers
- Visually distinguished by a different row color (e.g. pink/rose)
- Columns: الاسم | الراتب الثابت | السلف | الترحيل | الصافي

---

## 🧵 Feature 3 — Threads (الخيوط)

### Concept:
Tracks thread purchases from multiple suppliers. Each purchase has an item type, color number (grade), date, and price. Payments to suppliers are tracked and deducted from the outstanding balance.

```
Outstanding balance per supplier = total purchases − total payments made
Annual total = sum of all purchases in the year
```

### Database Tables (Drift):

**suppliers**
| Column | Type | Notes |
|--------|------|-------|
| id | int PK | |
| name | String | supplier name |
| phone | String? | contact number |
| created_at | DateTime | |

**thread_purchases**
| Column | Type | Notes |
|--------|------|-------|
| id | int PK | |
| supplier_id | int FK | → suppliers.id |
| item_name | String | e.g. "بوليستر", "قطن" |
| color_number | String | e.g. "1233" (color grade/number) |
| purchase_date | DateTime | |
| price | double | EGP |
| quantity | double | kg or units |
| unit | String | "كيلو" / "بكرة" etc. |
| notes | String? | |

**supplier_payments**
| Column | Type | Notes |
|--------|------|-------|
| id | int PK | |
| supplier_id | int FK | → suppliers.id |
| amount | double | payment made (EGP) |
| payment_date | DateTime | |
| notes | String? | |

### Screens:

#### 1. Suppliers List (قائمة الموردين)
- Each card: supplier name, total purchased, total paid, outstanding balance
- FAB to add new supplier

#### 2. Supplier Details (تفاصيل المورد)
- Supplier name + contact
- **Outstanding balance** (prominent, top of screen)
- **Purchases tab:**
  - List: item name | color number | date | price | quantity
  - Monthly filter
  - Add new purchase entry
- **Payments tab:**
  - List of payments with dates
  - Add new payment

#### 3. Threads Overview (نظرة عامة على الخيوط)
- Total purchased this month
- Total purchased this year
- Total paid this year
- Total outstanding (all suppliers combined)

### Excel Export:
- Per month tab: item | color number | supplier | date | price | quantity
- Annual summary tab: supplier | total purchased | total paid | outstanding

### Charts:
- Bar chart: most purchased item types this year
- Line chart: monthly purchase spending
- Per-supplier: bar showing purchased vs paid

### Business Rules:
- Purchases and payments are always linked to a specific supplier
- Outstanding balance = purchases − payments (per supplier)
- Annual totals span Jan–Dec of the selected year
- Monthly view is for detail; annual view for overall financial picture

---

## 🤝 Feature 4 — Clients (الزبايين)

### Concept:
Each client brings their own models (موديلات). Each model has a name, piece count, and price per piece. Payments from clients are tracked against the total owed.

```
Total per model  = piece count × price per piece
Total per client = sum of all models
Outstanding      = total − payments received
```

### Database Tables (Drift):

**clients**
| Column | Type | Notes |
|--------|------|-------|
| id | int PK | |
| name | String | client name |
| phone | String? | |
| created_at | DateTime | |
| is_active | bool | soft delete |

**client_models**
| Column | Type | Notes |
|--------|------|-------|
| id | int PK | |
| client_id | int FK | → clients.id |
| model_name | String | model/style name |
| piece_count | int | number of pieces |
| price_per_piece | double | EGP per piece |
| date | DateTime | when model was added |
| notes | String? | |

**client_payments**
| Column | Type | Notes |
|--------|------|-------|
| id | int PK | |
| client_id | int FK | → clients.id |
| amount | double | payment received (EGP) |
| payment_date | DateTime | |
| notes | String? | |

### Screens:

#### 1. Clients List (قائمة الزبايين)
- Each card: client name, total owed, total paid, outstanding balance
- Clients with high outstanding balance shown with visual indicator
- FAB to add new client

#### 2. Client Details (تفاصيل الزبون)
- Client name + contact
- **Outstanding balance** (prominent, colored by status)
- **Models tab:**
  - List: model name | pieces | price/piece | total | date
  - Add new model entry
  - Edit / delete model
- **Payments tab:**
  - List of payments received with dates
  - Add new payment

### Excel Export (per client or all clients):
- All clients sheet: client name | total models | total amount | paid | outstanding
- Per-client sheet: model name | pieces | price | total | date + payments list

### Charts:
- Pie chart: outstanding balance per client
- Bar chart: top clients by total order value

---

## 🔐 Auth — Admin Login

- Single admin account
- Email + password via Firebase Auth
- "Remember me" using shared preferences
- No registration screen (admin account created manually in Firebase console)

---

## 🌍 Localization

| Key | Arabic | English |
|-----|--------|---------|
| App name | نظام المصنع | Factory System |
| Workers | العمال | Workers |
| Women staff | الحريم | Women Staff |
| Threads | الخيوط | Threads |
| Clients | الزبايين | Clients |
| Dashboard | لوحة التحكم | Dashboard |
| Net salary | الصافي | Net Salary |
| Advance | سلفة | Advance |
| Carry-over | ترحيل | Carry-over |
| Stitch count | عدد الغرز | Stitch Count |
| Outstanding | المتبقي | Outstanding |
| Export to Excel | تصدير إكسيل | Export to Excel |

- Default: Arabic (RTL)
- Switchable to English (LTR) from settings
- All number formatting adapts to locale

---

## 📁 Firebase Structure (Firestore — backup/sync)

```
factory/
├── workers/{workerId}
│   ├── info: { name, createdAt, isActive }
│   ├── production/{prodId}: { date, stitchCount, notes }
│   └── advances/{advId}: { amount, date, carriedOver }
├── women_staff/{staffId}
│   ├── info: { name, monthlySalary, createdAt }
│   └── advances/{advId}: { amount, date, carriedOver }
├── suppliers/{supplierId}
│   ├── info: { name, phone }
│   ├── purchases/{purchaseId}: { itemName, colorNumber, date, price, qty }
│   └── payments/{paymentId}: { amount, date }
└── clients/{clientId}
    ├── info: { name, phone }
    ├── models/{modelId}: { modelName, pieceCount, pricePerPiece, date }
    └── payments/{paymentId}: { amount, date }
```

---

## ✅ Development Order (Recommended)

1. **Project setup** — Clean Architecture folders, Drift DB, Firebase, DI, GoRouter, Localization
2. **Offline-First core** — `sync_queue` table, `SyncService`, `ConnectivityService`, sync status UI indicator
3. **Feature 1: Workers** — most complex, sets the pattern for all others (including sync pattern)
4. **Feature 2: Women Staff** — simpler variant of workers
5. **Feature 3: Threads** — different domain (purchases/suppliers)
6. **Feature 4: Clients** — similar pattern to threads
7. **Dashboard** — aggregates data from all features (built last so all data sources exist)
8. **Excel Export** — add to each feature after data layer is stable

---

*Last updated: May 2026*
