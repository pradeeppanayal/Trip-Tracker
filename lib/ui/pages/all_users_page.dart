// lib/ui/pages/all_users_page.dart
import 'package:flutter/material.dart';
import 'package:trip_tracker/business/services/user_service.dart';

class AllUsersPage extends StatefulWidget {
  const AllUsersPage({super.key});

  @override
  State<AllUsersPage> createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  bool loading = true;
  List<Map<String, dynamic>> users = [];
  String? error;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      final data = await UserService.getAllUsers();
      setState(() {
        users = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Users")),
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : error != null
              ? Center(
                child: Text(error!, style: const TextStyle(color: Colors.red)),
              )
              : ListView.builder(
                itemCount: users.length,
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, i) {
                  final user = users[i];
                  final vehicles = user["allowedVehicleNumbers"] ?? [];
                  final email = user["email"] ?? "No email";
                  final role = user["role"] ?? "No role";

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(15),
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(
                        email,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Role: $role"),
                          role == 'admin'
                              ? Text("All")
                              : vehicles is List && vehicles.isNotEmpty
                              ? Text("Vehicles: ${vehicles.join(", ")}")
                              : const Text("Vehicles: None assigned"),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
