import 'package:cloud_firestore/cloud_firestore.dart';

/// Repräsentiert einen Benutzer in der App.
class AppUser {
  final String uid;
  final String name;
  final String email;
  final String? profileImageUrl;
  final String? bio;
  final List<String> friends;
  final Timestamp createdAt;

  /// Konstruktor für die AppUser-Klasse.
  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.bio,
    this.friends = const [],
    required this.createdAt,
  });

  /// Erstellt ein AppUser-Objekt aus einer Firestore-Datenmap.
  factory AppUser.fromMap(Map<String, dynamic> data, String documentId) {
    return AppUser(
      uid: documentId,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      bio: data['bio'],
      friends: List<String>.from(data['friends'] ?? []),
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  /// Wandelt das AppUser-Objekt in eine Map um, die für Firestore geeignet ist.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'friends': friends,
      'createdAt': createdAt,
    };
  }

  /// Erstellt eine Kopie des AppUser-Objekts mit geänderten Feldern.
  AppUser copyWith({
    String? name,
    String? email,
    String? profileImageUrl,
    String? bio,
    List<String>? friends,
    Timestamp? createdAt,
  }) {
    return AppUser(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      friends: friends ?? this.friends,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
