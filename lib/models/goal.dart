class GameGoal {
  final String title;
  final double cost;
  final int pointsReward;
  final double monthlyContribution;
  final String icon;

  const GameGoal({
    required this.title,
    required this.cost,
    required this.pointsReward,
    required this.monthlyContribution,
    required this.icon,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'cost': cost,
        'pointsReward': pointsReward,
        'monthlyContribution': monthlyContribution,
        'icon': icon,
      };

  factory GameGoal.fromJson(Map<String, dynamic> json) => GameGoal(
        title: json['title'],
        cost: json['cost'].toDouble(),
        pointsReward: json['pointsReward'],
        monthlyContribution: json['monthlyContribution'].toDouble(),
        icon: json['icon'] ?? '🎯',
      );
}
