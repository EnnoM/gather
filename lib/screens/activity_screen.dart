import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../models/user.dart';
import '../widgets/custom_drawer.dart';
import 'feed_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityScreen extends StatefulWidget {
  final Activity activity;
  final List<AppUser> users;

  const ActivityScreen({
    super.key,
    required this.activity,
    required this.users,
  });

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    // Veranstalter anhand der ownerId finden
    final organizer = widget.users.firstWhere(
      (user) => user.uid == widget.activity.ownerId,
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

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color(0xFF81B29A),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const FeedScreen()),
              (route) => false,
            );
          },
        ),
        title: Text(
          widget.activity.title,
          style: const TextStyle(
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
            color: const Color(0xFF81B29A),
            onPressed: () {
              scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Zentriere die Inhalte
          children: [
            // Host-Informationen
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Zentriere die Zeile
              children: [
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
                const SizedBox(width: 8),
                Text(
                  organizer.name, // Name des Hosts
                  style: const TextStyle(
                    fontSize: 14, // Gleiche Größe wie andere Parameter
                    color: Color(0xFF3D405B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Parameter mit Emojis
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Zentriere die Zeile
              children: [
                const Text("📅", style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  '${widget.activity.startTime.toDate()}',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Zentriere die Zeile
              children: [
                const Text("📍", style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  '${widget.activity.location?.latitude ?? 'N/A'}, ${widget.activity.location?.longitude ?? 'N/A'}',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Zentriere die Zeile
              children: [
                const Text("🏷️", style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  '${widget.activity.category}',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Teilnehmer-Widget (X going)
            Container(
              height: MediaQuery.of(context).size.height * 0.20, // Feste Höhe
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF2CC8F),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${widget.activity.participants.length + 1} going',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3D405B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.activity.participants.length + 1,
                      itemBuilder: (context, index) {
                        final participant =
                            index == 0
                                ? organizer
                                : widget.users.firstWhere(
                                  (user) =>
                                      user.uid ==
                                      widget.activity.participants[index - 1],
                                  orElse:
                                      () => AppUser(
                                        uid: 'unknown',
                                        name: 'Unknown Participant',
                                        email: '',
                                        profileImageUrl: null,
                                        bio: null,
                                        friends: [],
                                        createdAt: Timestamp.now(),
                                      ),
                                );

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundImage:
                                    participant.profileImageUrl != null
                                        ? NetworkImage(
                                          participant.profileImageUrl!,
                                        )
                                        : null,
                                child:
                                    participant.profileImageUrl == null
                                        ? const Icon(Icons.person, size: 10)
                                        : null,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                participant.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF3D405B),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Chat-Karte
            Container(
              height: MediaQuery.of(context).size.height * 0.20, // Feste Höhe
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF3D405B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Chat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF4F1DE),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: ListView(
                      children: const [
                        Text(
                          'John: Hi everyone!',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFF4F1DE),
                          ),
                        ),
                        Text(
                          'Jane: Looking forward to it!',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFF4F1DE),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Anmelde-Button
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF81B29A),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextButton(
                  onPressed: () {
                    // Anmelde-Logik hier hinzufügen
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF4F1DE),
    );
  }
}
