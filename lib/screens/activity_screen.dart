import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../widgets/custom_drawer.dart'; // Import des CustomDrawer-Widgets
import 'feed_screen.dart'; // Import der FeedScreen

class ActivityScreen extends StatelessWidget {
  final Activity activity;

  const ActivityScreen({Key? key, required this.activity}) : super(key: key);

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
          'A C T I V I T Y',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activity.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF81B29A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              activity.description,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Text(
              'Category: ${activity.category}',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              'Location: ${activity.location?.latitude ?? 'N/A'}, ${activity.location?.longitude ?? 'N/A'}',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              'Start Time: ${activity.startTime.toDate()}',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Text(
              'Participants: ${activity.participants.join(', ')}',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(
        0xFFF4F1DE, // Hintergrundfarbe wie in FeedScreen
      ),
    );
  }
}
