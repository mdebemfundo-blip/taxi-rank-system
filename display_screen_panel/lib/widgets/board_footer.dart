import 'package:flutter/material.dart';

class BoardFooter extends StatelessWidget {
  final bool isEnglish;
  const BoardFooter({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        isEnglish ? "Please have your fare ready" : "Sicela ulungise imali",
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }
}
