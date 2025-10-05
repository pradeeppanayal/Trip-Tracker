class Trip {
  String? id;
  final String vehicleNumber;
  final String customer;
  final String tripName;
  final double km;
  final double total;
  final double diesel;
  final double driverCharge;
  final double otherExpense;
  final DateTime startDate;
  final DateTime endDate;
  final String driverName;
  final String comment;
  late double balance;
  Trip({
    this.id,
    required this.vehicleNumber,
    required this.customer,
    required this.tripName,
    required this.km,
    required this.total,
    required this.diesel,
    required this.driverCharge,
    required this.otherExpense,
    required this.startDate,
    required this.endDate,
    required this.driverName,
    required this.comment,
  });

  Map<String, dynamic> toMap() {
    return {
      'vehicleNumber': vehicleNumber,
      'customer': customer,
      'tripName': tripName,
      'km': km,
      'total': total,
      'diesel': diesel,
      'driverCharge': driverCharge,
      'otherExpense': otherExpense,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'driverName': driverName,
      'comment': comment,
    };
  }

  factory Trip.fromMap(Map<String, dynamic> map, String docId) {
    Trip trip = Trip(
      id: docId,
      vehicleNumber: map['vehicleNumber'] ?? '',
      customer: map['customer'] ?? '',
      tripName: map['tripName'] ?? '',
      km: (map['km'] ?? 0).toDouble(),
      total: (map['total'] ?? 0).toDouble(),
      diesel: (map['diesel'] ?? 0).toDouble(),
      driverCharge: (map['driverCharge'] ?? 0).toDouble(),
      otherExpense: (map['otherExpense'] ?? 0).toDouble(),
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      driverName: map['driverName'] ?? '',
      comment: map['comment'] ?? '',
    );
    trip.balance = calcBalance(trip);

    return trip;
  }
  static double calcBalance(Trip trip) {
    return trip.total - calcExpense(trip);
  }

  static double calcExpense(Trip trip) {
    return trip.otherExpense + trip.diesel + trip.driverCharge;
  }
}
