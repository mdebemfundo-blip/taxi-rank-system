import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'route_card.dart';
import 'stats_dashboard.dart';

class ManageRoutesScreen extends StatelessWidget {
  const ManageRoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddRouteDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Route'),
      ),
      body: Column(
        children: const [
          StatsDashboard(),
          Expanded(child: RoutesGrid()),
        ],
      ),
    );
  }
}

class RoutesGrid extends StatelessWidget {
  const RoutesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('routes')
          .orderBy('created_at', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final routes = snapshot.data!.docs;

        return LayoutBuilder(
          builder: (context, constraints) {
            int columns = 1;
            if (constraints.maxWidth > 900) {
              columns = 3;
            } else if (constraints.maxWidth > 600) {
              columns = 2;
            }

            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                childAspectRatio: 1.25,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: routes.length,
              itemBuilder: (_, i) => RouteCard(route: routes[i]),
            );
          },
        );
      },
    );
  }
}
