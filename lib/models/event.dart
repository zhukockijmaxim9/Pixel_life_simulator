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

  Map<String, dynamic> toJson() => {
        'title': title,
        'amount': amount,
        'dueDate': dueDate,
      };

  factory PendingPayment.fromJson(Map<String, dynamic> json) => PendingPayment(
        title: json['title'],
        amount: json['amount'].toDouble(),
        dueDate: json['dueDate'],
      );
}

class PendingTransaction {
  final String title;
  final double amount;
  final AccountType primaryAccount;
  final double deficit;

  PendingTransaction({
    required this.title,
    required this.amount,
    required this.primaryAccount,
    required this.deficit,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'amount': amount,
        'primaryAccount': primaryAccount.index,
        'deficit': deficit,
      };

  factory PendingTransaction.fromJson(Map<String, dynamic> json) => PendingTransaction(
        title: json['title'],
        amount: json['amount'].toDouble(),
        primaryAccount: AccountType.values[json['primaryAccount']],
        deficit: json['deficit'].toDouble(),
      );
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'type': type.index,
        'moneyImpact': moneyImpact,
        'moodImpact': moodImpact,
        'options': options,
        'correctAnswerIndex': correctAnswerIndex,
        'educationalTip': educationalTip,
        'isPositive': isPositive,
      };

  factory GameEvent.fromJson(Map<String, dynamic> json) => GameEvent(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        type: EventType.values[json['type']],
        moneyImpact: json['moneyImpact'].toDouble(),
        moodImpact: json['moodImpact'].toDouble(),
        options: json['options'] != null ? List<String>.from(json['options']) : null,
        correctAnswerIndex: json['correctAnswerIndex'],
        educationalTip: json['educationalTip'],
        isPositive: json['isPositive'] ?? false,
      );
}
