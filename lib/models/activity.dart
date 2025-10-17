import 'package:cloud_firestore/cloud_firestore.dart';

/// Repräsentiert eine Aktivität in der App.
class Activity {
  final String id;
  final String title;
  final String description;
  final String category;
  final String ownerId;
  final GeoPoint? location;
  final String road; // Straße
  final String houseNumber; // Hausnummer
  final String postcode; // Postleitzahl
  final String city; // Stadt
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
    required this.road, // Initialisierung der Straße
    required this.houseNumber, // Initialisierung der Hausnummer
    required this.postcode, // Initialisierung der Postleitzahl
    required this.city, // Initialisierung der Stadt
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
      road: data['road'] ?? 'Unbekannt', // Straße aus der Map lesen
      houseNumber: data['houseNumber'] ?? '', // Hausnummer aus der Map lesen
      postcode:
          data['postcode'] ?? 'Unbekannt', // Postleitzahl aus der Map lesen
      city: data['city'] ?? 'Unbekannt', // Stadt aus der Map lesen
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
      'road': road, // Straße zur Map hinzufügen
      'houseNumber': houseNumber, // Hausnummer zur Map hinzufügen
      'postcode': postcode, // Postleitzahl zur Map hinzufügen
      'city': city, // Stadt zur Map hinzufügen
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
    String? road, // Straße für die Kopie
    String? houseNumber, // Hausnummer für die Kopie
    String? postcode, // Postleitzahl für die Kopie
    String? city, // Stadt für die Kopie
    String? date, // Datum für die Kopie
    String? time, // Zeit für die Kopie
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
      road: road ?? this.road, // Straße kopieren
      houseNumber: houseNumber ?? this.houseNumber, // Hausnummer kopieren
      postcode: postcode ?? this.postcode, // Postleitzahl kopieren
      city: city ?? this.city, // Stadt kopieren
      date: date ?? this.date, // Datum kopieren
      time: time ?? this.time, // Zeit kopieren
      participants: participants ?? this.participants,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
