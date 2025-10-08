import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart'; // Import des CustomDrawer-Widgets
import 'feed_screen.dart'; // Import der FeedScreen

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color(0xFF81B29A), // Farbe wie die Überschrift
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const FeedScreen()),
              (route) => false, // Entfernt alle vorherigen Routen
            );
          },
        ),
        title: const Text(
          'P R O F I L E',
          style: TextStyle(
            color: Color(0xFF81B29A), // Farbe wie in FeedScreen
            fontFamily: 'Barlow', // Schriftart wie in FeedScreen
            fontWeight: FontWeight.bold, // Fett
          ),
        ),
        backgroundColor: Colors.transparent, // Transparenter Hintergrund
        elevation: 0, // Keine Schatten
        centerTitle: true, // Titel zentrieren
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            color: const Color(0xFF81B29A),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer(); // Menü öffnen
            },
          ),
        ],
      ),
      endDrawer: const CustomDrawer(), // Menü hinzufügen
      body: Center(
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Minimale Höhe, um Inhalte zu zentrieren
          crossAxisAlignment:
              CrossAxisAlignment.center, // Horizontal zentrieren
          children: [
            // Profilbild
            const CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage(
                'assets/images/profile_placeholder.png',
              ), // Beispielbild
            ),
            const SizedBox(height: 30),

            // Vorname und Nachname
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3D405B), // Schriftfarbe
              ),
            ),
            const SizedBox(height: 10),

            // Geburtsdatum
            const Text(
              '01/01/1990',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF3D405B), // Schriftfarbe
              ),
            ),
            const SizedBox(height: 10),

            // Mailadresse
            const Text(
              'john.doe@example.com',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF3D405B), // Schriftfarbe
              ),
            ),
            const SizedBox(height: 40),

            // Logout Button
            ElevatedButton(
              onPressed: () {
                // Logik für Logout
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const FeedScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE07A5F), // Farbe des Buttons
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D405B), // Schriftfarbe des Buttons
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(
        0xFFF4F1DE,
      ), // Hintergrundfarbe wie in FeedScreen
    );
  }
}
