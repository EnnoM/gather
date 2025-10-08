import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/activity.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Lädt alle Aktivitäten aus der Firestore-Collection "activities".
  Future<List<Activity>> getActivities() async {
    final querySnapshot = await _firestore.collection('activities').get();
    return querySnapshot.docs.map((doc) {
      return Activity.fromMap(doc.data(), doc.id);
    }).toList();
  }
}
