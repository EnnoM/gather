import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/user_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Automatischer Login für Entwicklungszwecke
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<UserState>(context, listen: false).login('user1');
      Navigator.pushReplacementNamed(context, '/activity');
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF4F1DE), // Hintergrundfarbe
      appBar: AppBar(
        backgroundColor: const Color(
          0xFFF4F1DE,
        ), // Gleiche Farbe wie der Hintergrund
        elevation: 0, // Entfernt den Schatten
        centerTitle: true,
        title: RichText(
          text: const TextSpan(
            text: 'W ',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Color(0xFFE07A5F), // Farbe für "W"
            ),
            children: [
              TextSpan(
                text: 'E ',
                style: TextStyle(color: Color(0xFF3D405B)), // Farbe für "E"
              ),
              TextSpan(
                text: 'L ',
                style: TextStyle(color: Color(0xFF81B29A)), // Farbe für "L"
              ),
              TextSpan(
                text: 'C ',
                style: TextStyle(color: Color(0xFFF2CC8F)), // Farbe für "C"
              ),
              TextSpan(
                text: 'O ',
                style: TextStyle(color: Color(0xFFE07A5F)), // Farbe für "O"
              ),
              TextSpan(
                text: 'M ',
                style: TextStyle(color: Color(0xFF3D405B)), // Farbe für "M"
              ),
              TextSpan(
                text: 'E',
                style: TextStyle(color: Color(0xFF81B29A)), // Farbe für "E"
              ),
            ],
          ),
        ),
      ),
      body: const Center(
        child: CircularProgressIndicator(), // Ladeanzeige während des Logins
      ),
    );
  }
}
