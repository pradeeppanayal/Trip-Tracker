class Vehicle {
  String? id;
  final String name;
  final String number;

  Vehicle({this.id, required this.name, required this.number});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name.toUpperCase(),
      'number': number.toUpperCase(),
    };
  }

  factory Vehicle.fromMap(Map<String, dynamic> map, String id) {
    return Vehicle(id: id, name: map['name'], number: map['number']);
  }
}
