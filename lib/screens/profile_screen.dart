import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/user_state.dart';
import '../widgets/custom_drawer.dart'; // Import des CustomDrawer-Widgets
import 'feed_screen.dart'; // Import der FeedScreen

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final userState = Provider.of<UserState>(context);
    final currentUser = userState.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'No user is logged in.',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      key: scaffoldKey,
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
              scaffoldKey.currentState?.openEndDrawer(); // Menü öffnen
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
            CircleAvatar(
              radius: 70,
              backgroundImage:
                  currentUser.profileImageUrl != null
                      ? NetworkImage(currentUser.profileImageUrl!)
                      : const AssetImage(
                            'assets/images/profile_placeholder.png',
                          )
                          as ImageProvider,
            ),
            const SizedBox(height: 30),

            // Vorname und Nachname
            Text(
              currentUser.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3D405B), // Schriftfarbe
              ),
            ),
            const SizedBox(height: 10),

            // Geburtsdatum (falls vorhanden)
            if (currentUser.bio != null)
              Text(
                currentUser.bio!,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF3D405B), // Schriftfarbe
                ),
              ),
            const SizedBox(height: 10),

            // Mailadresse
            Text(
              currentUser.email,
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF3D405B), // Schriftfarbe
              ),
            ),
            const SizedBox(height: 40),

            // Logout Button
            ElevatedButton(
              onPressed: () {
                // Logik für Logout
                Provider.of<UserState>(
                  context,
                  listen: false,
                ).logout(); // Benutzer ausloggen
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeedScreen(),
                  ), // Zurück zum FeedScreen
                  (route) => false, // Entfernt alle vorherigen Routen
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
