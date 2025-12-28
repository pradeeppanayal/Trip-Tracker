import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trip_tracker/ui/pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCtjgvUaCVud76W6iMwtI-baePvyYDukG4",
      appId: "1:674587216708:android:95ae398ca9f54ebf45e511",
      messagingSenderId: "1234567890",
      projectId: "panayal-bus",
      storageBucket: "panayal-bus.firebasestorage.app",
    ),
  );
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Trip Tracker",
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const MainPage(), // <-- Navigator now exists ABOVE this widget
    );
  }
}
