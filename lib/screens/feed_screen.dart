import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/activity_state.dart';
import '../widgets/activity_map_preview.dart';
import '../widgets/custom_drawer.dart';
import 'activity_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isListView = true;

  @override
  void initState() {
    super.initState();
    // Aktivitäten beim Start laden
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
      body: Column(
        children: [
          // Menüleiste
          Container(
            height: kToolbarHeight,
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
            ), // Gleiche horizontale Abstände wie die Aktivitäten
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
                    ? ListView.builder(
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        final activity = activities[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16, // Abstand links und rechts
                            vertical: 8, // Abstand oben und unten
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
                                color: Color(0xFF3D405B), // Schriftfarbe
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "Lat: ${activity.location?.latitude ?? 'N/A'}, Lon: ${activity.location?.longitude ?? 'N/A'}",
                              style: const TextStyle(
                                color: Color(0xFF3D405B), // Schriftfarbe
                              ),
                            ),
                            onTap: () {
                              // Navigation zum ActivityScreen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          ActivityScreen(activity: activity),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    )
                    : Container(
                      margin: const EdgeInsets.all(16), // Abstand um die Karte
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
      backgroundColor: const Color(0xFF3D405B), // Hintergrundfarbe
    );
  }
}
