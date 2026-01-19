import 'dart:async';
import 'package:flutter/material.dart';

class SlidingAdFooter extends StatefulWidget {
  final double height;
  final double width;
  final List<String> adImages; // list of asset paths

  const SlidingAdFooter({
    super.key,
    required this.height,
    required this.width,
    required this.adImages,
  });

  @override
  State<SlidingAdFooter> createState() => _SlidingAdFooterState();
}

class _SlidingAdFooterState extends State<SlidingAdFooter> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    // start auto sliding
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (widget.adImages.isEmpty) return;

      _currentPage++;
      if (_currentPage >= widget.adImages.length) _currentPage = 0;

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.adImages.length,
        itemBuilder: (context, index) {
          return Image.asset(
            widget.adImages[index],
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
