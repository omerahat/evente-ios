import 'package:flutter/foundation.dart';
import '../models/event.dart';
import '../models/category.dart' as models;
import '../services/event_service.dart';
import '../services/category_service.dart';

class EventProvider with ChangeNotifier {
  final EventService _eventService = EventService();
  final CategoryService _categoryService = CategoryService();
  List<Event> _events = [];
  List<models.Category> _categories = [];
  bool _isLoading = false;
  String? _error;
  int? _selectedCategoryId;

  List<Event> get events => _events;
  List<models.Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int? get selectedCategoryId => _selectedCategoryId;

  Future<void> fetchCategories(String token) async {
    try {
      _categories = await _categoryService.getCategories(token);
      notifyListeners();
    } catch (e) {
      // Silently fail category fetch - not critical
      _categories = [];
    }
  }

  Future<void> fetchEvents(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (_selectedCategoryId != null) {
        _events = await _eventService.getEventsByCategory(
          _selectedCategoryId!,
          token,
        );
      } else {
        _events = await _eventService.getEvents(token);
      }
    } catch (e) {
      _error = e.toString();
      _events = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedCategory(int? categoryId, String token) {
    _selectedCategoryId = categoryId;
    notifyListeners();
    fetchEvents(token);
  }

  void clearFilter(String token) {
    _selectedCategoryId = null;
    notifyListeners();
    fetchEvents(token);
  }

  Future<void> registerForEvent(String eventId, String token) async {
    try {
      await _eventService.registerForEvent(eventId, token);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addReview(
    String eventId,
    int rating,
    String comment,
    String token,
  ) async {
    try {
      await _eventService.addReview(eventId, rating, comment, token);
    } catch (e) {
      rethrow;
    }
  }
}
