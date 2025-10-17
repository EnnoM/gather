import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../models/user.dart';
import '../screens/activity_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityListCard extends StatelessWidget {
  final Activity activity;
  final List<AppUser> users;

  const ActivityListCard({
    super.key,
    required this.activity,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    // Veranstalter anhand der ownerId finden
    final organizer = users.firstWhere(
      (user) => user.uid == activity.ownerId,
      orElse:
          () => AppUser(
            uid: 'unknown',
            name: 'Unknown Organizer',
            email: '',
            profileImageUrl: null,
            bio: null,
            friends: [],
            createdAt: Timestamp.now(),
          ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16, // Gleicher Abstand links und rechts
        vertical: 8, // Gleicher Abstand oben und unten
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F1DE),
        borderRadius: BorderRadius.circular(16), // Alle Ecken abrunden
      ),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Obere Zeile bleibt gleich
            Row(
              children: [
                // Titel der Veranstaltung
                Expanded(
                  child: Text(
                    activity.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3D405B),
                    ),
                    overflow: TextOverflow.ellipsis, // Text abschneiden
                  ),
                ),
                const SizedBox(
                  width: 8,
                ), // Abstand zwischen Titel und Profilbild
                // Profilbild des Veranstalters
                CircleAvatar(
                  radius: 12, // Kleinere Größe für die Host-Info
                  backgroundImage:
                      organizer.profileImageUrl != null
                          ? NetworkImage(organizer.profileImageUrl!)
                          : null,
                  child:
                      organizer.profileImageUrl == null
                          ? const Icon(Icons.person, size: 12)
                          : null,
                ),
                const SizedBox(
                  width: 8,
                ), // Abstand zwischen Profilbild und Name
                // Name des Veranstalters
                Text(
                  organizer.name,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF3D405B),
                  ),
                  overflow: TextOverflow.ellipsis, // Text abschneiden
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ), // Abstand zwischen erster und zweiter Zeile
            // Bereich für die 4 Elemente (2 Hälften)
            Row(
              children: [
                // Linke Hälfte: Datum und Zeit
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTableCell('📅', '${activity.date}'), // Datum
                      const SizedBox(height: 8), // Abstand zwischen den Zeilen
                      _buildTableCell('⏰', '${activity.time}'), // Zeit
                    ],
                  ),
                ),
                // Rechte Hälfte: Ort und Kategorie
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTableCell(
                        '📍',
                        '${activity.road} ${activity.houseNumber}', // Straße, Hausnummer, PLZ
                      ),
                      const SizedBox(height: 8), // Abstand zwischen den Zeilen
                      _buildTableCell(
                        '🏷️',
                        '${activity.category}',
                      ), // Kategorie
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          // Navigation zum ActivityScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ActivityScreen(
                    activity: activity,
                    users: users, // Übergabe der Benutzerliste
                  ),
            ),
          );
        },
      ),
    );
  }

  /// Hilfsfunktion zum Erstellen einer Tabellenzelle mit Emoji und Text.
  Widget _buildTableCell(String emoji, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Text und Emoji ausrichten
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 16), // Emoji-Stil
        ),
        const SizedBox(width: 8), // Abstand zwischen Emoji und Text
        Flexible(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Color(0xFF3D405B)),
            overflow: TextOverflow.ellipsis, // Text abschneiden
            textAlign: TextAlign.left, // Links ausrichten
          ),
        ),
      ],
    );
  }
}
