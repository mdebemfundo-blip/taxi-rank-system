import 'dart:async';
import 'dart:math';
import 'package:erank/services/api_service.dart';
import 'package:flutter/material.dart';

class AdvertRotator extends StatefulWidget {
  const AdvertRotator({super.key});
  @override
  State<AdvertRotator> createState() => _AdvertRotatorState();
}

class _AdvertRotatorState extends State<AdvertRotator> {
  // ignore: unused_field
  final Random _random = Random();
  List adverts = [];
  int index = 0;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    _loadAds();
  }

  Future<void> _loadAds() async {
    adverts = await ApiService.getAdverts();
    if (adverts.isNotEmpty) _startRotation();
    setState(() {});
  }

  void _startRotation() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 10), (_) {
      setState(() {
        index = (index + 1) % adverts.length;
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
    if (adverts.isEmpty) {
      return const SizedBox(height: 90);
    }
    return Container(
      height: 90,
      color: Colors.black,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 700),
        transitionBuilder: (child, animation) {
          final slide = Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation);
          return SlideTransition(
            position: slide,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: Image.network(
          adverts[index]["image_url"],
          key: ValueKey(adverts[index]["id"]),
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }
}
