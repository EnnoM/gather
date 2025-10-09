import '../models/activity.dart';
import '../models/user.dart'; // Importiere das AppUser-Modell
import 'package:cloud_firestore/cloud_firestore.dart';

class MockFirestoreService {
  /// Gibt eine Liste von Mock-Benutzern zurück.
  Future<List<AppUser>> getUsers() async {
    return [
      AppUser(
        uid: 'user1',
        name: 'John Doe',
        email: 'john.doe@example.com',
        profileImageUrl: 'https://example.com/profile1.jpg',
        bio: 'Outdoor enthusiast and hiker.',
        friends: ['user2', 'user3'],
        createdAt: Timestamp.now(),
      ),
      AppUser(
        uid: 'user2',
        name: 'Jane Smith',
        email: 'jane.smith@example.com',
        profileImageUrl: 'https://example.com/profile2.jpg',
        bio: 'Coffee lover and social butterfly.',
        friends: ['user1'],
        createdAt: Timestamp.now(),
      ),
      AppUser(
        uid: 'user3',
        name: 'Alice Johnson',
        email: 'alice.johnson@example.com',
        profileImageUrl: 'https://example.com/profile3.jpg',
        bio: 'Movie fanatic and entertainment expert.',
        friends: ['user1', 'user2'],
        createdAt: Timestamp.now(),
      ),
    ];
  }

  /// Gibt eine Liste von Mock-Aktivitäten zurück.
  Future<List<Activity>> getActivities() async {
    return [
      Activity(
        id: '1',
        title: 'Wandern im Park',
        description: 'Eine entspannte Wanderung im Park.',
        category: 'Outdoor',
        ownerId: 'user1', // Erstellt von John Doe
        location: GeoPoint(48.1351, 11.5820), // München
        startTime: Timestamp.now(),
        participants: ['user3', 'user2'], // Teilnehmer-UIDs
        imageUrls: ['https://example.com/image1.jpg'],
        createdAt: Timestamp.now(),
      ),
      Activity(
        id: '2',
        title: 'Kaffeetrinken',
        description: 'Gemütliches Kaffeetrinken in Berlin.',
        category: 'Social',
        ownerId: 'user2', // Erstellt von Jane Smith
        location: GeoPoint(52.5200, 13.4050), // Berlin
        startTime: Timestamp.now(),
        participants: ['user3'], // Teilnehmer-UIDs
        imageUrls: ['https://example.com/image2.jpg'],
        createdAt: Timestamp.now(),
      ),
      Activity(
        id: '3',
        title: 'Kinoabend',
        description: 'Filmabend in Köln.',
        category: 'Entertainment',
        ownerId: 'user3', // Erstellt von Alice Johnson
        location: GeoPoint(50.9375, 6.9603), // Köln
        startTime: Timestamp.now(),
        participants: ['user1', 'user2'], // Teilnehmer-UIDs
        imageUrls: null,
        createdAt: Timestamp.now(),
      ),
    ];
  }
}
