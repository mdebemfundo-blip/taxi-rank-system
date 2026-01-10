import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final _db = FirebaseFirestore.instance;

  // ================= ROUTES =================

  /// CREATE
  static Future<void> addRoute(Map<String, dynamic> data) async {
    await _db.collection('routes').add({
      ...data,
      "created_at": FieldValue.serverTimestamp(),
      "updated_at": FieldValue.serverTimestamp(),
    });
  }

  /// READ (STREAM)
  static Stream<List<Map<String, dynamic>>> streamRoutes() {
    return _db
        .collection('routes')
        .orderBy('created_at', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return {
                "id": doc.id,
                ...data,
              };
            }).toList());
  }

  /// READ (ONCE)
  static Future<List<Map<String, dynamic>>> getRoutes() async {
    final snap = await _db.collection('routes').orderBy('created_at').get();

    return snap.docs.map((doc) {
      return {
        "id": doc.id,
        ...doc.data(),
      };
    }).toList();
  }

  /// UPDATE
  static Future<void> updateRoute(
    String id,
    Map<String, dynamic> data,
  ) async {
    await _db.collection('routes').doc(id).update({
      ...data,
      "updated_at": FieldValue.serverTimestamp(),
    });
  }

  /// DELETE
  static Future<void> deleteRoute(String id) async {
    await _db.collection('routes').doc(id).delete();
  }

  // ================= ADVERTS =================

  static Stream<List<Map<String, dynamic>>> streamAdverts() {
    return _db
        .collection('adverts')
        .where('active', isEqualTo: true)
        .snapshots()
        .map((s) => s.docs.map((d) => {"id": d.id, ...d.data()}).toList());
  }
}
