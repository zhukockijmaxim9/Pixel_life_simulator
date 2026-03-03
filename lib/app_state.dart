import 'dart:math';
import 'package:flutter/material.dart';

enum EventType { random, voluntary, quiz }

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
  // Financial accounts
  double _walletBalance = 0;
  double _emergencyFund = 0;
  double _savingsGoal = 0;

  double _mood = 80;
  int _currentDay = 1;
  int _currentMonth = 1;
  int _gamePoints = 0;

  Job? _selectedJob;
  GameGoal? _selectedGoal;
  GameEvent? _currentEvent;

  bool _isGameOver = false;
  bool _isWin = false;
  bool _isPlanningPhase = false;

  final List<MerchItem> _inventory = [];
  final Map<String, int> _eventHistory = {};

  // Getters
  double get walletBalance => _walletBalance;
  double get emergencyFund => _emergencyFund;
  double get savingsGoal => _savingsGoal;
  double get totalMoney => _walletBalance + _emergencyFund + _savingsGoal;

  double get mood => _mood;
  int get currentDay => _currentDay;
  int get currentMonth => _currentMonth;
  int get gamePoints => _gamePoints;
  Job? get selectedJob => _selectedJob;
  GameGoal? get selectedGoal => _selectedGoal;
  GameEvent? get currentEvent => _currentEvent;
  bool get isGameOver => _isGameOver;
  bool get isWin => _isWin;
  bool get isPlanningPhase => _isPlanningPhase;
  List<MerchItem> get inventory => List.unmodifiable(_inventory);

  void setJob(Job job) {
    _selectedJob = job;
    notifyListeners();
  }

  void setGoal(GameGoal goal) {
    _selectedGoal = goal;
    notifyListeners();
  }

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
      id: 'phone_repair',
      title: 'Сломался экран телефона',
      description:
          'Неудачное падение! Экран вдребезги. Придется раскошелиться на ремонт.',
      type: EventType.random,
      moneyImpact: -5000,
      moodImpact: -10,
    ),
    const GameEvent(
      id: 'pizza_friends',
      title: 'Друзья зовут в пиццерию',
      description:
          'Отличный вечер с друзьями поможет расслабиться, но стоит денег.',
      type: EventType.voluntary,
      moneyImpact: -1500,
      moodImpact: 15,
    ),
    const GameEvent(
      id: 'quiz_safe_cushion',
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
      id: 'found_money',
      title: 'Нашел 500 рублей',
      description: 'Мелочь, а приятно! Деньги валялись прямо на тротуаре.',
      type: EventType.random,
      moneyImpact: 500,
      moodImpact: 5,
    ),
    const GameEvent(
      id: 'quiz_inflation',
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
    _currentMonth = 1;
    _walletBalance = 0;
    _emergencyFund = 0;
    _savingsGoal = 0;
    _mood = 80;
    _isGameOver = false;
    _isWin = false;
    _currentEvent = null;
    _isPlanningPhase = true;
    _eventHistory.clear();

    // Initial budget distribution setup (e.g. 1st salary)
    _startMonthLogic(job.salary, 5000); // Assume 5000 basic expenses
    notifyListeners();
  }

  void _startMonthLogic(double salary, double expenses) {
    // 1. Deduct expenses from wallet (or other accounts if needed)
    _walletBalance -= expenses;
    // 2. Add salary to wallet for distribution
    _walletBalance += salary;
    // 3. Mark planning phase
    _isPlanningPhase = true;
  }

  void startNewMonth(double salary, double expenses) {
    _currentDay = 1;
    _currentMonth++;
    _startMonthLogic(salary, expenses);
    notifyListeners();
  }

  void distributeBudget({
    required double toWallet,
    required double toEmergency,
    required double toSavings,
  }) {
    // We assume the player distributes what is in the wallet after startMonthLogic
    _walletBalance = toWallet;
    _emergencyFund += toEmergency;
    _savingsGoal += toSavings;
    _isPlanningPhase = false;
    notifyListeners();
  }

  void nextTurn() {
    if (_isGameOver || _isPlanningPhase) return;

    // Advanced time: 1-5 random days
    int daysToAdd = Random().nextInt(5) + 1;
    _currentDay += daysToAdd;

    if (_currentDay >= 30) {
      _currentDay = 30;
      _checkGameOver();
    } else {
      // Chance of event 70%
      if (Random().nextDouble() < 0.7) {
        _triggerRandomEvent();
      }
    }
    notifyListeners();
  }

  bool canTriggerEvent(String eventId) {
    if (!_eventHistory.containsKey(eventId)) return true;
    // "Breakdown" events ID naming convention or specific check
    if (eventId.contains('repair')) {
      return (_currentMonth - _eventHistory[eventId]!) >= 2;
    }
    return true;
  }

  void _triggerRandomEvent() {
    List<GameEvent> eligibleEvents = allEvents
        .where((e) => canTriggerEvent(e.id))
        .toList();
    if (eligibleEvents.isNotEmpty) {
      _currentEvent = eligibleEvents[Random().nextInt(eligibleEvents.length)];
      _eventHistory[_currentEvent!.id] = _currentMonth;
    }
  }

  void _checkGameOver() {
    _isGameOver = true;
    if (_selectedGoal != null && _savingsGoal >= _selectedGoal!.cost) {
      _isWin = true;
    } else {
      _isWin = false;
    }
  }

  // Handle choice with mood logic
  void handleEventChoice(bool accepted) {
    if (_currentEvent == null) return;

    double moneyCost = _currentEvent!.moneyImpact;
    double moodImpact = _currentEvent!.moodImpact;

    if (_currentEvent!.type == EventType.voluntary) {
      if (accepted) {
        _applyFinancialImpact(moneyCost);
        _mood += moodImpact;
      } else {
        // Penalty for skipping rest/social
        _mood -= (moodImpact > 0 ? moodImpact : 10);
      }
    } else if (_currentEvent!.type == EventType.random) {
      _applyFinancialImpact(moneyCost);
      _mood += moodImpact;
    }

    _currentEvent = null;
    _validateStats();
    notifyListeners();
  }

  void _applyFinancialImpact(double amount) {
    // amount is negative for costs
    if (amount >= 0) {
      _walletBalance += amount;
      return;
    }

    double cost = amount.abs();
    if (_walletBalance >= cost) {
      _walletBalance -= cost;
    } else {
      // Auto-withdraw from emergency fund
      double remaining = cost - _walletBalance;
      _walletBalance = 0;
      _emergencyFund -= remaining;
    }
  }

  void resolveEvent(bool accepted, {int? quizAnswerIndex}) {
    if (_currentEvent == null) return;

    if (_currentEvent!.type == EventType.quiz) {
      if (quizAnswerIndex == _currentEvent!.correctAnswerIndex) {
        _walletBalance += _currentEvent!.moneyImpact;
        _gamePoints += 100;
        _mood += 10;
      } else {
        _mood -= 10;
      }
      _currentEvent = null;
    } else {
      handleEventChoice(accepted);
    }
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

  void _validateStats() {
    if (_mood > 100) _mood = 100;
    if (_mood < 0) _mood = 0;
  }

  void updateWallet(double amount) {
    _walletBalance += amount;
    notifyListeners();
  }

  void updateMood(double amount) {
    _mood += amount;
    _validateStats();
    notifyListeners();
  }
}
