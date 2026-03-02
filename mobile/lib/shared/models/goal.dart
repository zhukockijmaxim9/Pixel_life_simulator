import 'package:json_annotation/json_annotation.dart';

part 'goal.g.dart';

@JsonSerializable()
class Goal {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  final String name;
  @JsonKey(name: 'target_amount')
  final double targetAmount;
  @JsonKey(name: 'current_amount')
  final double currentAmount;
  @JsonKey(name: 'due_date')
  final DateTime? dueDate;

  Goal({
    required this.id,
    required this.userId,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    this.dueDate,
  });

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);
  Map<String, dynamic> toJson() => _$GoalToJson(this);
}
