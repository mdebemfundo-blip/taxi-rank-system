import 'dart:async';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../widgets/board_header.dart';
import '../widgets/table_header.dart';
import '../widgets/departure_row.dart';
import '../widgets/board_footer.dart';
import '../widgets/ads_bottom_sheet.dart';

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

  bool _autoScrollStarted = false;

  // ✅ REQUIRED LIST SIZE BEFORE SCROLLING
  static const int _minItemsForScroll = 10;

  @override
  void initState() {
    super.initState();

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _blinkController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ───────────────────────── AUTO SCROLL ─────────────────────────

  void _startAutoScroll() {
    _autoScrollStarted = true;
    _scrollTimer?.cancel();

    _scrollTimer = Timer.periodic(
      const Duration(milliseconds: 40),
      (_) {
        if (!_scrollController.hasClients) return;

        final max = _scrollController.position.maxScrollExtent;
        final offset = _scrollController.offset + 1;

        if (offset >= max) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.jumpTo(offset);
        }
      },
    );
  }

  void _stopAutoScroll() {
    _autoScrollStarted = false;
    _scrollTimer?.cancel();

    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  // ───────────────────────── UI ─────────────────────────

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
            const AdsBottomSheet(visible: true),
          ],
        ),
      ),
    );
  }

  // ───────────────────────── ROUTE STREAM ─────────────────────────

  Widget _buildRouteStream() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: FirebaseService.routeStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          _stopAutoScroll();
          return const Center(
            child: Text(
              "Loading routes...",
              style: TextStyle(color: Colors.white70, fontSize: 19),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          _stopAutoScroll();
          return const Center(
            child: Text(
              "No departures available",
              style: TextStyle(color: Colors.white54, fontSize: 18),
            ),
          );
        }

        final departures = snapshot.data!;

        // ✅ START auto-scroll ONLY if list has 10+ items
        if (departures.length >= _minItemsForScroll &&
            !_autoScrollStarted) {
          _startAutoScroll();
        }

        // ⛔ STOP auto-scroll if list drops below 10
        if (departures.length < _minItemsForScroll &&
            _autoScrollStarted) {
          _stopAutoScroll();
        }

        return ListView.builder(
          controller: _scrollController,
          itemCount: departures.length,
          itemBuilder: (_, i) {
            final d = departures[i];

            return DepartureRow(
              route: isEnglish
                  ? d['route_en'] ?? 'Unknown Route'
                  : d['route_zu'] ?? 'Umzila Ongaziwa',
              status: d['status'] ?? 'WAITING',
              seats:
                  '${d['seats_filled'] ?? 0} / ${d['total_seats'] ?? 15}',
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
