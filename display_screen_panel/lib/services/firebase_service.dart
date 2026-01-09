import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ================= ROUTES =================

  static Future<List<Map<String, dynamic>>> getRoutes() async {
    final snapshot = await _db.collection('routes').orderBy('created_at').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return {
        "id": doc.id,
        "route_en": data["route_en"] ?? "",
        "route_zu": data["route_zu"] ?? "",
        "status": data["status"] ?? "WAITING",
        "seats_filled": data["seats_filled"] ?? 0,
        "total_seats": data["total_seats"] ?? 15,
        "depart_time": data["depart_time"] ?? "--:--",
      };
    }).toList();
  }

  static Stream<List<Map<String, dynamic>>> routeStream() {
    return _db
        .collection('routes')
        .orderBy('created_at')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return {
          "id": doc.id,
          "route_en": data["route_en"] ?? "",
          "route_zu": data["route_zu"] ?? "",
          "status": data["status"] ?? "WAITING",
          "seats_filled": data["seats_filled"] ?? 0,
          "total_seats": data["total_seats"] ?? 15,
          "depart_time": data["depart_time"] ?? "--:--",
          "price": data['price'] = data['price'] ?? 0
        };
      }).toList();
    });
  }

  static Future<void> addRoute(Map<String, dynamic> data) async {
    await _db.collection('routes').add({
      ...data,
      "created_at": FieldValue.serverTimestamp(),
    });
  }

  static Future<void> updateRoute(
    String id,
    Map<String, dynamic> data,
  ) async {
    await _db.collection('routes').doc(id).update(data);
  }

  static Future<void> deleteRoute(String id) async {
    await _db.collection('routes').doc(id).delete();
  }

  // ================= ADVERTS =================

  static Future<List<Map<String, dynamic>>> getAdverts() async {
    final snapshot =
        await _db.collection('adverts').where('active', isEqualTo: true).get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        "id": doc.id,
        "image_url": data["image_url"] ?? "",
      };
    }).toList();
  }

  static Stream<List<Map<String, dynamic>>> advertStream() {
    return _db
        .collection('adverts')
        .where('active', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "id": doc.id,
          "image_url": data["image_url"] ?? "",
        };
      }).toList();
    });
  }
}
