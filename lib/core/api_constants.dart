import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConstants {
  // Base URL logic
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5200'; // Updated port
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5200'; // Updated port
    }
    // iOS Simulator / Localhost
    return 'http://localhost:5200'; // Updated port
  }

  // Auth Endpoints
  static const String login = '/api/Auth/Login';
  static const String register = '/api/Auth/Register';

  // Event Endpoints
  static const String events = '/api/Events';

  // Category Endpoints
  static const String categories = '/api/Categories';

  // Registration Endpoints
  static const String registrations = '/api/Registrations';

  // Review Endpoints
  static const String reviews = '/api/Reviews';
}
