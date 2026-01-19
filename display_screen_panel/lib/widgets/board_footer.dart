import 'package:flutter/material.dart';

class BoardFooter extends StatelessWidget {
  final bool isEnglish;
  const BoardFooter({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(
            color: Colors.white12,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 📢 MESSAGE
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.info_outline,
                color: Colors.amber,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                isEnglish
                    ? "Please have your fare ready"
                    : "Sicela ulungise imali",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // 👨‍💻 DEVELOPER CREDIT (MODERN)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.code_rounded,
                  size: 14,
                  color: Colors.white60,
                ),
                SizedBox(width: 6),
                Text(
                  "Developed by Amaphisi",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
