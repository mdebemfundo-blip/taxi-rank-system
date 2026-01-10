import 'package:flutter/material.dart';
import 'manage_routes_screen.dart';
import 'manage_ads_screen.dart';
import 'preview_board_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _index = 0;

  final _pages = const [
    _DashboardHome(),
    ManageRoutesScreen(),
    ManageAdsScreen(),
    PreviewBoardScreen(),
  ];

  final _titles = const [
    'Dashboard',
    'Routes',
    'Adverts',
    'Board Preview',
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: Colors.white,

      /// 🔝 APP BAR
      appBar: AppBar(
        title: Text(_titles[_index]),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),

      /// 📱 BODY
      body: Row(
        children: [
          if (isWide) _sideNav(),
          Expanded(child: _pages[_index]),
        ],
      ),

      /// 📌 FOOTER (Mobile only)
      bottomNavigationBar: isWide ? null : _bottomNav(),
    );
  }

  /// 🧭 SIDE NAV (Tablet / Web)
  Widget _sideNav() {
    return NavigationRail(
      selectedIndex: _index,
      onDestinationSelected: (i) => setState(() => _index = i),
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: Text('Dashboard'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.alt_route_outlined),
          selectedIcon: Icon(Icons.alt_route),
          label: Text('Routes'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.campaign_outlined),
          selectedIcon: Icon(Icons.campaign),
          label: Text('Adverts'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.tv_outlined),
          selectedIcon: Icon(Icons.tv),
          label: Text('Board'),
        ),
      ],
    );
  }

  /// 📱 BOTTOM NAV (Mobile)
  Widget _bottomNav() {
    return BottomNavigationBar(
      currentIndex: _index,
      onTap: (i) => setState(() => _index = i),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.alt_route),
          label: 'Routes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.campaign),
          label: 'Adverts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.tv),
          label: 'Board',
        ),
      ],
    );
  }
}

/// 🏠 DASHBOARD HOME GRID
class _DashboardHome extends StatelessWidget {
  const _DashboardHome();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return Column(
      children: [
        Expanded(
          child: GridView.count(
            crossAxisCount: isWide ? 3 : 2,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: const [
              _DashboardTile(
                title: "Manage Routes",
                icon: Icons.alt_route,
                page: ManageRoutesScreen(),
              ),
              _DashboardTile(
                title: "Manage Adverts",
                icon: Icons.campaign,
                page: ManageAdsScreen(),
              ),
              _DashboardTile(
                title: "Preview Board",
                icon: Icons.tv,
                page: PreviewBoardScreen(),
              ),
            ],
          ),
        ),

        /// 🧾 FOOTER
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Taxi Rank System • Admin Panel v1.0",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

/// 🧩 DASHBOARD CARD
class _DashboardTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget page;

  const _DashboardTile({
    required this.title,
    required this.icon,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      ),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
