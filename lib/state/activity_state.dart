import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../services/mock_firestore_service.dart'; // Mock-Service importieren

class ActivityState extends ChangeNotifier {
  final MockFirestoreService _mockService = MockFirestoreService();
  List<Activity> _activities = [];

  List<Activity> get activities => _activities;

  /// Lädt Aktivitäten aus dem Mock-Service und benachrichtigt die UI.
  Future<void> loadActivities() async {
    _activities = await _mockService.getActivities();
    notifyListeners();
  }
}
