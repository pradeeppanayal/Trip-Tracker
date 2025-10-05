class Driver {
  final String? id;
  final String name;
  final String contact;
  final String comment;

  Driver({
    this.id,
    required this.name,
    required this.contact,
    required this.comment,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'contact': contact, 'comment': comment};
  }

  factory Driver.fromMap(Map<String, dynamic> map) {
    return Driver(
      id: map['id'],
      name: map['name'] ?? '',
      contact: map['contact'] ?? '',
      comment: map['comment'] ?? '',
    );
  }
}
