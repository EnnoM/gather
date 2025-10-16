import 'package:flutter/material.dart';

class UserState extends ChangeNotifier {
  bool _isLoggedIn = false; // Login-Status
  String? _userId; // ID des eingeloggten Benutzers

  // Getter für den Login-Status
  bool get isLoggedIn => _isLoggedIn;

  // Getter für die Benutzer-ID
  String? get userId => _userId;

  // Methode zum Einloggen
  void login(String userId) {
    _isLoggedIn = true;
    _userId = userId;
    notifyListeners(); // Benachrichtigt alle Widgets über Änderungen
  }

  // Methode zum Ausloggen
  void logout() {
    _isLoggedIn = false;
    _userId = null;
    notifyListeners(); // Benachrichtigt alle Widgets über Änderungen
  }
}
