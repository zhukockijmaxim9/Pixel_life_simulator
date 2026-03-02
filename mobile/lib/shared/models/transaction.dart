import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

@JsonSerializable()
class Transaction {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  final double amount;
  final String description;
  final String category;
  final DateTime timestamp;

  Transaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.description,
    required this.category,
    required this.timestamp,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
