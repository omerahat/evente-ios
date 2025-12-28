# EventeApi Mobile Client Development Plan

This document outlines the development phases for the EventeApi mobile client.

## Phase 1: Setup & Core Structure
- [ ] Configure `pubspec.yaml` (dependencies: dio, provider, flutter_secure_storage, google_fonts).
- [ ] Setup folder structure (core, models, services, providers, screens, widgets).
- [ ] Define `ApiConstants` handling `localhost` for iOS and `10.0.2.2` for Android Emulator.

## Phase 2: Auth & Static UI
- [ ] Create `LoginScreen` logic.
- [ ] Implement `AuthService` (Login/Register) & `AuthProvider`.
- [ ] Securely store the JWT Token.

## Phase 3: Events & Networking
- [ ] Create Data Models (`Event`, `Category`, `User`) matching the API JSON.
- [ ] Implement `EventService` using Dio.
- [ ] Create `EventListScreen` (Home) with pull-to-refresh.

## Phase 4: Interaction & Details
- [ ] Create `EventDetailScreen`.
- [ ] Implement "Register for Event" functionality.
- [ ] Implement "Add Review/Rating" functionality (POST request).

## Phase 5: UX Improvements
- [ ] Add Loading States (Spinners) and Error Dialogs.
- [ ] Improve UI Styling (Colors, Fonts, Spacing).

## Phase 6: Final Polish
- [ ] Prepare App Icon and Splash Screen.


