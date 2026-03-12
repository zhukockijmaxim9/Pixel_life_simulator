class MerchItem {
  final String name;
  final int price;
  final String icon;
  final String assetPath;

  const MerchItem({
    required this.name,
    required this.price,
    required this.icon,
    required this.assetPath,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'icon': icon,
        'assetPath': assetPath,
      };

  factory MerchItem.fromJson(Map<String, dynamic> json) => MerchItem(
        name: json['name'],
        price: json['price'],
        icon: json['icon'],
        assetPath: json['assetPath'],
      );
}
