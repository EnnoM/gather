import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool isListView = true; // Zustand für die Ansicht (Liste oder Karte)

  // Beispiel-Aktivitäten mit Geokoordinaten
  final List<Map<String, dynamic>> activities = [
    {
      "name": "Wandern im Park",
      "latitude": 48.1351,
      "longitude": 11.5820,
    }, // München
    {
      "name": "Kaffeetrinken",
      "latitude": 52.5200,
      "longitude": 13.4050,
    }, // Berlin
    {"name": "Kinoabend", "latitude": 50.9375, "longitude": 6.9603}, // Köln
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '2 G A T H E R',
          style: TextStyle(
            color: Color(0xFFE07A5F), // Farbe: E07A5F
            fontFamily: 'Barlow', // Schriftart: Barlow
            fontWeight: FontWeight.bold, // Fett
          ),
        ),
        backgroundColor: Colors.transparent, // Transparenter Hintergrund
        elevation: 0, // Keine Schatten
        centerTitle: true, // Titel zentrieren
      ),
      body: Column(
        children: [
          // Menüleiste unter der Überschrift
          Container(
            height: kToolbarHeight, // Höhe wie die Überschrift
            child: Row(
              children: [
                // Linker Bereich: Liste
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isListView = true; // Zur Listenansicht wechseln
                      });
                    },
                    child: Container(
                      color:
                          isListView
                              ? const Color(0xFFE07A5F) // Aktive Farbe
                              : Colors.transparent, // Inaktive Farbe
                      child: const Center(
                        child: Text(
                          '📋', // Emoji für Liste
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                ),
                // Rechter Bereich: Karte
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isListView = false; // Zur Kartenansicht wechseln
                      });
                    },
                    child: Container(
                      color:
                          !isListView
                              ? const Color(0xFFE07A5F) // Aktive Farbe
                              : Colors.transparent, // Inaktive Farbe
                      child: const Center(
                        child: Text(
                          '🌍', // Emoji für Karte
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Hauptinhalt
          Expanded(
            child:
                isListView
                    ? ListView.builder(
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        final activity = activities[index];
                        return ListTile(
                          title: Text(activity["name"]),
                          subtitle: Text(
                            "Lat: ${activity["latitude"]}, Lon: ${activity["longitude"]}",
                          ),
                        );
                      },
                    )
                    : FlutterMap(
                      options: MapOptions(
                        center: LatLng(
                          51.1657,
                          10.4515,
                        ), // Zentrum: Deutschland
                        zoom: 5.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers:
                              activities.map((activity) {
                                return Marker(
                                  point: LatLng(
                                    activity["latitude"],
                                    activity["longitude"],
                                  ),
                                  builder:
                                      (ctx) => const Icon(
                                        Icons.location_pin,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                );
                              }).toList(),
                        ),
                      ],
                    ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF4F1DE), // Hintergrundfarbe der App
    );
  }
}
