import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_tracker/business/providers/driver_provider.dart';
import 'package:trip_tracker/business/providers/trip_provider.dart';
import 'package:trip_tracker/business/providers/user_session.dart';
import 'package:trip_tracker/business/providers/vehicle_provider.dart';
import 'package:trip_tracker/ui/pages/all_users_page.dart';

import 'package:trip_tracker/ui/pages/driver_page.dart';
import 'package:trip_tracker/ui/pages/landing_page.dart';
import 'package:trip_tracker/ui/pages/profile_page.dart';
import 'package:trip_tracker/ui/pages/trips_page.dart';
import 'package:trip_tracker/ui/pages/vehicles_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

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
      child: _buildNavigation(),
    );
  }

  // 🟦 Navigation Pages (Admin vs User)
  Widget _buildNavigation() {
    final bool isAdmin = UserSession.isAdmin;

    final List<Widget> pages =
        isAdmin
            ? const [
              LandingPage(),
              VehiclesPage(),
              TripsPage(),
              DriversPage(),
              AllUsersPage(),
              ProfilePage(),
            ]
            : const [TripsPage(), ProfilePage()];

    final List<BottomNavigationBarItem> navItems =
        isAdmin
            ? const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: "Dashboard",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.directions_car),
                label: "Vehicles",
              ),
              BottomNavigationBarItem(icon: Icon(Icons.route), label: "Trips"),
              BottomNavigationBarItem(icon: Icon(Icons.work), label: "Drivers"),
              BottomNavigationBarItem(icon: Icon(Icons.people), label: "Users"),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              ),
            ]
            : const [
              BottomNavigationBarItem(icon: Icon(Icons.route), label: "Trips"),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              ),
            ];

    // 🔐 Prevent index crash if role changes
    if (_selectedIndex >= pages.length) _selectedIndex = 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: navItems,
      ),
    );
  }
}
