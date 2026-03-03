import 'dart:math';
import 'package:flutter/material.dart';

enum EventType { random, voluntary, quiz }

class GameEvent {
  final String title;
  final String description;
  final EventType type;
  final double moneyImpact;
  final double moodImpact;
  final List<String>? options;
  final int? correctAnswerIndex;
  final String? educationalTip;

  const GameEvent({
    required this.title,
    required this.description,
    required this.type,
    this.moneyImpact = 0,
    this.moodImpact = 0,
    this.options,
    this.correctAnswerIndex,
    this.educationalTip,
  });
}

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

class MerchItem {
  final String name;
  final int price;
  final String icon;

  const MerchItem({
    required this.name,
    required this.price,
    required this.icon,
  });
}

class GameState with ChangeNotifier {
  double _money = 0;
  double _mood = 80;
  int _currentDay = 1;
  int _gamePoints = 0;
  Job? _selectedJob;
  GameGoal? _selectedGoal;
  GameEvent? _currentEvent;
  bool _isGameOver = false;
  bool _isWin = false;
  final List<MerchItem> _inventory = [];

  double get money => _money;
  double get mood => _mood;
  int get currentDay => _currentDay;
  int get gamePoints => _gamePoints;
  Job? get selectedJob => _selectedJob;
  GameGoal? get selectedGoal => _selectedGoal;
  GameEvent? get currentEvent => _currentEvent;
  bool get isGameOver => _isGameOver;
  bool get isWin => _isWin;
  List<MerchItem> get inventory => List.unmodifiable(_inventory);

  static final List<Job> availableJobs = [
    const Job(title: 'Курьер', salary: 35000, icon: '🚲'),
    const Job(title: 'Официант', salary: 45000, icon: '☕'),
  ];

  static final List<GameGoal> availableGoals = [
    const GameGoal(title: 'Смартфон', cost: 50000),
    const GameGoal(title: 'Консоль', cost: 70000),
  ];

  static final List<MerchItem> shopItems = [
    const MerchItem(name: 'Худи Neoflex', price: 500, icon: '🧥'),
    const MerchItem(name: 'Кепка', price: 200, icon: '🧢'),
    const MerchItem(name: 'Кружка', price: 100, icon: '☕'),
  ];

  static final List<GameEvent> allEvents = [
    const GameEvent(
      title: 'Сломался экран телефона',
      description:
          'Неудачное падение! Экран вдребезги. Придется раскошелиться на ремонт.',
      type: EventType.random,
      moneyImpact: -5000,
      moodImpact: -10,
    ),
    const GameEvent(
      title: 'Друзья зовут в пиццерию',
      description:
          'Отличный вечер с друзьями поможет расслабиться, но стоит денег.',
      type: EventType.voluntary,
      moneyImpact: -1500,
      moodImpact: 15,
    ),
    const GameEvent(
      title: 'Квиз от Неофлекс',
      description: 'Что такое финансовая подушка безопасности?',
      type: EventType.quiz,
      options: [
        'Деньги на новый iPhone',
        'Запас денег на 3-6 месяцев жизни',
        'Кредитная карта с лимитом',
        'Мягкая подушка с купюрами',
      ],
      correctAnswerIndex: 1,
      moneyImpact: 2000,
      educationalTip:
          'Финансовая подушка — это резерв на случай потери дохода.',
    ),
    const GameEvent(
      title: 'Нашел 500 рублей',
      description: 'Мелочь, а приятно! Деньги валялись прямо на тротуаре.',
      type: EventType.random,
      moneyImpact: 500,
      moodImpact: 5,
    ),
    const GameEvent(
      title: 'Квиз: Инфляция',
      description: 'Как инфляция влияет на ваши сбережения?',
      type: EventType.quiz,
      options: [
        'Увеличивает их стоимость',
        'Снижает их покупательную способность',
        'Никак не влияет',
        'Делает цены ниже',
      ],
      correctAnswerIndex: 1,
      moneyImpact: 2000,
      educationalTip: 'Инфляция — это процесс обесценивания денег.',
    ),
  ];

  void setupGame(Job job, GameGoal goal) {
    _selectedJob = job;
    _selectedGoal = goal;
    _currentDay = 1;
    _money = job.salary;
    _mood = 80;
    _isGameOver = false;
    _isWin = false;
    _currentEvent = null;
    notifyListeners();
  }

  void nextTurn(int days) {
    if (_isGameOver) return;

    _currentDay += days;

    if (_currentDay >= 30) {
      _currentDay = 30;
      _checkGameOver();
    } else {
      if (Random().nextDouble() < 0.7) {
        _currentEvent = allEvents[Random().nextInt(allEvents.length)];
      }
    }
    notifyListeners();
  }

  void _checkGameOver() {
    _isGameOver = true;
    if (_selectedGoal != null && _money >= _selectedGoal!.cost) {
      _isWin = true;
    } else {
      _isWin = false;
    }
  }

  void resolveEvent(bool accepted, {int? quizAnswerIndex}) {
    if (_currentEvent == null) return;

    if (_currentEvent!.type == EventType.random) {
      _money += _currentEvent!.moneyImpact;
      _mood += _currentEvent!.moodImpact;
    } else if (_currentEvent!.type == EventType.voluntary && accepted) {
      _money += _currentEvent!.moneyImpact;
      _mood += _currentEvent!.moodImpact;
    } else if (_currentEvent!.type == EventType.quiz) {
      if (quizAnswerIndex == _currentEvent!.correctAnswerIndex) {
        _money += _currentEvent!.moneyImpact;
        _gamePoints += 100; // Reward points for correct quiz answer
        _mood += 10;
      } else {
        _mood -= 10;
      }
    }

    _currentEvent = null;
    _validateStats();
    notifyListeners();
  }

  void buyItem(MerchItem item) {
    if (_gamePoints >= item.price) {
      _gamePoints -= item.price;
      _inventory.add(item);
      notifyListeners();
    }
  }

  void startNewMonth() {
    if (_selectedJob != null && _selectedGoal != null) {
      _currentDay = 1;
      _money = _selectedJob!.salary;
      _mood = 80;
      _isGameOver = false;
      _isWin = false;
      _currentEvent = null;
      notifyListeners();
    }
  }

  void _validateStats() {
    if (_mood > 100) _mood = 100;
    if (_mood < 0) _mood = 0;
  }

  void updateMoney(double amount) {
    _money += amount;
    notifyListeners();
  }

  void updateMood(double amount) {
    _mood += amount;
    _validateStats();
    notifyListeners();
  }
}
