import 'package:cloud_firestore/cloud_firestore.dart';

/// Repräsentiert eine Aktivität in der App.
class Activity {
  final String id;
  final String title;
  final String description;
  final String category;
  final String ownerId;
  final GeoPoint? location;
  final Timestamp startTime;
  final List<String> participants;
  final List<String>? imageUrls;
  final Timestamp createdAt;

  /// Konstruktor für die Activity-Klasse.
  const Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.ownerId,
    this.location,
    required this.startTime,
    this.participants = const [],
    this.imageUrls,
    required this.createdAt,
  });

  /// Erstellt ein Activity-Objekt aus einer Firestore-Datenmap.
  factory Activity.fromMap(Map<String, dynamic> data, String documentId) {
    return Activity(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      ownerId: data['ownerId'] ?? '',
      location: data['location'],
      startTime: data['startTime'] ?? Timestamp.now(),
      participants: List<String>.from(data['participants'] ?? []),
      imageUrls:
          data['imageUrls'] != null
              ? List<String>.from(data['imageUrls'])
              : null,
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  /// Wandelt das Activity-Objekt in eine Map um, die für Firestore geeignet ist.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'ownerId': ownerId,
      'location': location,
      'startTime': startTime,
      'participants': participants,
      'imageUrls': imageUrls,
      'createdAt': createdAt,
    };
  }

  /// Erstellt eine Kopie des Activity-Objekts mit geänderten Feldern.
  Activity copyWith({
    String? title,
    String? description,
    String? category,
    String? ownerId,
    GeoPoint? location,
    Timestamp? startTime,
    List<String>? participants,
    List<String>? imageUrls,
    Timestamp? createdAt,
  }) {
    return Activity(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      ownerId: ownerId ?? this.ownerId,
      location: location ?? this.location,
      startTime: startTime ?? this.startTime,
      participants: participants ?? this.participants,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
