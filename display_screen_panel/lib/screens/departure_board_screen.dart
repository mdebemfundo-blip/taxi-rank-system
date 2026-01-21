import 'dart:async';
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

  Timer? _scrollTimer;
  bool _isScrolling = false;

  bool isEnglish = true;

  @override
  void initState() {
    super.initState();

    // Blink starts immediately
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  void _startAutoScroll() {
    if (_isScrolling) return;

    _isScrolling = true;
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 40), (_) {
      if (!_scrollController.hasClients) return;

      final max = _scrollController.position.maxScrollExtent;
      double nextOffset = _scrollController.offset + 1;

      if (nextOffset >= max) {
        nextOffset = 0;
      }

      _scrollController.jumpTo(nextOffset);
    });
  }

  void _stopAutoScroll() {
    _scrollTimer?.cancel();
    _isScrolling = false;
  }

  @override
  void dispose() {
    _blinkController.dispose();
    _scrollController.dispose();
    _stopAutoScroll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // responsive font sizes
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final bool isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            SizedBox(
              height: screenHeight * 0.12,
              child: BoardHeader(
                isEnglish: isEnglish,
                onToggle: (v) => setState(() => isEnglish = v),
              ),
            ),

            // Table header
            SizedBox(
              height: screenHeight * 0.08,
              child: const TableHeader(),
            ),

            // Route list
            Expanded(child: _buildRouteStream(isSmallScreen)),

            // Ads footer
            const SlidingAdsFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteStream(bool isSmallScreen) {
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
          _stopAutoScroll(); // no scroll
          return const Center(
            child: Text(
              "No departures available",
              style: TextStyle(color: Colors.white54, fontSize: 18),
            ),
          );
        }

        final departures = snapshot.data!;

        return LayoutBuilder(
          builder: (context, constraints) {
            // responsive item height based on screen
            final itemHeight = isSmallScreen ? 90.0 : 110.0;

            final estimatedHeight = departures.length * itemHeight;

            if (estimatedHeight > constraints.maxHeight) {
              _startAutoScroll();
            } else {
              _stopAutoScroll();
            }

            return ListView.builder(
              controller: _scrollController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: departures.length,
              itemBuilder: (_, index) {
                final d = departures[index];

                return SizedBox(
                  height: itemHeight,
                  child: DepartureRow(
                    route: isEnglish
                        ? d['route_en'] ?? 'Unknown Route'
                        : d['route_zu'] ?? 'Umzila Ongaziwa',
                    status: d['status'] ?? 'WAITING',
                    seats:
                        '${d['seats_filled'] ?? 0} / ${d['total_seats'] ?? 15}',
                    time: d['depart_time'] ?? '--:--',
                    price: d['price'] ?? 0,
                    blinkController: _blinkController,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
