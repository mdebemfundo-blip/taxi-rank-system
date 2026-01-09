import 'package:flutter/material.dart';

class DepartureBoardScreen extends StatelessWidget {
  const DepartureBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A1A2F), Color(0xFF000000)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            _buildHeader(),
            _buildTableHeader(),
            Expanded(
              child: ListView(
                children: const [
                  DepartureRow(
                    route: "Richards Bay → Durban",
                    status: "BOARDING",
                    statusColor: Colors.green,
                    seats: "8 / 15",
                    time: "10:30",
                  ),
                  DepartureRow(
                    route: "Richards Bay → Empangeni",
                    status: "WAITING",
                    statusColor: Colors.orange,
                    seats: "5 / 15",
                    time: "10:45",
                  ),
                  DepartureRow(
                    route: "Richards Bay → Johannesburg",
                    status: "FULL",
                    statusColor: Colors.red,
                    seats: "15 / 15",
                    time: "DEPARTING",
                  ),
                ],
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      width: double.infinity,
      color: Colors.black,
      child: const Text(
        "TAXI RANK DEPARTURES",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.amber,
          fontSize: 36,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      color: const Color(0xFF102A44),
      child: const Row(
        children: [
          Expanded(flex: 4, child: HeaderText("ROUTE")),
          Expanded(flex: 2, child: HeaderText("STATUS")),
          Expanded(flex: 2, child: HeaderText("SEATS")),
          Expanded(flex: 2, child: HeaderText("DEPARTS")),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      color: Colors.black,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Next Taxi to Durban: 11:00",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Text(
            "Please Have Your Fare Ready",
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class HeaderText extends StatelessWidget {
  final String text;
  const HeaderText(this.text, {super.key});

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

class DepartureRow extends StatelessWidget {
  final String route;
  final String status;
  final Color statusColor;
  final String seats;
  final String time;

  const DepartureRow({
    super.key,
    required this.route,
    required this.status,
    required this.statusColor,
    required this.seats,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white24),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              route,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
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
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              seats,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
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
