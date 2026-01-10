import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class RouteDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> route;
  const RouteDetailsScreen({super.key, required this.route});

  @override
  State<RouteDetailsScreen> createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen> {
  late TextEditingController routeEn;
  late TextEditingController routeZu;
  late TextEditingController departTime;
  late TextEditingController totalSeats;
  late TextEditingController price;
  String status = "WAITING";
  int seatsFilled = 0;

  @override
  void initState() {
    super.initState();
    final r = widget.route;
    routeEn = TextEditingController(text: r['route_en']);
    routeZu = TextEditingController(text: r['route_zu']);
    departTime = TextEditingController(text: r['depart_time']);
    totalSeats =
        TextEditingController(text: (r['total_seats'] ?? 15).toString());
    price = TextEditingController(text: (r['price'] ?? 0).toString());
    status = r['status'] ?? 'WAITING';
    seatsFilled = r['seats_filled'] ?? 0;
  }

  void _updateField(String key, dynamic value) {
    FirebaseService.updateRoute(widget.route['id'], {key: value});
    setState(() {
      if (key == 'seats_filled') seatsFilled = value;
      if (key == 'status') status = value;
    });
  }

  void _deleteRoute() async {
    await FirebaseService.deleteRoute(widget.route['id']);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Route Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteRoute,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildField(
                "Route (EN)", routeEn, (v) => _updateField('route_en', v)),
            _buildField(
                "Route (ZI)", routeZu, (v) => _updateField('route_zu', v)),
            _buildField("Departure Time", departTime,
                (v) => _updateField('depart_time', v)),
            _buildField("Total Seats", totalSeats,
                (v) => _updateField('total_seats', int.tryParse(v) ?? 15),
                keyboard: TextInputType.number),
            _buildField("Price (R)", price,
                (v) => _updateField('price', int.tryParse(v) ?? 0),
                keyboard: TextInputType.number),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("Seats Filled: "),
                IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (seatsFilled > 0)
                        _updateField('seats_filled', seatsFilled - 1);
                    }),
                Text('$seatsFilled'),
                IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      final total = int.tryParse(totalSeats.text) ?? 15;
                      if (seatsFilled < total)
                        _updateField('seats_filled', seatsFilled + 1);
                    }),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: status,
              items: ['WAITING', 'BOARDING', 'FULL']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => _updateField('status', v),
              decoration: const InputDecoration(labelText: "Status"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
      String label, TextEditingController controller, Function(String) onChange,
      {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onSubmitted: onChange,
      ),
    );
  }
}
