import 'enums.dart';

class PendingPayment {
  final String title;
  final double amount;
  int dueDate;

  PendingPayment({
    required this.title,
    required this.amount,
    required this.dueDate,
  });
}

class GameEvent {
  final String id;
  final String title;
  final String description;
  final EventType type;
  final double moneyImpact;
  final double moodImpact;
  final List<String>? options;
  final int? correctAnswerIndex;
  final String? educationalTip;
  final bool isPositive;

  const GameEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.moneyImpact = 0,
    this.moodImpact = 0,
    this.options,
    this.correctAnswerIndex,
    this.educationalTip,
    this.isPositive = false,
  });
}
