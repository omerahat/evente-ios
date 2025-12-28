# Evente - Event Discovery App

A Flutter mobile application for discovering, registering for, and reviewing events. Built with Material Design 3 and connects to a .NET backend API.

## Features

- **User Authentication** - Login and registration with JWT token-based auth
- **Event Discovery** - Browse and explore available events
- **Event Registration** - Register for events you're interested in
- **Reviews & Ratings** - Rate and review events you've attended

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.10.0 or higher)
- [Xcode](https://developer.apple.com/xcode/) (for iOS development)
- [Android Studio](https://developer.android.com/studio) (for Android development)
- Backend API running at `http://localhost:5200`

## Getting Started

### 1. Clone the repository

```bash
git clone <repository-url>
cd evente-ios
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. iOS Setup (first time only)

```bash
cd ios
pod install
cd ..
```

### 4. Run the app

```bash
# List available devices
flutter devices

# Run on default device
flutter run

# Run on specific device
flutter run -d <device-id>
```

## Project Structure

```
lib/
├── core/
│   └── api_constants.dart    # API base URL and endpoints
├── models/
│   ├── category.dart         # Category model
│   ├── event.dart            # Event model
│   └── user.dart             # User model
├── providers/
│   ├── auth_provider.dart    # Authentication state management
│   └── event_provider.dart   # Event state management
├── screens/
│   ├── event_detail_screen.dart
│   ├── event_list_screen.dart
│   └── login_screen.dart
├── services/
│   ├── auth_service.dart     # Auth API calls
│   └── event_service.dart    # Event API calls
├── widgets/                   # Reusable widgets
└── main.dart                  # App entry point
```

## API Endpoints

The app connects to the following API endpoints:

| Feature | Method | Endpoint |
|---------|--------|----------|
| Login | POST | `/api/Auth/Login` |
| Register | POST | `/api/Auth/Register` |
| Get Events | GET | `/api/Events` |
| Register for Event | POST | `/api/Registrations/{eventId}` |
| Add Review | POST | `/api/Reviews` |

## Configuration

### API Base URL

The API URL is configured in `lib/core/api_constants.dart`:

- **Web**: `http://localhost:5200`
- **iOS Simulator**: `http://localhost:5200`
- **Android Emulator**: `http://10.0.2.2:5200`
- **Physical Device**: Update to your machine's IP address (e.g., `http://192.168.1.100:5200`)

## Dependencies

| Package | Purpose |
|---------|---------|
| `dio` | HTTP client for API calls |
| `provider` | State management |
| `flutter_secure_storage` | Secure token storage |
| `google_fonts` | Custom typography |

## Development

### Hot Reload
While the app is running, press `r` in the terminal for hot reload or `R` for a full restart.

### Generate App Icons
```bash
flutter pub run flutter_launcher_icons
```

### Generate Splash Screen
```bash
flutter pub run flutter_native_splash:create
```

## License

This project is private and not published to pub.dev.
