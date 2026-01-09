import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class RouteFormSheet extends StatefulWidget {
  final Map<String, dynamic>? route;
  const RouteFormSheet({super.key, this.route});

  @override
  State<RouteFormSheet> createState() => _RouteFormSheetState();
}

class _RouteFormSheetState extends State<RouteFormSheet> {
  late TextEditingController routeEn;
  late TextEditingController routeZu;
  late TextEditingController departTime;
  late TextEditingController totalSeats;

  String status = "WAITING";

  @override
  void initState() {
    super.initState();

    routeEn = TextEditingController(text: widget.route?["route_en"] ?? "");
    routeZu = TextEditingController(text: widget.route?["route_zu"] ?? "");
    departTime =
        TextEditingController(text: widget.route?["depart_time"] ?? "");
    totalSeats = TextEditingController(
      text: (widget.route?["total_seats"] ?? 15).toString(),
    );

    status = widget.route?["status"] ?? "WAITING";
  }

  Future<void> _save() async {
    final data = {
      "route_en": routeEn.text.trim(),
      "route_zu": routeZu.text.trim(),
      "depart_time": departTime.text.trim(),
      "total_seats": int.tryParse(totalSeats.text) ?? 15,
      "seats_filled": widget.route?["seats_filled"] ?? 0,
      "status": status,
      "updated_at": DateTime.now(),
    };

    if (widget.route == null) {
      await FirebaseService.addRoute(data);
    } else {
      await FirebaseService.updateRoute(
        widget.route!["id"],
        data,
      );
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                widget.route == null ? "Add New Route" : "Edit Route",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _field("Route (English)", routeEn),
              _field("Route (isiZulu)", routeZu),
              _field("Departure Time (e.g 11:30)", departTime),
              _field(
                "Total Seats",
                totalSeats,
                keyboard: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                value: status,
                items: const [
                  DropdownMenuItem(value: "WAITING", child: Text("WAITING")),
                  DropdownMenuItem(value: "BOARDING", child: Text("BOARDING")),
                  DropdownMenuItem(value: "FULL", child: Text("FULL")),
                ],
                onChanged: (v) => setState(() => status = v!),
                decoration: const InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "SAVE ROUTE",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
