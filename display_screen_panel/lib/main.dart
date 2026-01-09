import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/departure_board_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // must not be null
  );
  runApp(const TaxiRankApp());
}

class TaxiRankApp extends StatelessWidget {
  const TaxiRankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ngiyahamba Nami',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const DepartureBoardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
