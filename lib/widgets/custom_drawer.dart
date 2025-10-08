import 'package:flutter/material.dart';
import '../screens/profile_screen.dart';
import '../screens/friends_screen.dart';
import '../screens/about_screen.dart';
import '../screens/settings_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          MediaQuery.of(context).size.width * 2 / 3, // 2/3 der Bildschirmbreite
      child: Drawer(
        child: Container(
          color: const Color(0xFF3D405B), // Hintergrundfarbe des gesamten Menüs
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Elemente vertikal zentrieren
            children: [
              ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Color(0xFFE07A5F), // Icon-Farbe
                ),
                title: const Text(
                  'Profile', // Profil auf Englisch
                  style: TextStyle(
                    color: Color(0xFFE07A5F), // Schriftfarbe
                  ),
                ),
                onTap: () {
                  Navigator.pop(context); // Menü schließen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
              ),
              Divider(
                color: const Color(0xFF3D405B), // Trennstrich-Farbe
                thickness: 1, // Dicke des Trennstrichs
              ),
              ListTile(
                leading: const Icon(
                  Icons.group,
                  color: Color(0xFFE07A5F), // Icon-Farbe
                ),
                title: const Text(
                  'Friends', // Freunde auf Englisch
                  style: TextStyle(
                    color: Color(0xFFE07A5F), // Schriftfarbe
                  ),
                ),
                onTap: () {
                  Navigator.pop(context); // Menü schließen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FriendsScreen(),
                    ),
                  );
                },
              ),
              Divider(
                color: const Color(0xFF3D405B), // Trennstrich-Farbe
                thickness: 1, // Dicke des Trennstrichs
              ),
              ListTile(
                leading: const Icon(
                  Icons.info,
                  color: Color(0xFFE07A5F), // Icon-Farbe
                ),
                title: const Text(
                  'About', // Über auf Englisch
                  style: TextStyle(
                    color: Color(0xFFE07A5F), // Schriftfarbe
                  ),
                ),
                onTap: () {
                  Navigator.pop(context); // Menü schließen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ),
                  );
                },
              ),
              Divider(
                color: const Color(0xFF3D405B), // Trennstrich-Farbe
                thickness: 1, // Dicke des Trennstrichs
              ),
              ListTile(
                leading: const Icon(
                  Icons.settings,
                  color: Color(0xFFE07A5F), // Icon-Farbe
                ),
                title: const Text(
                  'Settings', // Einstellungen auf Englisch
                  style: TextStyle(
                    color: Color(0xFFE07A5F), // Schriftfarbe
                  ),
                ),
                onTap: () {
                  Navigator.pop(context); // Menü schließen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
