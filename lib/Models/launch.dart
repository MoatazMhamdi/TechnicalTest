class Launch {
  final String name;
  final DateTime date;
  final String? details; // Nullable if not always provided by API
  final String? rocketId; // Example of additional field from API

  Launch({
    required this.name,
    required this.date,
    this.details,
    this.rocketId,
  });

  // Factory method to parse JSON into Launch object
  factory Launch.fromJson(Map<String, dynamic> json) {
    return Launch(
      name: json['mission_name'],
      date: DateTime.parse(json['launch_date_utc']),
      details: json['details'],
      rocketId: json['rocket']['rocket_id'], // Nested JSON field
    );
  }

  // Method to convert Launch object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'mission_name': name,
      'launch_date_utc': date.toIso8601String(),
      'details': details,
      'rocket': {'rocket_id': rocketId},
    };
  }
}
