import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart'; // Für die Datums- und Zeitformatierung
import '../models/activity.dart';
import '../screens/activity_screen.dart'; // Import the ActivityScreen widget

class ActivityMapPreview extends StatelessWidget {
  final List<Activity> activities;

  const ActivityMapPreview({Key? key, required this.activities})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                                backgroundColor: const Color(
                                  0xFFF4F1DE,
                                ), // Hintergrundfarbe
                                title: Center(
                                  child: Text(
                                    activity.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF3D405B), // Schriftfarbe
                                    ),
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Category:',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold, // Fett
                                        color: Color(
                                          0xFF3D405B,
                                        ), // Schriftfarbe
                                      ),
                                    ),
                                    Text(
                                      activity.category,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(
                                          0xFF3D405B,
                                        ), // Schriftfarbe
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Time:',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold, // Fett
                                        color: Color(
                                          0xFF3D405B,
                                        ), // Schriftfarbe
                                      ),
                                    ),
                                    Text(
                                      formattedTime,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(
                                          0xFF3D405B,
                                        ), // Schriftfarbe
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Date:',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold, // Fett
                                        color: Color(
                                          0xFF3D405B,
                                        ), // Schriftfarbe
                                      ),
                                    ),
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(
                                          0xFF3D405B,
                                        ), // Schriftfarbe
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Location:',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold, // Fett
                                        color: Color(
                                          0xFF3D405B,
                                        ), // Schriftfarbe
                                      ),
                                    ),
                                    Text(
                                      '${activity.location?.latitude ?? 'N/A'}, ${activity.location?.longitude ?? 'N/A'}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(
                                          0xFF3D405B,
                                        ), // Schriftfarbe
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
                                          ), // Hintergrundfarbe
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          // Leitet zur Aktivitätenkarte weiter
                                          Navigator.of(
                                            context,
                                          ).pop(); // Schließt das Popup
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => ActivityScreen(
                                                    activity: activity,
                                                  ), // Beispiel: ActivityScreen
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'details',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold, // Fett
                                            color: Color(
                                              0xFF3D405B,
                                            ), // Schriftfarbe
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFFE07A5F,
                                          ), // Hintergrundfarbe
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          // Leitet zur Aktivitätenkarte weiter
                                          Navigator.of(
                                            context,
                                          ).pop(); // Schließt das Popup
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => ActivityScreen(
                                                    activity: activity,
                                                  ), // Beispiel: ActivityScreen
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'no thanks',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold, // Fett
                                            color: Colors.white, // Schriftfarbe
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
                          color: Color(0xFFE07A5F), // Farbe der Pings geändert
                          size: 30,
                        ),
                      ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
