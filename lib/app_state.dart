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

enum MealType { economy, standard, luxury, skip }

class GameState with ChangeNotifier {
  static const double SALARY = 45000;
  static const double RENT = 18000;
  static const double MONTHLY_GOAL = 8000;

  // Financial accounts
  double _walletBalance = 0;
  double _emergencyFund = 0;
  double _savingsGoal = 0;

  double _mood = 80;
  int _currentDay = 1;
  int _currentMonth = 1;
  int _gamePoints = 0;

  int _daysSinceLastMeal = 0;
  int _mealThreshold = Random().nextInt(3) + 2; // Every 2-4 days
  bool _needsMeal = false;

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
  bool get needsMeal => _needsMeal;
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
    const Job(title: 'Мл. Разработчик', salary: 65000, icon: '💻'),
    const Job(title: 'Тестировщик', salary: 55000, icon: '🔍'),
  ];

  static final List<GameGoal> availableGoals = [
    const GameGoal(title: 'Смартфон', cost: 50000),
    const GameGoal(title: 'Консоль', cost: 70000),
    const GameGoal(title: 'Ноутбук', cost: 120000),
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
      moodImpact: -15,
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
      id: 'cinema_night',
      title: 'Поход в кино',
      description: 'Новый блокбастер вышел на экраны! Идем?',
      type: EventType.voluntary,
      moneyImpact: -1000,
      moodImpact: 10,
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
        'Снижает их покупательскую способность',
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
    _walletBalance = SALARY - RENT - MONTHLY_GOAL;
    _emergencyFund = 0;
    _savingsGoal = MONTHLY_GOAL;
    _mood = 80;
    _isGameOver = false;
    _isWin = false;
    _isPlanningPhase = false;
    _daysSinceLastMeal = 0;
    _mealThreshold = Random().nextInt(3) + 2;
    _eventHistory.clear();
    notifyListeners();
  }

  void startNewMonth() {
    if (_isWin) {
      _selectedJob = null; // Unlocks Tier 2 selection in PlanningScreen
    }
    _currentDay = 1;
    _currentMonth++;
    _walletBalance += (SALARY - RENT - MONTHLY_GOAL);
    _savingsGoal += MONTHLY_GOAL;
    _isPlanningPhase = false;
    _isGameOver = false;
    _isWin = false;
    _daysSinceLastMeal = 0;
    notifyListeners();
  }

  void nextTurn() {
    if (_isGameOver || _isPlanningPhase || _needsMeal) return;

    if (_daysSinceLastMeal >= _mealThreshold) {
      _needsMeal = true;
      notifyListeners();
      return;
    }

    int daysToAdd = Random().nextInt(4) + 1;
    _processTurn(daysToAdd);
  }

  void _processTurn(int days) {
    for (int i = 0; i < days; i++) {
      _currentDay++;
      _daysSinceLastMeal++;

      if (_currentDay > 30) {
        _currentDay = 30;
        _checkGameOver();
        break;
      }

      // Mood debuffs
      if (_mood < 40 && Random().nextDouble() < 0.2) {
        _applyFinancialImpact(-1000); // Fatigue Error
      }
      if (_mood <= 0) {
        _applyFinancialImpact(-4000); // Nervous Breakdown
        _mood = 40;
      }

      // Check if hunger is triggered during multi-day skip
      if (_daysSinceLastMeal >= _mealThreshold) {
        _needsMeal = true;
        break;
      }
    }

    // Try random event if not eating
    if (!_needsMeal && !_isGameOver && Random().nextDouble() < 0.3) {
      _triggerRandomEvent();
    }

    _validateStats();
    notifyListeners();
  }

  void chooseMeal(MealType type) {
    _needsMeal = false;
    _daysSinceLastMeal = 0;
    _mealThreshold = Random().nextInt(3) + 2;

    switch (type) {
      case MealType.economy:
        _applyFinancialImpact(-600);
        _mood -= 10;
        break;
      case MealType.standard:
        _applyFinancialImpact(-1500);
        _mood += 2;
        break;
      case MealType.luxury:
        _applyFinancialImpact(-3500);
        _mood += 15;
        break;
      case MealType.skip:
        _mood -= 25;
        _applyFinancialImpact(-2000); // Treatment
        break;
    }

    _validateStats();
    notifyListeners();
  }

  bool canTriggerEvent(String eventId) {
    if (!_eventHistory.containsKey(eventId)) return true;

    // Cooldown check: 2 months gap for breakdown/repair events
    if (eventId.contains('repair') || eventId.contains('broken')) {
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
    // Total goal check
    if (_walletBalance + _savingsGoal < MONTHLY_GOAL * _currentMonth) {
      _isGameOver = true;
      _isWin = false;
    } else {
      _isGameOver = true;
      _isWin = true;
    }
  }

  // Handle choice with priority and mood logic
  void handleEventChoice(bool accepted) {
    if (_currentEvent == null) return;

    double moneyCost = _currentEvent!.moneyImpact;
    double moodImpact = _currentEvent!.moodImpact;

    if (_currentEvent!.type == EventType.voluntary) {
      if (accepted) {
        _applyFinancialImpact(moneyCost);
        _mood += moodImpact;
      } else {
        // Penalty for refusing social events is now higher (-15)
        _mood -= 15;
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

    // Priority 1: Emergency Fund
    if (_emergencyFund >= cost) {
      _emergencyFund -= cost;
      return;
    } else {
      cost -= _emergencyFund;
      _emergencyFund = 0;
    }

    // Priority 2: Wallet
    if (_walletBalance >= cost) {
      _walletBalance -= cost;
      return;
    } else {
      cost -= _walletBalance;
      _walletBalance = 0;
    }

    // Priority 3: Savings (allowed for mandatory/debuffs)
    if (_savingsGoal >= cost) {
      _savingsGoal -= cost;
      return;
    } else {
      cost -= _savingsGoal;
      _savingsGoal = 0;
    }

    // If still cost > 0, Financial Crash!
    if (cost > 0) {
      _isGameOver = true;
      _isWin = false;
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
