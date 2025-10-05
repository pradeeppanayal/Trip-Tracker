import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../business/providers/driver_provider.dart';
import '../../models/driver.dart';

class DriversPage extends StatefulWidget {
  const DriversPage({super.key});

  @override
  State<DriversPage> createState() => _DriversPageState();
}

class _DriversPageState extends State<DriversPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<DriverProvider>(context, listen: false).loadDrivers();
  }

  void _showDriverForm(BuildContext context, [Driver? driver]) {
    final nameController = TextEditingController(text: driver?.name ?? "");
    final contactController = TextEditingController(
      text: driver?.contact ?? "",
    );
    final commentController = TextEditingController(
      text: driver?.comment ?? "",
    );

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(driver == null ? "Add Driver" : "Edit Driver"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: contactController,
                  decoration: const InputDecoration(labelText: "Contact"),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: commentController,
                  decoration: const InputDecoration(labelText: "Comment"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  String status = "";
                  if (driver == null) {
                    status = await Provider.of<DriverProvider>(
                      context,
                      listen: false,
                    ).addDriver(
                      Driver(
                        name: nameController.text,
                        contact: contactController.text,
                        comment: commentController.text,
                      ),
                    );
                  } else {
                    status = await Provider.of<DriverProvider>(
                      context,
                      listen: false,
                    ).updateDriver(
                      Driver(
                        id: driver.id,
                        name: nameController.text,
                        contact: contactController.text,
                        comment: commentController.text,
                      ),
                    );
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(status)));

                  if (status.contains("successfully")) Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DriverProvider>(
      builder: (context, provider, child) {
        final drivers = provider.drivers;

        return Scaffold(
          appBar: AppBar(title: const Text("Drivers")),
          body:
              drivers.isEmpty
                  ? const Center(
                    child: Text(
                      "No drivers available",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                  : ListView.builder(
                    itemCount: drivers.length,
                    itemBuilder: (context, index) {
                      final driver = drivers[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            title: Text(
                              driver.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(driver.contact),
                                if (driver.comment.isNotEmpty)
                                  Text(driver.comment),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showDriverForm(context, driver),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => _showDriverForm(context),
          ),
        );
      },
    );
  }
}
