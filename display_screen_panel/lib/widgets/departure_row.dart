import 'package:flutter/material.dart';

class DepartureRow extends StatelessWidget {
  final String route, status, seats, time;
  final AnimationController blinkController;
  final dynamic price;

  const DepartureRow({
    super.key,
    required this.route,
    required this.status,
    required this.seats,
    required this.time,
    required this.blinkController,
    required this.price,
  });

  Color get statusColor =>
      {
        "BOARDING": Colors.green,
        "WAITING": Colors.orange,
        "FULL": Colors.red,
      }[status] ??
      Colors.grey;

  /// ✅ Flip text for BOARDING
  String get displayStatus {
    if (status != "BOARDING") return status;

    // Alternate text using animation value
    return blinkController.value < 0.5
        ? "BOARDING"
        : "IYALAYISHA";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white24)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              route,
              style: const TextStyle(color: Colors.white, fontSize: 40),
            ),
          ),

          /// STATUS (BLINK + FLIP)
          Expanded(
            flex: 2,
            child: AnimatedBuilder(
              animation: blinkController,
              builder: (_, __) {
                return FadeTransition(
                  opacity: status == "BOARDING"
                      ? blinkController
                      : const AlwaysStoppedAnimation(1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      displayStatus,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              seats,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              'R$price',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              time,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
