import 'package:cloud_firestore/cloud_firestore.dart';

/// Repräsentiert eine Aktivität in der App.
class Activity {
  final String id;
  final String title;
  final String description;
  final String category;
  final String ownerId;
  final GeoPoint? location;
  final String address; // Neues Feld für die Adresse
  final String date; // Neues Feld für das Datum
  final String time; // Neues Feld für die Zeit
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
    required this.address, // Initialisierung des neuen Felds
    required this.date, // Initialisierung des neuen Felds
    required this.time, // Initialisierung des neuen Felds
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
      address: data['address'] ?? '', // Adresse aus der Map lesen
      date: data['date'] ?? '', // Datum aus der Map lesen
      time: data['time'] ?? '', // Zeit aus der Map lesen
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
      'address': address, // Adresse zur Map hinzufügen
      'date': date, // Datum zur Map hinzufügen
      'time': time, // Zeit zur Map hinzufügen
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
    String? address, // Neues Feld für die Kopie
    String? date, // Neues Feld für die Kopie
    String? time, // Neues Feld für die Kopie
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
      address: address ?? this.address, // Adresse kopieren
      date: date ?? this.date, // Datum kopieren
      time: time ?? this.time, // Zeit kopieren
      participants: participants ?? this.participants,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
