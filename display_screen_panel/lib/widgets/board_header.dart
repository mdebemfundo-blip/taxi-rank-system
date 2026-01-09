import 'package:flutter/material.dart';

class BoardHeader extends StatelessWidget {
  final bool isEnglish;
  final ValueChanged<bool> onToggle;

  const BoardHeader({
    super.key,
    required this.isEnglish,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "TAXI RANK DEPARTURES",
            style: TextStyle(
              color: Colors.amber,
              fontSize: 34,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(width: 24),
          Switch(value: isEnglish, onChanged: onToggle),
          Text(isEnglish ? "EN" : "ZU",
              style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
