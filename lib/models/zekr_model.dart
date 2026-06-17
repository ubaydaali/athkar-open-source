class ZekrCategory {
  final String id;
  final String title;
  final String icon;
  final String color;
  final List<ZekrItem> items;

  ZekrCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });

  factory ZekrCategory.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List;
    List<ZekrItem> itemsList = list.map((i) => ZekrItem.fromJson(i)).toList();

    return ZekrCategory(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      items: itemsList,
    );
  }
}

class ZekrItem {
  final String text;
  final int count;
  final String reward;

  ZekrItem({
    required this.text,
    required this.count,
    required this.reward,
  });

  factory ZekrItem.fromJson(Map<String, dynamic> json) {
    return ZekrItem(
      text: json['text'] as String,
      count: json['count'] as int,
      reward: json['reward'] as String,
    );
  }
}
