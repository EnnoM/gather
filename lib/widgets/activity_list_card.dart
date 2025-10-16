import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../models/user.dart';
import '../screens/activity_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityListCard extends StatelessWidget {
  final Activity activity;
  final List<AppUser> users;

  const ActivityListCard({
    Key? key,
    required this.activity,
    required this.users,
  }) : super(key: key);

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
        color: const Color(0xFF81B29A),
        borderRadius: BorderRadius.circular(16), // Alle Ecken abrunden
      ),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              height: 4,
            ), // Abstand zwischen erster und zweiter Zeile
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Gleichmäßige Verteilung
              children: [
                // Datum und Zeit
                Expanded(
                  child: Text(
                    '${activity.date}, ${activity.time}', // Datum und Zeit kombiniert
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF3D405B),
                    ),
                  ),
                ),
                // Adresse
                Expanded(
                  child: Text(
                    activity.address,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF3D405B),
                    ),
                    overflow: TextOverflow.ellipsis, // Text abschneiden
                  ),
                ),
                // Kategorie
                Expanded(
                  child: Text(
                    activity.category,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF3D405B),
                    ),
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
}
