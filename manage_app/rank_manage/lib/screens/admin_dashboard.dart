import 'package:flutter/material.dart';
import 'manage_routes_screen.dart';
import 'manage_ads_screen.dart';
import 'preview_board_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Taxi Rank Admin Panel")),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        children: [
          _tile(context, "Manage Routes", Icons.alt_route,
              const ManageRoutesScreen()),
          _tile(context, "Manage Adverts", Icons.campaign,
              const ManageAdsScreen()),
          _tile(context, "Preview Board", Icons.tv, const PreviewBoardScreen()),
        ],
      ),
    );
  }

  Widget _tile(BuildContext c, String title, IconData icon, Widget page) {
    return InkWell(
      onTap: () => Navigator.push(
        c,
        MaterialPageRoute(builder: (_) => page),
      ),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
