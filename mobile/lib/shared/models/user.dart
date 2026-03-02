import 'package:json_annotation/json_annotation.dart';

import 'job.dart';
import 'transaction.dart';
import 'goal.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final int id;
  final String username;
  final String email;
  final double balance;
  @JsonKey(name: 'credit_score')
  final int creditScore;
  @JsonKey(name: 'bonus_points')
  final int bonusPoints;
  final Job? job;
  final List<Transaction> transactions;
  final List<Goal> goals;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.balance,
    required this.creditScore,
    required this.bonusPoints,
    this.job,
    required this.transactions,
    required this.goals,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
