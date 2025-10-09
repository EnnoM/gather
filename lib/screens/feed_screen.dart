import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/activity_state.dart';
import '../widgets/activity_map_preview.dart';
import '../widgets/custom_drawer.dart';
import 'activity_screen.dart';
import '../models/activity.dart';
import '../models/user.dart';
import '../services/mock_firestore_service.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isListView = true;
  bool isExpanded = false; // Zustand für das erweiterte Menü

  final MockFirestoreService mockFirestoreService = MockFirestoreService();
  late Future<List<AppUser>> usersFuture;

  @override
  void initState() {
    super.initState();
    // Benutzerliste laden
    usersFuture = mockFirestoreService.getUsers();
    // Aktivitäten laden
    Provider.of<ActivityState>(context, listen: false).loadActivities();
  }

  @override
  Widget build(BuildContext context) {
    final activities = Provider.of<ActivityState>(context).activities;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          '2 G A T H E R',
          style: TextStyle(
            color: Color(0xFF81B29A),
            fontFamily: 'Barlow',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            color: Color(0xFF81B29A),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: const CustomDrawer(),
      body: GestureDetector(
        onTap: () {
          // Klappt das Menü ein, wenn irgendwo anders geklickt wird
          if (isExpanded) {
            setState(() {
              isExpanded = false;
            });
          }
        },
        child: Stack(
          children: [
            Column(
              children: [
                // Menüleiste
                Container(
                  height: kToolbarHeight,
                  margin: const EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    8,
                  ), // Gleicher Abstand wie Aktivitäten
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isListView = true;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  isListView
                                      ? const Color(0xFF81B29A)
                                      : Colors.transparent,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(16), // Alle Ecken abrunden
                              ),
                            ),
                            child: const Center(
                              child: Text('📋', style: TextStyle(fontSize: 24)),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isListView = false;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  !isListView
                                      ? const Color(0xFF81B29A)
                                      : Colors.transparent,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(16), // Alle Ecken abrunden
                              ),
                            ),
                            child: const Center(
                              child: Text('🌍', style: TextStyle(fontSize: 24)),
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
                          ? FutureBuilder<List<AppUser>>(
                            future: usersFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (snapshot.hasError) {
                                return const Center(
                                  child: Text('Fehler beim Laden der Benutzer'),
                                );
                              }

                              final users = snapshot.data ?? [];

                              return ListView.builder(
                                itemCount: activities.length,
                                itemBuilder: (context, index) {
                                  final activity = activities[index];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal:
                                          16, // Gleicher Abstand links und rechts
                                      vertical:
                                          8, // Gleicher Abstand oben und unten
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF81B29A),
                                      borderRadius: BorderRadius.circular(
                                        16,
                                      ), // Alle Ecken abrunden
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        activity.title,
                                        style: const TextStyle(
                                          color: Color(
                                            0xFF3D405B,
                                          ), // Schriftfarbe
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "Lat: ${activity.location?.latitude ?? 'N/A'}, Lon: ${activity.location?.longitude ?? 'N/A'}",
                                        style: const TextStyle(
                                          color: Color(
                                            0xFF3D405B,
                                          ), // Schriftfarbe
                                        ),
                                      ),
                                      onTap: () {
                                        // Navigation zum ActivityScreen
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => ActivityScreen(
                                                  activity: activity,
                                                  users:
                                                      users, // Übergabe der Benutzerliste
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          )
                          : Container(
                            margin: const EdgeInsets.fromLTRB(
                              16,
                              8, // Gleicher Abstand wie Aktivitäten oben
                              16,
                              16, // Abstand unten
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white, // Hintergrundfarbe der Karte
                              borderRadius: BorderRadius.circular(
                                16,
                              ), // Alle Ecken abrunden
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4), // Schatten
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                16,
                              ), // Ecken der Karte abrunden
                              child: ActivityMapPreview(activities: activities),
                            ),
                          ),
                ),
              ],
            ),
            // Button unten links, der sich bei Klick über den gesamten Bildschirm erweitert
            Positioned(
              bottom: 16,
              left: isExpanded ? 16 : 16, // Immer unten links
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded; // Menü ein-/ausklappen
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 300,
                  ), // Animation für Übergang
                  curve: Curves.easeInOut, // Sanfte Animation
                  width:
                      isExpanded
                          ? MediaQuery.of(context).size.width -
                              32 // Über gesamte Breite
                          : 80, // Eingeklappt
                  height: 80, // Höhe bleibt gleich
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Durchsichtig
                    border: Border.all(
                      color: const Color(0xFFE07A5F), // Umrandung in Rot
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(
                      40,
                    ), // Ecken bleiben rund
                  ),
                  child:
                      isExpanded
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    // Logik für "Add"
                                    print("Add clicked");
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                          color: Color(
                                            0xFFE07A5F,
                                          ), // Trennlinie in Rot
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      "Add",
                                      style: TextStyle(
                                        color: Color(
                                          0xFFE07A5F,
                                        ), // Schriftfarbe in Rot
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    // Logik für "MyActivities"
                                    print("MyActivities clicked");
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "MyActivities",
                                      style: TextStyle(
                                        color: Color(
                                          0xFFE07A5F,
                                        ), // Schriftfarbe in Rot
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                          : const Center(
                            child: Text(
                              "Activity",
                              style: TextStyle(
                                color: Color(0xFFE07A5F), // Schriftfarbe in Rot
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF3D405B), // Hintergrundfarbe
    );
  }
}
