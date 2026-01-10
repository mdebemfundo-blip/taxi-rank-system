import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageRoutesScreen extends StatelessWidget {
  const ManageRoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ CHANGED TO WHITE
      appBar: AppBar(
        title: const Text('Manage Routes'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddRouteDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Route'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('routes')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final routes = snapshot.data!.docs;

          if (routes.isEmpty) {
            return const Center(child: Text('No routes found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: routes.length,
            itemBuilder: (context, index) {
              return RouteCard(route: routes[index]);
            },
          );
        },
      ),
    );
  }
}

/* ───────────────────────── ROUTE CARD ───────────────────────── */

class RouteCard extends StatelessWidget {
  final QueryDocumentSnapshot route;

  const RouteCard({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    final String routeEn = route['route_en'];
    final String status = route['status'];
    final int filled = route['seats_filled'];
    final int total = route['total_seats'];

    return Card(
      color: const Color(0xFF152238),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Route + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    routeEn,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                _StatusBadge(status: status),
              ],
            ),

            const SizedBox(height: 6),

            /// ✅ MORE BUTTON (NEW)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _showMore(context),
                icon: const Icon(Icons.more_horiz, color: Colors.white70),
                label: const Text(
                  'More',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),

            /// Animated Seats
            TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: 0,
                end: filled.toDouble(),
              ),
              duration: const Duration(milliseconds: 300),
              builder: (_, value, __) {
                return Text(
                  'Seats: ${value.toInt()} / $total',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                );
              },
            ),

            const SizedBox(height: 14),

            /// Add Passenger
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: status == 'FULL'
                    ? null
                    : () => _addPassenger(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Add Passenger',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* ───────────────────────── ACTIONS ───────────────────────── */

  void _addPassenger(BuildContext context) async {
    final ref = route.reference;

    FirebaseFirestore.instance.runTransaction((tx) async {
      final snap = await tx.get(ref);
      int filled = snap['seats_filled'];
      int total = snap['total_seats'];

      if (filled >= total) return;

      filled++;

      tx.update(ref, {
        'seats_filled': filled,
        'status': filled >= total ? 'FULL' : 'BOARDING',
      });
    });
  }

  void _showMore(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Route'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: open edit dialog
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete Route'),
                onTap: () async {
                  await route.reference.delete();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

/* ───────────────────────── STATUS BADGE ───────────────────────── */

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status == 'FULL' ? Colors.red : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/* ───────────────────────── ADD ROUTE DIALOG ───────────────────────── */

void _showAddRouteDialog(BuildContext context) {
  final en = TextEditingController();
  final zu = TextEditingController();
  final price = TextEditingController();
  final seats = TextEditingController(text: '15');
  final time = TextEditingController(text: '11:30');

  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: const Text('Add Route'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _field(en, 'Route (EN)'),
              _field(zu, 'Route (ZU)'),
              _field(price, 'Price', isNumber: true),
              _field(seats, 'Total Seats', isNumber: true),
              _field(time, 'Departure Time'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('routes').add({
                'route_en': en.text,
                'route_zu': zu.text,
                'price': int.parse(price.text),
                'total_seats': int.parse(seats.text),
                'seats_filled': 0,
                'depart_time': time.text,
                'status': 'BOARDING',
                'created_at': FieldValue.serverTimestamp(),
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}

Widget _field(TextEditingController c, String label,
    {bool isNumber = false}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      controller: c,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
