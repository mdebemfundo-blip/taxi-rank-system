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
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// LOGO
          Image.asset(
            'assets/logo.png',
            width: 160, // reduced width (important)
            height: 50,
            fit: BoxFit.contain,
          ),

          /// TITLE (auto-adjusts)
          Expanded(
            child: Center(
              child: Text(
                "TAXI RANK DEPARTURES",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 28, // slightly reduced
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),

          /// LANGUAGE SWITCH
          Row(
            children: [
              Switch(value: isEnglish, onChanged: onToggle),
              Text(
                isEnglish ? "EN" : "ZU",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class BoardHeader extends StatelessWidget {
//   final bool isEnglish;
//   final ValueChanged<bool> onToggle;

//   const BoardHeader({
//     super.key,
//     required this.isEnglish,
//     required this.onToggle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 14),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
// 		Image.asset(
//             'assets/logo.png', // Make sure logo is in assets folder
//             width: 240,          // Adjust proportionally (half of 329/800)
//             height: 65,
//             fit: BoxFit.contain,
//           ),
//           const Text(
//             "TAXI RANK DEPARTURES",
//             style: TextStyle(
//               color: Colors.amber,
//               fontSize: 34,
//               fontWeight: FontWeight.bold,
//               letterSpacing: 2,
//             ),
//           ),
//           const SizedBox(width: 24),
//           Switch(value: isEnglish, onChanged: onToggle),
//           Text(isEnglish ? "EN" : "ZU",
//               style: const TextStyle(color: Colors.white)),
//         ],
//       ),
//     );
//   }
// }
