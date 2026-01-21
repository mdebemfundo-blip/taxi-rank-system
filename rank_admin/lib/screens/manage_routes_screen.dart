import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageRoutesScreen extends StatelessWidget {
  const ManageRoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
    final String name = route['route_en'];
    final String status = route['status'];
    final int filled = route['seats_filled'];
    final int total = route['total_seats'];
    final int price = route['price'];

    return Card(
      color: const Color(0xFF152238),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Name + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                _StatusBadge(status: status),
              ],
            ),

            const SizedBox(height: 6),

            /// Price
            Text(
              'Price: R$price',
              style: const TextStyle(color: Colors.white70),
            ),

            /// More
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _showMore(context, route),
                icon: const Icon(Icons.more_horiz, color: Colors.white70),
                label: const Text('More',
                    style: TextStyle(color: Colors.white70)),
              ),
            ),

            /// Seats + controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Seats: $filled / $total',
                  style: const TextStyle(color: Colors.white70),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle,
                          color: Colors.red),
                      onPressed: filled == 0 ? null : () => _removePassenger(route),
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.add_circle, color: Colors.green),
                      onPressed:
                          status == 'FULL' ? null : () => _addPassenger(route),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  /* ───────────────────────── PASSENGERS ───────────────────────── */

  void _addPassenger(QueryDocumentSnapshot route) async {
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

  void _removePassenger(QueryDocumentSnapshot route) async {
    final ref = route.reference;

    FirebaseFirestore.instance.runTransaction((tx) async {
      final snap = await tx.get(ref);
      int filled = snap['seats_filled'];

      if (filled <= 0) return;

      filled--;
      tx.update(ref, {
        'seats_filled': filled,
        'status': 'BOARDING',
      });
    });
  }

  /* ───────────────────────── MORE ───────────────────────── */

  void _showMore(BuildContext context, QueryDocumentSnapshot route) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Route'),
              onTap: () {
                Navigator.pop(context);
                _showEditRouteDialog(context, route);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Route'),
              onTap: () async {
                await route.reference.delete();
                Navigator.pop(context);
              },
            ),
          ]),
        );
      },
    );
  }
}

/* ───────────────────────── EDIT / ADD ───────────────────────── */

Future<void> _pickTime(
    BuildContext context, TextEditingController c) async {
  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  if (time != null) {
    c.text = time.format(context);
  }
}

void _showEditRouteDialog(
    BuildContext context, QueryDocumentSnapshot route) async {

  final name =
      TextEditingController(text: route['route_en']);
  final price =
      TextEditingController(text: route['price'].toString());
  final seats =
      TextEditingController(text: route['total_seats'].toString());
  final time =
      TextEditingController(text: route['depart_time']);

  // Get route list from firestore
  final routesSnapshot = await FirebaseFirestore.instance.collection('routes').get();
  final routeNames = routesSnapshot.docs
      .map((d) => d['route_en'].toString())
      .toList();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Edit Route'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        RouteDropdownField(
          label: 'Route Name',
          routes: routeNames,
          initialValue: name.text,
          onChanged: (v) => name.text = v,
        ),
        _field(price, 'Price', isNumber: true),
        _field(seats, 'Total Seats', isNumber: true),
        TextField(
          controller: time,
          readOnly: true,
          onTap: () => _pickTime(context, time),
          decoration: const InputDecoration(labelText: 'Departure Time'),
        ),
      ]),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            await route.reference.update({
              'route_en': name.text,
              'route_zu': name.text,
              'price': int.parse(price.text),
              'total_seats': int.parse(seats.text),
              'depart_time': time.text,
            });
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

void _showAddRouteDialog(BuildContext context) async {
  final name = TextEditingController();
  final price = TextEditingController();
  final seats = TextEditingController(text: '15');
  final time = TextEditingController();

  // Get route list from firestore
  final routesSnapshot = await FirebaseFirestore.instance.collection('routes').get();
  final routeNames = routesSnapshot.docs
      .map((d) => d['route_en'].toString())
      .toList();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Add Route'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        RouteDropdownField(
          label: 'Route Name',
          routes: routeNames,
          initialValue: null,
          onChanged: (v) => name.text = v,
        ),
        _field(price, 'Price', isNumber: true),
        _field(seats, 'Total Seats', isNumber: true),
        TextField(
          controller: time,
          readOnly: true,
          onTap: () => _pickTime(context, time),
          decoration: const InputDecoration(labelText: 'Departure Time'),
        ),
      ]),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            await FirebaseFirestore.instance.collection('routes').add({
              'route_en': name.text,
              'route_zu': name.text,
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
    ),
  );
}

/* ───────────────────────── HELPERS ───────────────────────── */

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
          borderRadius: BorderRadius.circular(20)),
      child: Text(status,
          style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }
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

/* ───────────────────────── ROUTE DROPDOWN SEARCH FIELD ───────────────────────── */

class RouteDropdownField extends StatefulWidget {
  final String? initialValue;
  final List<String> routes;
  final Function(String) onChanged;
  final String label;

  const RouteDropdownField({
    Key? key,
    this.initialValue,
    required this.routes,
    required this.onChanged,
    required this.label,
  }) : super(key: key);

  @override
  State<RouteDropdownField> createState() => _RouteDropdownFieldState();
}

class _RouteDropdownFieldState extends State<RouteDropdownField> {
  late TextEditingController _controller;
  late TextEditingController _searchController;
  late List<String> _filteredRoutes;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
    _searchController = TextEditingController();
    _filteredRoutes = widget.routes;
  }

  void _openDropdown() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search Route',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setStateModal(() {
                        _filteredRoutes = widget.routes
                            .where((r) => r.toLowerCase().contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      itemCount: _filteredRoutes.length,
                      itemBuilder: (_, index) {
                        final route = _filteredRoutes[index];
                        return ListTile(
                          title: Text(route),
                          onTap: () {
                            _controller.text = route;
                            widget.onChanged(route);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openDropdown,
      child: AbsorbPointer(
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: widget.label,
            suffixIcon: const Icon(Icons.arrow_drop_down),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
