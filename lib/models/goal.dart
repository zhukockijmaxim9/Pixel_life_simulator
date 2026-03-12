class GameGoal {
  final String title;
  final double cost;
  final int pointsReward;
  final double monthlyContribution;

  const GameGoal({
    required this.title,
    required this.cost,
    required this.pointsReward,
    required this.monthlyContribution,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'cost': cost,
        'pointsReward': pointsReward,
        'monthlyContribution': monthlyContribution,
      };

  factory GameGoal.fromJson(Map<String, dynamic> json) => GameGoal(
        title: json['title'],
        cost: json['cost'].toDouble(),
        pointsReward: json['pointsReward'],
        monthlyContribution: json['monthlyContribution'].toDouble(),
      );
}
