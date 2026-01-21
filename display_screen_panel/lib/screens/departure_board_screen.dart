import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../widgets/board_header.dart';
import '../widgets/slidefooter_adds.dart';
import '../widgets/table_header.dart';
import '../widgets/departure_row.dart';
import '../widgets/board_footer.dart';

class DepartureBoardScreen extends StatefulWidget {
  const DepartureBoardScreen({super.key});

  @override
  State<DepartureBoardScreen> createState() => _DepartureBoardScreenState();
}

class _DepartureBoardScreenState extends State<DepartureBoardScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _blinkController;

  bool isEnglish = true;

  static const int _loopMultiplier = 1000; // 👈 large virtual list

  @override
  void initState() {
    super.initState();

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _startInfiniteScroll();
  }

  void _startInfiniteScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      const scrollStep = 1.0; // pixels per tick
      const tickDuration = Duration(milliseconds: 20); // speed

      while (mounted) {
        if (!_scrollController.hasClients) {
          await Future.delayed(const Duration(milliseconds: 100));
          continue;
        }

        final max = _scrollController.position.maxScrollExtent;

        double nextOffset = _scrollController.offset + scrollStep;

        if (nextOffset >= max) {
          // move first item to end illusion
          nextOffset = 0;
        }

        _scrollController.jumpTo(nextOffset); // small jump
        await Future.delayed(tickDuration);
      }
    });
  }

  @override
  void dispose() {
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
            const SlidingAdsFooter(),
          ],
        ),
      ),
    );
  }

  // ================= STREAMED ROUTES =================

  Widget _buildRouteStream() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: FirebaseService.routeStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text(
              "Loading routes...",
              style: TextStyle(color: Colors.white70, fontSize: 19),
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
        final totalItems = departures.length * _loopMultiplier;

        return ListView.builder(
          controller: _scrollController,
          physics: const NeverScrollableScrollPhysics(), // kiosk style
          itemCount: totalItems,
          itemBuilder: (_, index) {
            final d = departures[index % departures.length];

            return DepartureRow(
              route: isEnglish
                  ? d['route_en'] ?? 'Unknown Route'
                  : d['route_zu'] ?? 'Umzila Ongaziwa',
              status: d['status'] ?? 'WAITING',
              seats: '${d['seats_filled'] ?? 0} / ${d['total_seats'] ?? 15}',
              time: d['depart_time'] ?? '--:--',
              price: d['price'] ?? 0,
              blinkController: _blinkController,
            );
          },
        );
      },
    );
  }
}
