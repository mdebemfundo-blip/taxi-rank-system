import 'dart:async';
import 'package:flutter/material.dart';

class AdsBottomSheet extends StatefulWidget {
  final bool visible;

  const AdsBottomSheet({super.key, required this.visible});

  @override
  State<AdsBottomSheet> createState() => _AdsBottomSheetState();
}

class _AdsBottomSheetState extends State<AdsBottomSheet> {
  final List<String> ads = [
    'assets/ads/ad1.jpg',
    'assets/ads/ad2.jpg',
	'assets/ads/ad3.jpg',
    'assets/ads/ad4.jpg',
  ];

  int index = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    if (widget.visible) {
      _startRotation();
    }
  }

  @override
  void didUpdateWidget(covariant AdsBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// ▶️ START ads when becoming visible
    if (widget.visible && !oldWidget.visible) {
      index = 0;
      _startRotation();
    }

    /// ⏹️ STOP ads when hidden
    if (!widget.visible && oldWidget.visible) {
      timer?.cancel();
      timer = null;
    }
  }

  void _startRotation() {
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;

      setState(() {
        index = (index + 1) % ads.length;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.2;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      left: 0,
      right: 0,
      bottom: widget.visible ? 0 : -height,
      height: height,
      child: Material(
        elevation: 20,
        child: Container(
          color: Colors.black,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            child: Image.asset(
              ads[index],
              key: ValueKey(index),
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}
