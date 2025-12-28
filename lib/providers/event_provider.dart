import 'package:flutter/foundation.dart';
import '../models/event.dart';
import '../services/event_service.dart';

class EventProvider with ChangeNotifier {
  final EventService _eventService = EventService();
  List<Event> _events = [];
  bool _isLoading = false;
  String? _error;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchEvents(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _events = await _eventService.getEvents(token);
    } catch (e) {
      _error = e.toString();
      _events = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> registerForEvent(String eventId, String token) async {
    try {
      await _eventService.registerForEvent(eventId, token);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addReview(String eventId, int rating, String comment, String token) async {
    try {
      await _eventService.addReview(eventId, rating, comment, token);
    } catch (e) {
      rethrow;
    }
  }
}
