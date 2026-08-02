# PPS HelpDesk

A ticket-based help desk app for tracking support requests: create tickets, triage them by status and priority, search and filter the queue, and manage each ticket's lifecycle through to closure. Built as an offline-first mobile app with no backend dependency.

## Tech Stack & Key Packages

- **Flutter** — cross-platform UI
- **flutter_bloc** — Cubit-based state management
- **hive / hive_flutter** — local NoSQL persistence
- **get_it** — service locator for dependency injection
- **flutter_screenutil** — responsive sizing across screen densities
- **fluttertoast** — lightweight, context-free user feedback
- **flutter_launcher_icons** — generates native app icons for Android and iOS

## Architecture

Feature-first Clean Architecture. Shared infrastructure lives in `lib/core/` (constants, theme, reusable widgets, services). Each feature is self-contained under `lib/features/<feature_name>/`, split into three layers:

- **data/** — Hive models, local data source, repository implementation
- **domain/** — entities and repository interfaces (no Flutter or Hive imports)
- **presentation/** — Cubit + UI, organized by sub-feature: `dashboard/`, `list/`, `create/`, `details/`, plus `shared/` for widgets and helpers used across more than one of those (status/priority chips, form field sections, enum label mappers)

The domain layer has no dependency on data or presentation. The data layer implements domain interfaces rather than the reverse, so persistence can be swapped without touching business logic or UI.

## State Management

Each screen owns a `TicketCubit` (via `BlocProvider`, resolved through `get_it`), which exposes a small sealed `TicketState` hierarchy: `TicketInitial`, `TicketLoading`, `TicketLoaded`, `TicketError`. `TicketLoaded` is immutable and carries the raw ticket list alongside the active search query, status/priority filters, and sort order — filtering and sorting are derived, not stored, computed on read from that one state object. This keeps the Cubit as the single source of truth for a screen and avoids re-fetching from Hive on every keystroke or filter change.

Screens are decoupled from each other: navigating to create or edit a ticket doesn't share a Cubit instance with the screen that pushed it, so each screen reloads its own data on return rather than relying on shared mutable state.

## Local Data Persistence

Tickets are stored in a single Hive box (`tickets_box`) via a `TicketModel` (`@HiveType`) that mirrors the domain `TicketEntity`, converting enums to indices for storage. All reads and writes go through a `TicketLocalDataSource`, so the rest of the app never touches Hive directly. Everything is offline-first — there is no remote sync or API layer.

## Setup & Execution

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
flutter test
```

The `build_runner` step generates the Hive type adapter (`ticket_model.g.dart`) and must be re-run after changing any `@HiveType`/`@HiveField` annotations.

## Key Assumptions & Limitations

- Ticket IDs are generated client-side on creation in the form `#TICK-XXXXXX` (the last six digits of the creation timestamp in milliseconds) — not guaranteed globally unique, but sufficient for a local, single-user dataset.
- No authentication, multi-user support, or backend sync. All data is local to the device and lost if the app is uninstalled.
- No pagination — the ticket list loads and filters the full Hive box in memory, which is fine at the scale this app targets but wouldn't hold up for a large shared ticket volume.
