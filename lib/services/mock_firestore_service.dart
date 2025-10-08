import '../models/activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MockFirestoreService {
  /// Gibt eine Liste von Mock-Aktivitäten zurück.
  Future<List<Activity>> getActivities() async {
    return [
      Activity(
        id: '1',
        title: 'Wandern im Park',
        description: 'Eine entspannte Wanderung im Park.',
        category: 'Outdoor',
        ownerId: 'user1',
        location: GeoPoint(48.1351, 11.5820), // München
        startTime: Timestamp.now(),
        participants: ['user1', 'user2'],
        imageUrls: ['https://example.com/image1.jpg'],
        createdAt: Timestamp.now(),
      ),
      Activity(
        id: '2',
        title: 'Kaffeetrinken',
        description: 'Gemütliches Kaffeetrinken in Berlin.',
        category: 'Social',
        ownerId: 'user2',
        location: GeoPoint(52.5200, 13.4050), // Berlin
        startTime: Timestamp.now(),
        participants: ['user3'],
        imageUrls: ['https://example.com/image2.jpg'],
        createdAt: Timestamp.now(),
      ),
      Activity(
        id: '3',
        title: 'Kinoabend',
        description: 'Filmabend in Köln.',
        category: 'Entertainment',
        ownerId: 'user3',
        location: GeoPoint(50.9375, 6.9603), // Köln
        startTime: Timestamp.now(),
        participants: ['user1', 'user4'],
        imageUrls: null,
        createdAt: Timestamp.now(),
      ),
    ];
  }
}
