import 'package:flutter/material.dart';

class PreviewBoardScreen extends StatelessWidget {
  const PreviewBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Passenger Board Preview"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildTableHeader(),
          Expanded(child: _buildMockRows()),
          _buildFooter(),
        ],
      ),
    );
  }

  // ================= HEADER =================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        "TAXI RANK DEPARTURES",
        style: TextStyle(
          color: Colors.amber.shade400,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }

  // ================= TABLE HEADER =================

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      color: const Color(0xFF102A44),
      child: const Row(
        children: [
          Expanded(flex: 4, child: _Header("ROUTE")),
          Expanded(flex: 2, child: _Header("STATUS")),
          Expanded(flex: 2, child: _Header("SEATS")),
          Expanded(flex: 2, child: _Header("DEPARTS")),
        ],
      ),
    );
  }

  // ================= MOCK ROWS =================

  Widget _buildMockRows() {
    final mockData = [
      {
        "route": "Richards Bay → Durban",
        "status": "BOARDING",
        "seats": "8 / 15",
        "time": "11:30",
      },
      {
        "route": "Richards Bay → Empangeni",
        "status": "WAITING",
        "seats": "5 / 15",
        "time": "11:45",
      },
      {
        "route": "Richards Bay → Johannesburg",
        "status": "FULL",
        "seats": "15 / 15",
        "time": "DEPARTING",
      },
    ];

    return ListView.builder(
      itemCount: mockData.length,
      itemBuilder: (_, i) {
        final d = mockData[i];
        return _PreviewRow(
          route: d["route"]!,
          status: d["status"]!,
          seats: d["seats"]!,
          time: d["time"]!,
        );
      },
    );
  }

  // ================= FOOTER =================

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        "Preview Mode • Passenger Screen",
        style: TextStyle(
          color: Colors.white54,
          fontSize: 16,
        ),
      ),
    );
  }
}

// ================= PREVIEW ROW =================

class _PreviewRow extends StatelessWidget {
  final String route, status, seats, time;

  const _PreviewRow({
    required this.route,
    required this.status,
    required this.seats,
    required this.time,
  });

  Color get statusColor =>
      {
        "BOARDING": Colors.green,
        "WAITING": Colors.orange,
        "FULL": Colors.red,
      }[status] ??
      Colors.grey;

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
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                status,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              seats,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              time,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= HEADER TEXT =================

class _Header extends StatelessWidget {
  final String text;
  const _Header(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
