import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/activity_state.dart';
import '../state/user_state.dart';
import '../widgets/activity_map_preview.dart';
import '../widgets/custom_drawer.dart';
import '../models/user.dart';
import '../services/mock_firestore_service.dart';
import '../widgets/activity_list_card.dart';
import 'add_activity.dart'; // Korrigierter Import

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
    final userState = Provider.of<UserState>(context);
    final activities = Provider.of<ActivityState>(context).activities;

    if (!userState.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const SizedBox.shrink(); // Leerer Platzhalter
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          '2 G A T H E R',
          style: TextStyle(
            color: Color(0xFFF4F1DE),
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
            color: Color(0xFFF4F1DE),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: const CustomDrawer(),
      body: Stack(
        children: [
          Column(
            children: [
              // Menüleiste
              Container(
                height: kToolbarHeight,
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
                                    ? const Color(0xFFF4F1DE)
                                    : Colors.transparent,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(16),
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
                                    ? const Color(0xFFF4F1DE)
                                    : Colors.transparent,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(16),
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
              // Grüne Bar mit mittigem Trennstrich
              Container(
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F1DE),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${activities.length} ',
                                style: const TextStyle(
                                  color: Color(0xFFE07A5F),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const TextSpan(
                                text: 'activities nearby',
                                style: TextStyle(
                                  color: Color(0xFF3D405B),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(width: 2, color: const Color(0xFF3D405B)),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          print("Filter icon tapped");
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.filter_alt,
                            color: Color(0xFF3D405B),
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
                                return ActivityListCard(
                                  activity: activity,
                                  users: users,
                                );
                              },
                            );
                          },
                        )
                        : Container(
                          margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: ActivityMapPreview(activities: activities),
                          ),
                        ),
              ),
            ],
          ),
          // Activity-Bar immer unten
          Positioned(
            bottom:
                MediaQuery.of(context).size.height *
                0.015, // Leicht nach oben verschoben (2-3%)
            left: 16, // Gleicher Abstand wie vorher
            right: 16, // Gleicher Abstand wie vorher
            child: Container(
              height: 40, // 30% reduzierte Höhe (ursprünglich 80)
              decoration: BoxDecoration(
                color: const Color(0xFF3D405B), // Hintergrundfarbe
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF81B29A), // Randfarbe
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddActivityScreen(),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: Color(0xFF81B29A), // Trennlinie in Rot
                              width: 1,
                            ),
                          ),
                        ),
                        child: const Text(
                          "Add Activity",
                          style: TextStyle(
                            color: Color(0xFF81B29A), // Schriftfarbe
                            fontWeight: FontWeight.bold, // Fett
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        print("MyActivities clicked");
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          "Manage Activities",
                          style: TextStyle(
                            color: Color(0xFF81B29A), // Schriftfarbe
                            fontWeight: FontWeight.bold, // Fett
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF3D405B), // Hintergrundfarbe
    );
  }
}
