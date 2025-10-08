import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart'; // Import des CustomDrawer-Widgets
import 'feed_screen.dart'; // Import der FeedScreen

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({Key? key}) : super(key: key);

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
          'F R I E N D S',
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
      body: const Center(child: Text('This is the Friends Page')),
      backgroundColor: const Color(
        0xFFF4F1DE,
      ), // Hintergrundfarbe wie in FeedScreen
    );
  }
}
