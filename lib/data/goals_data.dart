import '../models/goal.dart';

class GoalsData {
  static final List<GameGoal> availableGoals = [
    const GameGoal(
      title: 'Наушники',
      cost: 5000,
      pointsReward: 30,
      monthlyContribution: 5000,
    ),
    const GameGoal(
      title: 'Умные часы',
      cost: 7000,
      pointsReward: 45,
      monthlyContribution: 7000,
    ),
    const GameGoal(
      title: 'Планшет',
      cost: 12000,
      pointsReward: 90,
      monthlyContribution: 12000,
    ),
  ];
}
