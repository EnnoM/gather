import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import für Provider
import '../models/activity.dart';
import '../models/user.dart';
import '../widgets/custom_drawer.dart';
import 'feed_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../state/user_state.dart';

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
  bool isChatExpanded = false; // Zustand für ein- und ausgeklappten Chat

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    // Aktuell eingeloggter Benutzer aus dem UserState abrufen
    final currentUser = Provider.of<UserState>(context).currentUser;

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

    // Überprüfen, ob der Benutzer eingeloggt ist
    if (currentUser == null) {
      return const Center(
        child: Text('No user logged in', style: TextStyle(fontSize: 12)),
      );
    }

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
          children: [
            // Host-Informationen
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 12,
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
                  organizer.name,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF3D405B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Parameter mit Emojis
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("📅", style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  '${widget.activity.date}, ${widget.activity.time}',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("📍", style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  widget.activity.address,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("🏷️", style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  widget.activity.category,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Teilnehmer-Widget (X going)
            Container(
              height: MediaQuery.of(context).size.height * 0.20,
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
                      fontSize: 14, // Schriftgröße angepasst
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255),
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
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundImage:
                                    participant.profileImageUrl != null
                                        ? NetworkImage(
                                          participant.profileImageUrl!,
                                        )
                                        : null,
                                child:
                                    participant.profileImageUrl == null
                                        ? const Icon(Icons.person, size: 12)
                                        : null,
                              ),
                              const SizedBox(width: 8),
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

            // Chat-Bereich
            GestureDetector(
              onTap: () {
                setState(() {
                  isChatExpanded = !isChatExpanded; // Zustand umschalten
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height:
                    isChatExpanded
                        ? MediaQuery.of(context).size.height *
                            0.4 // Ausgeklappt
                        : 50, // Eingeklappt (nur Kopfzeile sichtbar)
                width:
                    double
                        .infinity, // Gleiche horizontale Ausdehnung wie andere Elemente
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF3D405B), // Hintergrundfarbe des Chats
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        'Chat',
                        style: const TextStyle(
                          fontSize: 14, // Schriftgröße angepasst
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Textfarbe für den Titel
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Icon(
                        isChatExpanded
                            ? Icons.remove
                            : Icons.add, // "+" oder "-" anzeigen
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Button: Sign up oder Delete Activity
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child:
                    currentUser.uid == widget.activity.ownerId
                        ? ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Delete Activity'),
                                  content: const Text(
                                    'Are you sure you want to delete this activity?',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        print('Activity deleted');
                                      },
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE07A5F),
                          ),
                          child: const Text(
                            'Delete Activity',
                            style: TextStyle(
                              fontSize: 14, // Schriftgröße angepasst
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                        : ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF81B29A),
                          ),
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 14, // Schriftgröße angepasst
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
