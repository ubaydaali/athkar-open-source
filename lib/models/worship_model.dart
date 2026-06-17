class Worship {
  final String id;
  final String title;
  final String icon;
  final String color;
  final String description;
  final String importance;
  final List<String> details;

  Worship({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
    required this.importance,
    required this.details,
  });

  factory Worship.fromJson(Map<String, dynamic> json) {
    var detailsList = List<String>.from(json['details'] as List);

    return Worship(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      description: json['description'] as String,
      importance: json['importance'] as String,
      details: detailsList,
    );
  }
}
