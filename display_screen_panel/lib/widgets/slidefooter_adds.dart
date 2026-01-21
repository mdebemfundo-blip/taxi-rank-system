import 'dart:async';
import 'package:flutter/material.dart';

class SlidingAdsFooter extends StatefulWidget {
  const SlidingAdsFooter({super.key});

  @override
  State<SlidingAdsFooter> createState() => _SlidingAdsFooterState();
}

class _SlidingAdsFooterState extends State<SlidingAdsFooter> {
  late final PageController _pageController;

  Timer? _slideTimer;
  Timer? _pauseTimer;
  Timer? _announcementTimer;

  bool _adsPaused = false;
  int _currentAdIndex = 0;
  int _announcementIndex = 0;

  /* ================= DATA ================= */

  final List<_AdItem> ads = [
    _AdItem(
      image: 'assets/ads/ad1.png',
      title: 'City Wash',
      subtitle: 'Fast • Affordable • Reliable',
    ),
    _AdItem(
      image: 'assets/ads/ad2.png',
      title: 'Quick Eats',
      subtitle: 'Hot meals on the move',
    ),
	 _AdItem(
      image: 'assets/ads/ad3.png',
      title: 'Quick Eats',
      subtitle: 'Hot meals on the move',
    ),
	 _AdItem(
      image: 'assets/ads/ad4.png',
      title: 'Quick Eats',
      subtitle: 'Hot meals on the move',
    ),
  ];

  final List<String> announcements = [
    'Please have your fare ready',
    'No smoking inside the vehicle',
    'Respect other passengers',
    'Masks recommended during peak hours',
    'Powered by Amaphisi',
  ];

  /* ================= LIFECYCLE ================= */

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAds();
  }

  @override
  void dispose() {
    _slideTimer?.cancel();
    _pauseTimer?.cancel();
    _announcementTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  /* ================= ADS CONTROL ================= */

  void _startAds() {
    _slideTimer?.cancel();
    _currentAdIndex = 0;
    _adsPaused = false;

    _slideTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!_pageController.hasClients || _adsPaused) return;

      if (_currentAdIndex >= ads.length - 1) {
        _pauseAds();
        return;
      }

      _currentAdIndex++;
      _pageController.animateToPage(
        _currentAdIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  void _pauseAds() {
    if (_adsPaused) return;

    setState(() => _adsPaused = true);
    _slideTimer?.cancel();
    _startAnnouncementRotation();

    _pauseTimer?.cancel();
    _pauseTimer = Timer(const Duration(minutes: 5), () {
      if (!mounted) return;

      setState(() => _adsPaused = false);
      _announcementTimer?.cancel();

      _pageController.jumpToPage(0);
      _startAds();
    });
  }

  /* ================= ANNOUNCEMENTS ================= */

  void _startAnnouncementRotation() {
    _announcementTimer?.cancel();

    _announcementTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_adsPaused) return;

      setState(() {
        _announcementIndex = (_announcementIndex + 1) % announcements.length;
      });
    });
  }

  /* ================= UI ================= */

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      height: _adsPaused ? 50 : 200,
      width: double.infinity,
      child: _adsPaused ? _creditsFooter() : _adsFooter(),
    );
  }

  /* ================= ADS VIEW ================= */

  Widget _adsFooter() {
    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ads.length,
          itemBuilder: (_, index) => _AdSlide(ad: ads[index]),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: GestureDetector(
            onTap: _pauseAds,
            child: const Icon(
              Icons.pause_circle_filled,
              color: Colors.white70,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  /* ================= CREDITS + ANNOUNCEMENTS ================= */

  Widget _creditsFooter() {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(color: Colors.white12, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Announcement icon
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.campaign_outlined,
              color: Colors.white70,
              size: 16,
            ),
          ),

          const SizedBox(width: 12),

          // Announcement text (rotating)
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Text(
                announcements[_announcementIndex],
                key: ValueKey(_announcementIndex),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Developer credit
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: const Text(
              'AMAPHISI',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= AD SLIDE ================= */

class _AdSlide extends StatelessWidget {
  final _AdItem ad;
  const _AdSlide({required this.ad});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        Image.asset(ad.image, fit: BoxFit.cover),

        // Dark gradient overlay (modern look)
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xCC000000),
                Color(0x66000000),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔥 TITLE
                    Text(
                      ad.title.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.4,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black87,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 6),

                    // ✨ SUBTITLE
                    Text(
                      ad.subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.6,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // CTA pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white24,
                        ),
                      ),
                      child: const Text(
                        'ADVERTISEMENT',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Developer credit (subtle)
              const RotatedBox(
                quarterTurns: 3,
                child: Text(
                  'AMAPHISI',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/* ================= MODEL ================= */

class _AdItem {
  final String image;
  final String title;
  final String subtitle;

  _AdItem({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}
