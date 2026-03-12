class Course {
  final String id;
  final String title;
  final double cost;
  final String icon;
  final String description;

  const Course({
    required this.id,
    required this.title,
    required this.cost,
    required this.icon,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'cost': cost,
        'icon': icon,
        'description': description,
      };

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json['id'],
        title: json['title'],
        cost: json['cost'].toDouble(),
        icon: json['icon'],
        description: json['description'],
      );
}
