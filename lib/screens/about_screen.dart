import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart'; // Import des CustomDrawer-Widgets
import 'feed_screen.dart'; // Import der FeedScreen

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
          'A B O U T',
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
        child: RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: TextStyle(
              fontSize: 48, // Große Schriftgröße
              fontFamily: 'Barlow', // Schriftart wie in FeedScreen
              fontWeight: FontWeight.bold, // Fett
            ),
            children: [
              TextSpan(
                text: 'FUCK ',
                style: TextStyle(color: Color(0xFFE07A5F)), // Erste Farbe
              ),
              TextSpan(
                text: 'A',
                style: TextStyle(color: Color(0xFF3D405B)), // Zweite Farbe
              ),
              TextSpan(
                text: 'F',
                style: TextStyle(color: Color(0xFF81B29A)), // Dritte Farbe
              ),
              TextSpan(
                text: 'D',
                style: TextStyle(color: Color(0xFFF2CC8F)), // Vierte Farbe
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(
        0xFFF4F1DE,
      ), // Hintergrundfarbe wie in FeedScreen
    );
  }
}
