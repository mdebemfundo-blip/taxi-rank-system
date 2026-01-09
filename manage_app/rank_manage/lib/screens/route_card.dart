import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RouteCard extends StatelessWidget {
  final QueryDocumentSnapshot route;
  const RouteCard({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    final int filled = route['seats_filled'];
    final int total = route['total_seats'];
    final double progress = filled / total;

    return Card(
      color: const Color(0xFF152238),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(route['route_en'],
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 6),
            Text(
              'R${route['price']} • ${route['depart_time']}',
              style: const TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 12),

            /// 📊 Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Seats: $filled / $total',
                    style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.white24,
                    valueColor: AlwaysStoppedAnimation(
                      progress >= 1 ? Colors.red : Colors.green,
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            /// ➕ / ➖ Button
            GestureDetector(
              onTap: () => _increment(context),
              onLongPress: () => _decrement(context),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: progress >= 1 ? Colors.grey : Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: null,
                  child: const Text('Add Passenger'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ➕ ADD
  void _increment(BuildContext context) {
    if (route['seats_filled'] >= route['total_seats']) return;

    route.reference.update({
      'seats_filled': FieldValue.increment(1),
      'status': route['seats_filled'] + 1 >= route['total_seats']
          ? 'FULL'
          : 'BOARDING',
    });
  }

  /// ➖ REMOVE
  void _decrement(BuildContext context) {
    if (route['seats_filled'] <= 0) return;

    route.reference.update({
      'seats_filled': FieldValue.increment(-1),
      'status': 'BOARDING',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Passenger removed')),
    );
  }
}
