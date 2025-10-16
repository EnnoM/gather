import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/user_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Username TextField
              TextField(
                controller: usernameController,
                style: const TextStyle(
                  color: Color(0xFF3D405B), // Schriftfarbe im Feld
                ),
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: const TextStyle(
                    color: Color(0xFF3D405B), // Label-Farbe
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF3D405B), // Rahmenfarbe beim Fokussieren
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF3D405B), // Standard-Rahmenfarbe
                    ),
                    borderRadius: BorderRadius.circular(
                      16,
                    ), // Abgerundete Ecken
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Password TextField
              TextField(
                controller: passwordController,
                obscureText: true,
                style: const TextStyle(
                  color: Color(0xFF3D405B), // Schriftfarbe im Feld
                ),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(
                    color: Color(0xFF3D405B), // Label-Farbe
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF3D405B), // Rahmenfarbe beim Fokussieren
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF3D405B), // Standard-Rahmenfarbe
                    ),
                    borderRadius: BorderRadius.circular(
                      16,
                    ), // Abgerundete Ecken
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Login Button
              ElevatedButton(
                onPressed: () {
                  // Simuliere Login-Logik
                  final username = usernameController.text;
                  final password = passwordController.text;

                  if (username.isNotEmpty && password.isNotEmpty) {
                    Provider.of<UserState>(
                      context,
                      listen: false,
                    ).login(username);
                    Navigator.pushReplacementNamed(context, '/activity');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: const Color(
                          0xFFE07A5F,
                        ), // Hintergrundfarbe
                        content: const Text(
                          'Please fill in all fields', // Englischer Text
                          textAlign: TextAlign.center, // Text zentrieren
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold, // Fettgedruckte Schrift
                            color: Colors.white, // Schriftfarbe
                          ),
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(
                    50,
                  ), // Gleiche Breite wie TextField
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      16,
                    ), // Abgerundete Ecken
                  ),
                  backgroundColor: const Color(0xFF81B29A), // Farbe des Buttons
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Fettgedruckte Schrift
                    color: Color(0xFF3D405B), // Textfarbe
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Register Button
              ElevatedButton(
                onPressed: () {
                  // Simuliere Registrierung (kann später erweitert werden)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: const Color(
                        0xFFE07A5F,
                      ), // Hintergrundfarbe
                      content: const Text(
                        'Registration not implemented', // Englischer Text
                        textAlign: TextAlign.center, // Text zentrieren
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // Fettgedruckte Schrift
                          color: Colors.white, // Schriftfarbe
                        ),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(
                    50,
                  ), // Gleiche Breite wie TextField
                  backgroundColor: const Color(0xFFF2CC8F), // Farbe des Buttons
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      16,
                    ), // Abgerundete Ecken
                  ),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Fettgedruckte Schrift
                    color: Color(0xFF3D405B), // Textfarbe
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
