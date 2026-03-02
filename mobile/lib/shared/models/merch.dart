import 'package:json_annotation/json_annotation.dart';

part 'merch.g.dart';

@JsonSerializable()
class Merch {
  final int id;
  final String name;
  final String? description;
  @JsonKey(name: 'price_bonus_points')
  final int priceBonusPoints;
  final int stock;

  Merch({
    required this.id,
    required this.name,
    this.description,
    required this.priceBonusPoints,
    required this.stock,
  });

  factory Merch.fromJson(Map<String, dynamic> json) => _$MerchFromJson(json);
  Map<String, dynamic> toJson() => _$MerchToJson(this);
}
