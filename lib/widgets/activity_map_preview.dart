import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart'; // Für die Datums- und Zeitformatierung
import '../models/activity.dart';
import '../models/user.dart'; // Importiere das AppUser-Modell
import '../services/mock_firestore_service.dart'; // Importiere den MockFirestoreService
import '../screens/activity_screen.dart'; // Importiere den ActivityScreen

class ActivityMapPreview extends StatelessWidget {
  final List<Activity> activities;

  const ActivityMapPreview({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    final MockFirestoreService mockFirestoreService = MockFirestoreService();

    return FutureBuilder<List<AppUser>>(
      future: mockFirestoreService.getUsers(), // Benutzerliste laden
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Fehler beim Laden der Benutzer'));
        }

        final users = snapshot.data ?? [];

        return FlutterMap(
          options: MapOptions(
            center: LatLng(51.1657, 10.4515), // Zentrum: Deutschland
            zoom: 5.0,
            onTap: (_, __) {
              // Schließt das Popup, wenn man auf die Karte klickt
              Navigator.of(context).pop();
            },
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers:
                  activities.map((activity) {
                    return Marker(
                      point: LatLng(
                        activity.location?.latitude ?? 0.0,
                        activity.location?.longitude ?? 0.0,
                      ),
                      builder:
                          (ctx) => GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // Formatierung von Datum und Uhrzeit
                                  final DateTime dateTime =
                                      activity.startTime.toDate();
                                  final String formattedTime = DateFormat(
                                    'HH:mm',
                                  ).format(dateTime);
                                  final String formattedDate = DateFormat(
                                    'dd.MM.yyyy',
                                  ).format(dateTime);

                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    backgroundColor: const Color(0xFFF4F1DE),
                                    title: Center(
                                      child: Text(
                                        activity.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF3D405B),
                                        ),
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Category:',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF3D405B),
                                          ),
                                        ),
                                        Text(
                                          activity.category,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF3D405B),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Time:',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF3D405B),
                                          ),
                                        ),
                                        Text(
                                          formattedTime,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF3D405B),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Date:',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF3D405B),
                                          ),
                                        ),
                                        Text(
                                          formattedDate,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF3D405B),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Location:',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF3D405B),
                                          ),
                                        ),
                                        Text(
                                          '${activity.location?.latitude ?? 'N/A'}, ${activity.location?.longitude ?? 'N/A'}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF3D405B),
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF81B29A,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            ),
                                            onPressed: () {
                                              // Schließt das Popup und navigiert zum ActivityScreen
                                              Navigator.of(context).pop();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (
                                                        context,
                                                      ) => ActivityScreen(
                                                        activity: activity,
                                                        users:
                                                            users, // Benutzerliste übergeben
                                                      ),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              'Details',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF3D405B),
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFFE07A5F,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(
                                                context,
                                              ).pop(); // Popup schließen
                                            },
                                            child: const Text(
                                              'No Thanks',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Icon(
                              Icons.location_pin,
                              color: Color(0xFFE07A5F),
                              size: 30,
                            ),
                          ),
                    );
                  }).toList(),
            ),
          ],
        );
      },
    );
  }
}
