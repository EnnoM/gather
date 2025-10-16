import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/mock_firestore_service.dart';

class UserState extends ChangeNotifier {
  bool _isLoggedIn = false;
  AppUser? _currentUser;

  final MockFirestoreService _mockFirestoreService = MockFirestoreService();

  bool get isLoggedIn => _isLoggedIn;
  AppUser? get currentUser => _currentUser;

  Future<void> login(String uid) async {
    final user = await _mockFirestoreService.getUserById(uid);
    if (user != null) {
      _isLoggedIn = true;
      _currentUser = user;
      notifyListeners();
    }
  }

  void logout() {
    _isLoggedIn = false;
    _currentUser = null;
    notifyListeners();
  }
}
