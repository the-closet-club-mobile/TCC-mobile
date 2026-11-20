class Clothing {
  final int id;
  final String name;
  final String? photo;
  final String size;
  final String sizeDisplay;
  final String condition;
  final String conditionDisplay;
  final String description;
  final String status;
  final String statusDisplay;
  final String owner;
  final DateTime createdAt;

  const Clothing({
    required this.id,
    required this.name,
    this.photo,
    required this.size,
    required this.sizeDisplay,
    required this.condition,
    required this.conditionDisplay,
    required this.description,
    required this.status,
    required this.statusDisplay,
    required this.owner,
    required this.createdAt,
  });

  factory Clothing.fromJson(Map<String, dynamic> json) => Clothing(
        id: json['id'] as int,
        name: json['name'] as String,
        photo: json['photo'] as String?,
        size: json['size'] as String,
        sizeDisplay: json['size_display'] as String? ?? '',
        condition: json['condition'] as String,
        conditionDisplay: json['condition_display'] as String? ?? '',
        description: json['description'] as String? ?? '',
        status: json['status'] as String,
        statusDisplay: json['status_display'] as String? ?? '',
        owner: json['owner'] as String? ?? '',
        createdAt: DateTime.parse(json['created_at'] as String),
      );
}
