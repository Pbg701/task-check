# Offline Task & Check-in App

**Production-ready Flutter offline-first app with GetX, Firebase Auth, Hive, and Clean Architecture**

---

## Project Overview

A robust, offline-first mobile app for task management and geolocated check-ins, supporting Admin and Member roles. Works seamlessly offline with auto-sync and conflict resolution upon connectivity. Built using Flutter, GetX, Firebase Authentication, Hive, and more.

---

## Architecture

- Strict [Clean Architecture](https://github.com/betterprogramming/clean-architecture-flutter) with clear separation:
  - `core/`, `data/`, `domain/`, and `presentation/` layers
  - Unidirectional data flow
  - GetX for state-management, DI, navigation
- Offline-first (Hive DB cache)
- Role-based access (Admin/Member)

---

## Offline-First Strategy

- Tasks and check-ins cached locally via Hive
- All CRUD works offline — local records marked as `pending`, `synced`, or `failed`
- Auto re-syncs when online (with network awareness)
- Check-ins: conflicts always resolved by **Client Wins**

---

## Sync Logic & Conflict Policy

- **Sync Statuses**: Each task/check-in carries `syncStatus` (pending/synced/failed)
- Check-ins: conflicting updates always keep latest client data
- Failed syncs retry automatically in background
- Robust error/status UI notifications

---

## Firebase Setup Steps

1. Create Firebase project
2. Enable Auth (Email/Password & Google optional)
3. Enable Firestore database
4. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) and place in respective platforms/
5. Add web API key if needed
6. Add Firestore `users` collection with `role` fields
7. Setup Firebase in Flutter (see `/core/services/init_service.dart`)

---

## How to Run

```bash
flutter pub get
flutter run
```
1. Ensure Hive/box adapters are registered (see code)
2. Provide Firebase configuration files (see above)
3. App boots to Splash → Login (Firebase)

---

## Demo Evidence (placeholder)

- [ ] GIFs/video/screenshots
- [ ] Description of core flows (offline check-in, admin task ops, etc)

---

## Dependencies

- Flutter (latest stable)
- GetX
- Firebase Auth, Firestore
- Hive, hive_flutter
- connectivity_plus
- geolocator
- intl

---

## Maintainers
- TODO: Add authors
