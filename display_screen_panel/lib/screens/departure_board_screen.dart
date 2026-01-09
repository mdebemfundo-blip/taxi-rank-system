import 'dart:async';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../widgets/board_header.dart';
import '../widgets/table_header.dart';
import '../widgets/departure_row.dart';
import '../widgets/board_footer.dart';
import '../widgets/advert_rotator.dart';

class DepartureBoardScreen extends StatefulWidget {
  const DepartureBoardScreen({super.key});

  @override
  State<DepartureBoardScreen> createState() => _DepartureBoardScreenState();
}

class _DepartureBoardScreenState extends State<DepartureBoardScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  Timer? _scrollTimer;
  late AnimationController _blinkController;

  bool isEnglish = true;

  @override
  void initState() {
    super.initState();

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _startAutoScroll();
  }

  void _startAutoScroll() {
    _scrollTimer?.cancel();
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 40), (_) {
      if (!_scrollController.hasClients) return;

      final max = _scrollController.position.maxScrollExtent;
      final offset = _scrollController.offset + 1;

      _scrollController.jumpTo(offset >= max ? 0 : offset);
    });
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _blinkController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            BoardHeader(
              isEnglish: isEnglish,
              onToggle: (v) => setState(() => isEnglish = v),
            ),
            const TableHeader(),
            Expanded(child: _buildRouteStream()),
            BoardFooter(isEnglish: isEnglish),
          ],
        ),
      ),
    );
  }

  // ================= STREAMED ROUTES =================

  Widget _buildRouteStream() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: FirebaseService.routeStream(), // ✅ FIXED
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text(
              "Loading routes...",
              style: TextStyle(color: Colors.white70, fontSize: 20),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "No departures available",
              style: TextStyle(color: Colors.white54, fontSize: 18),
            ),
          );
        }

        final departures = snapshot.data!;

        return ListView.builder(
          controller: _scrollController,
          itemCount: departures.length,
          itemBuilder: (_, i) {
            final d = departures[i];

            final filled = d['seats_filled'] ?? 0;
            final total = d['total_seats'] ?? 15;

            return DepartureRow(
              route: isEnglish
                  ? d['route_en'] ?? 'Unknown Route'
                  : d['route_zu'] ?? 'Umzila Ongaziwa',
              status: d['status'] ?? 'WAITING',
              seats: '${d['seats_filled'] ?? 0} / ${d['total_seats'] ?? 15}',
              time: d['depart_time'] ?? '--:--',
              price: d['price'] ?? 0, // pass to widget
              blinkController: _blinkController,
            );
          },
        );
      },
    );
  }
}
