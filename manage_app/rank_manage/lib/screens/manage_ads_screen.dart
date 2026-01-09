import 'package:flutter/material.dart';
import '../models/advert_model.dart';

class ManageAdsScreen extends StatefulWidget {
  const ManageAdsScreen({super.key});

  @override
  State<ManageAdsScreen> createState() => _ManageAdsScreenState();
}

class _ManageAdsScreenState extends State<ManageAdsScreen> {
  final adverts = [
    Advert(image: 'assets/ads/ad_1.png'),
    Advert(image: 'assets/ads/ad_2.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Adverts")),
      body: ListView.builder(
        itemCount: adverts.length,
        itemBuilder: (_, i) {
          final ad = adverts[i];
          return SwitchListTile(
            title: Text(ad.image),
            value: ad.active,
            onChanged: (v) {
              setState(() => ad.active = v);
            },
          );
        },
      ),
    );
  }
}
