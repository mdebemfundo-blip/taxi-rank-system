import 'package:flutter/material.dart';

class TableHeader extends StatelessWidget {
  const TableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      color: const Color(0xFF102A44),
      child: const Row(
        children: [
          Expanded(flex: 4, child: _Header("ROUTE")),
          Expanded(flex: 2, child: _Header("STATUS")),
          Expanded(
            flex: 2,
            child: Text("SEATS",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                )),
          ),
          Expanded(flex: 2, child: _Header("PRICE")),
          Expanded(flex: 2, child: _Header("DEPARTS")),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String text;
  const _Header(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
