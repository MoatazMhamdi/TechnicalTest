class Mission {
  final String name;
  final String description;
  final List<String> manufacturers;

  Mission({
    required this.name,
    required this.description,
    required this.manufacturers,
  });

  // Factory method to parse JSON into Mission object
  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      name: json['mission_name'],
      description: json['description'],
      manufacturers: List<String>.from(json['manufacturers']),
    );
  }

  // Method to convert Mission object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'mission_name': name,
      'description': description,
      'manufacturers': manufacturers,
    };
  }
}
