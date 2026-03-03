import 'package:flutter/material.dart';

class Job {
  final String title;
  final double salary;
  final String icon;

  const Job({required this.title, required this.salary, required this.icon});
}

class GameGoal {
  final String title;
  final double cost;

  const GameGoal({required this.title, required this.cost});
}

class GameState with ChangeNotifier {
  double _money = 0;
  double _mood = 80;
  int _currentDay = 1;
  Job? _selectedJob;
  GameGoal? _selectedGoal;

  double get money => _money;
  double get mood => _mood;
  int get currentDay => _currentDay;
  Job? get selectedJob => _selectedJob;
  GameGoal? get selectedGoal => _selectedGoal;

  static final List<Job> availableJobs = [
    const Job(title: 'Курьер', salary: 35000, icon: '🚲'),
    const Job(title: 'Официант', salary: 45000, icon: '☕'),
  ];

  static final List<GameGoal> availableGoals = [
    const GameGoal(title: 'Смартфон', cost: 50000),
    const GameGoal(title: 'Консоль', cost: 70000),
  ];

  void setupGame(Job job, GameGoal goal) {
    _selectedJob = job;
    _selectedGoal = goal;
    _currentDay = 1;
    _money = job.salary; // Начисляем первую ЗП
    notifyListeners();
  }

  void nextTurn(int days) {
    _currentDay += days;
    // Ограничение по дням (до 30)
    if (_currentDay > 30) {
      _currentDay = 30;
    }
    notifyListeners();
  }

  void updateMoney(double amount) {
    _money += amount;
    notifyListeners();
  }

  void updateMood(double amount) {
    _mood += amount;
    if (_mood > 100) _mood = 100;
    if (_mood < 0) _mood = 0;
    notifyListeners();
  }
}
