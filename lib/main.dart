import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trip_tracker/business/providers/driver_provider.dart';
import 'package:trip_tracker/ui/pages/driver_page.dart';

import 'ui/pages/landing_page.dart';
import 'ui/pages/vehicles_page.dart';
import 'ui/pages/trips_page.dart';
import 'business/providers/vehicle_provider.dart';
import 'business/providers/trip_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
  );
  runApp(const VehicleTrackerApp());
}

class VehicleTrackerApp extends StatefulWidget {
  const VehicleTrackerApp({super.key});

  @override
  State<VehicleTrackerApp> createState() => _VehicleTrackerAppState();
}

class _VehicleTrackerAppState extends State<VehicleTrackerApp> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => VehicleProvider()..loadVehicles(),
        ),
        ChangeNotifierProvider(create: (_) => TripProvider()),
        ChangeNotifierProvider(create: (_) => DriverProvider()..loadDrivers()),
      ],
      child: MaterialApp(
        title: 'Vehicle Tracker',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Builder(
          builder: (context) {
            // Pages can access providers after build
            final pages = [
              const LandingPage(),
              const VehiclesPage(),
              const TripsPage(),
              const DriversPage(),
            ];

            return Scaffold(
              body: pages[_selectedIndex],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                type: BottomNavigationBarType.fixed, // keeps labels visible
                backgroundColor: Colors.white, // 👈 background white
                selectedItemColor: Colors.blue, // 👈 selected icon/text color
                unselectedItemColor:
                    Colors.grey, // 👈 unselected icon/text color
                showUnselectedLabels: true, // 👈 ensures text shows for all
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard),
                    label: "Dashboard",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.directions_car),
                    label: "Vehicles",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.route),
                    label: "Trips",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people),
                    label: "Drivers",
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
