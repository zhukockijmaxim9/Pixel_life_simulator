import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';

enum EventType { random, voluntary, quiz, rent, course }

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
  final bool isPositive; // for mood-based balancing

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

class Job {
  final String title;
  final double salary;
  final String icon;
  final int tier;
  final String? requiredCourse;
  final List<String> requiredPreviousJobs;

  const Job({
    required this.title,
    required this.salary,
    required this.icon,
    this.tier = 1,
    this.requiredCourse,
    this.requiredPreviousJobs = const [],
  });
}

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
  static const double RENT = 5000;
  static const double MONTHLY_GOAL = 8000;

  // Dynamic salary based on selected job
  double get salary => _selectedJob?.salary ?? 30000;

  // Financial accounts
  double _walletBalance = 0;
  double _emergencyFund = 0;
  double _mandatoryBalance = 0;
  double _savingsGoal = 0;

  double _mood = 80;
  int _currentDay = 1;
  int _currentMonth = 1;
  int _gamePoints = 0;

  // Budget distribution (percentages)
  int _walletPercentage = 40;
  int _emergencyPercentage = 30;
  int _mandatoryPercentage = 30;

  int _daysSinceLastMeal = 0;
  int _mealThreshold = Random().nextInt(3) + 2;
  bool _needsMeal = false;
  bool _rentPaid = false;
  bool _coursesOffered = false; // day 15 course event fired this month

  final StreamController<String> _notificationController =
      StreamController<String>.broadcast();
  Stream<String> get notifications => _notificationController.stream;

  Job? _selectedJob;
  GameGoal? _selectedGoal;
  GameEvent? _currentEvent;
  bool _isGameOver = false;
  bool _isWin = false;
  bool _isPlanningPhase = false;
  final List<MerchItem> _inventory = [];

  // Career progression
  List<String> _completedCourses = [];
  List<String> _jobHistory = [];

  final Map<String, int> _eventHistory = {};

  // Getters
  double get walletBalance => _walletBalance;
  double get emergencyFund => _emergencyFund;
  double get mandatoryBalance => _mandatoryBalance;
  double get savingsGoal => _savingsGoal;
  double get totalMoney =>
      _walletBalance + _emergencyFund + _mandatoryBalance + _savingsGoal;

  double get foodBudget => _walletBalance + _mandatoryBalance;

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
  int get daysToHunger => _mealThreshold - _daysSinceLastMeal;
  List<MerchItem> get inventory => List.unmodifiable(_inventory);
  List<String> get completedCourses => List.unmodifiable(_completedCourses);
  List<String> get jobHistory => List.unmodifiable(_jobHistory);

  int get walletPercentage => _walletPercentage;
  int get emergencyPercentage => _emergencyPercentage;
  int get mandatoryPercentage => _mandatoryPercentage;
  int get goalPercentage =>
      100 - _walletPercentage - _emergencyPercentage - _mandatoryPercentage;

  void setGoal(GameGoal goal) {
    _selectedGoal = goal;
    notifyListeners();
  }

  // ===== JOBS =====
  static final List<Job> tier1Jobs = [
    const Job(title: 'Доставщик', salary: 30000, icon: '🚲', tier: 1),
    const Job(title: 'Кассир', salary: 28000, icon: '🏪', tier: 1),
    const Job(title: 'Работник фастфуда', salary: 27000, icon: '🍔', tier: 1),
    const Job(title: 'Работник ПВЗ', salary: 29000, icon: '📦', tier: 1),
  ];

  static final List<Job> tier2Jobs = [
    const Job(
      title: 'Официант',
      salary: 38000,
      icon: '☕',
      tier: 2,
      requiredPreviousJobs: ['Работник фастфуда'],
    ),
    const Job(
      title: 'Механик',
      salary: 40000,
      icon: '🔧',
      tier: 2,
      requiredPreviousJobs: ['Доставщик'],
    ),
    const Job(
      title: 'Продавец-консультант',
      salary: 35000,
      icon: '🛍️',
      tier: 2,
      requiredPreviousJobs: ['Кассир', 'Работник ПВЗ'],
    ),
    const Job(
      title: 'Бариста',
      salary: 42000,
      icon: '☕',
      tier: 2,
      requiredCourse: 'Бариста',
    ),
    const Job(
      title: 'Бухгалтер',
      salary: 50000,
      icon: '�',
      tier: 2,
      requiredCourse: 'Бухгалтер',
    ),
  ];

  List<Job> getAvailableJobsForMonth() {
    if (_currentMonth <= 1) {
      return tier1Jobs;
    }
    List<Job> available = [...tier1Jobs];
    for (var job in tier2Jobs) {
      // Course-based jobs
      if (job.requiredCourse != null) {
        if (_completedCourses.contains(job.requiredCourse)) {
          available.add(job);
        }
        continue;
      }
      // Experience-based jobs
      if (job.requiredPreviousJobs.isNotEmpty) {
        bool hasExp = job.requiredPreviousJobs.any(
          (prev) => _jobHistory.contains(prev),
        );
        if (hasExp) {
          available.add(job);
        }
      }
    }
    return available;
  }

  // Keep backward compat - used in job_selection_screen
  static List<Job> get availableJobs => tier1Jobs;

  static final List<GameGoal> availableGoals = [
    const GameGoal(
      title: 'Смартфон',
      cost: 50000,
      pointsReward: 500,
      monthlyContribution: 5000,
    ),
    const GameGoal(
      title: 'Консоль',
      cost: 70000,
      pointsReward: 750,
      monthlyContribution: 7000,
    ),
    const GameGoal(
      title: 'Ноутбук',
      cost: 120000,
      pointsReward: 1500,
      monthlyContribution: 10000,
    ),
  ];

  static final List<MerchItem> shopItems = [
    const MerchItem(name: 'Худи Neoflex', price: 500, icon: '🧥'),
    const MerchItem(name: 'Кепка', price: 200, icon: '🧢'),
    const MerchItem(name: 'Кружка', price: 100, icon: '☕'),
  ];

  // ===== EVENTS =====
  static final List<GameEvent> allEvents = [
    // Negative random events
    const GameEvent(
      id: 'phone_repair',
      title: 'Сломался экран телефона',
      description:
          'Неудачное падение! Экран вдребезги. Придется раскошелиться на ремонт.',
      type: EventType.random,
      moneyImpact: -5000,
      moodImpact: -15,
      isPositive: false,
    ),
    const GameEvent(
      id: 'lost_transport',
      title: 'Опоздал на транспорт',
      description: 'Автобус ушёл прямо из-под носа. Пришлось брать такси.',
      type: EventType.random,
      moneyImpact: -300,
      moodImpact: -5,
      isPositive: false,
    ),
    const GameEvent(
      id: 'wallet_lost',
      title: 'Потерял кошелёк',
      description: 'Кошелёк выпал из кармана в толпе. Деньги не вернуть.',
      type: EventType.random,
      moneyImpact: -2000,
      moodImpact: -20,
      isPositive: false,
    ),
    // Positive random events
    const GameEvent(
      id: 'found_money',
      title: 'Нашел 500 рублей',
      description: 'Мелочь, а приятно! Деньги валялись прямо на тротуаре.',
      type: EventType.random,
      moneyImpact: 500,
      moodImpact: 5,
      isPositive: true,
    ),
    const GameEvent(
      id: 'found_coupon',
      title: 'Нашёл купон на скидку',
      description: 'Бесплатный кофе по акции — отличное начало дня!',
      type: EventType.random,
      moneyImpact: 0,
      moodImpact: 8,
      isPositive: true,
    ),
    // Voluntary events with choice
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
      id: 'overtime_offer',
      title: 'Сверхурочная работа',
      description:
          'Начальник предложил поработать в выходные. Больше денег, но меньше отдыха.',
      type: EventType.voluntary,
      moneyImpact: 3000,
      moodImpact: -10,
    ),
    const GameEvent(
      id: 'help_colleague',
      title: 'Помочь коллеге',
      description:
          'Коллега просит помочь с задачей. Это займёт время, но улучшит отношения.',
      type: EventType.voluntary,
      moneyImpact: 0,
      moodImpact: 8,
    ),
    const GameEvent(
      id: 'street_food',
      title: 'Фестиваль стрит-фуда',
      description: 'В городе проходит фестиваль еды. Вкусно, но не бесплатно!',
      type: EventType.voluntary,
      moneyImpact: -400,
      moodImpact: 5,
    ),
    const GameEvent(
      id: 'sale_event',
      title: 'Распродажа!',
      description: 'Большие скидки в любимом магазине. Может стоит зайти?',
      type: EventType.voluntary,
      moneyImpact: -1500,
      moodImpact: 10,
    ),
    // Quizzes
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
    const GameEvent(
      id: 'quiz_budget',
      title: 'Квиз: Бюджет',
      description: 'Какой главный принцип ведения личного бюджета?',
      type: EventType.quiz,
      options: [
        'Тратить всё что заработал',
        'Записывать доходы и расходы',
        'Копить абсолютно все деньги',
        'Брать кредиты на всё',
      ],
      correctAnswerIndex: 1,
      moneyImpact: 2000,
      educationalTip: 'Ведение бюджета — основа финансовой грамотности.',
    ),
    const GameEvent(
      id: 'quiz_savings',
      title: 'Квиз: Сбережения',
      description: 'Зачем нужны сбережения?',
      type: EventType.quiz,
      options: [
        'Чтобы деньги лежали без дела',
        'Для покупки ненужных вещей',
        'Для финансовой безопасности и крупных покупок',
        'Их не нужно иметь',
      ],
      correctAnswerIndex: 2,
      moneyImpact: 2000,
      educationalTip:
          'Сбережения помогают достигать финансовых целей и защищают от непредвиденных расходов.',
    ),
  ];

  // Rent event (not in allEvents)
  static const GameEvent rentEvent = GameEvent(
    id: 'rent_payment',
    title: 'Оплата аренды',
    description: 'Пришло время оплатить аренду жилья.',
    type: EventType.rent,
    moneyImpact: -RENT,
  );

  // Course event
  static const GameEvent courseEvent = GameEvent(
    id: 'course_offer',
    title: 'Предложение записаться на курсы',
    description:
        'Узнали про курсы повышения квалификации. Стоимость: 5000₽. Это откроет новые карьерные возможности!',
    type: EventType.course,
    moneyImpact: -5000,
    options: ['Курс Бариста', 'Курс Бухгалтера', 'Отказаться'],
  );

  static const List<int> quizDays = [9, 19, 29];

  // ===== GAME SETUP =====
  void setupGame(
    Job job,
    GameGoal goal, {
    int walletPct = 40,
    int emergencyPct = 30,
    int mandatoryPct = 30,
    bool isNewGame = true,
  }) {
    _selectedJob = job;
    _selectedGoal = goal;
    _walletPercentage = walletPct;
    _emergencyPercentage = emergencyPct;
    _mandatoryPercentage = mandatoryPct;

    if (isNewGame) {
      _currentDay = 1;
      _currentMonth = 1;
      _gamePoints = 0;
      _walletBalance = 0;
      _emergencyFund = 0;
      _mandatoryBalance = 0;
      _savingsGoal = 0;
      _mood = 80;
      _completedCourses = [];
      _jobHistory = [];
      _eventHistory.clear();
      _inventory.clear();
    }

    // Add job to history
    if (!_jobHistory.contains(job.title)) {
      _jobHistory.add(job.title);
    }

    // Distribute salary for the month
    double goalContrib = _selectedGoal?.monthlyContribution ?? 0;
    double surplus = salary - goalContrib;

    _walletBalance += surplus * (_walletPercentage / 100);
    _emergencyFund += surplus * (_emergencyPercentage / 100);
    _mandatoryBalance += surplus * (_mandatoryPercentage / 100);
    _savingsGoal += goalContrib;
    _rentPaid = false;
    _coursesOffered = false;

    _isGameOver = false;
    _isWin = false;
    _isPlanningPhase = false;
    _daysSinceLastMeal = 0;
    _mealThreshold = Random().nextInt(3) + 2;
    notifyListeners();
  }

  void startNewMonth() {
    _currentDay = 1;
    _currentMonth++;
    _isPlanningPhase = true;
    _isGameOver = false;
    _isWin = false;
    _rentPaid = false;
    _coursesOffered = false;
    _daysSinceLastMeal = 0;
    notifyListeners();
  }

  void updateDistribution(int walletPct, int emergencyPct, int mandatoryPct) {
    _walletPercentage = walletPct;
    _emergencyPercentage = emergencyPct;
    _mandatoryPercentage = mandatoryPct;
    notifyListeners();
  }

  // ===== GAME LOOP =====
  Future<void> nextTurn() async {
    if (_isGameOver || _isPlanningPhase || _needsMeal) return;
    if (_currentEvent != null) return;

    if (_daysSinceLastMeal >= _mealThreshold) {
      _needsMeal = true;
      notifyListeners();
      return;
    }

    int daysToAdd = Random().nextInt(4) + 1;
    for (int i = 0; i < daysToAdd; i++) {
      if (_isGameOver || _needsMeal || _currentEvent != null) break;
      _processSingleDay();
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 400));
    }

    // Always trigger a random event after fast-forward (if no event/meal pending)
    if (!_needsMeal && !_isGameOver && _currentEvent == null) {
      _triggerRandomEvent();
      notifyListeners();
    }
  }

  void _processSingleDay() {
    _currentDay++;
    _daysSinceLastMeal++;

    if (_currentDay > 30) {
      _currentDay = 30;
      _checkGameOver();
      return;
    }

    // Rent deduction on day 2 (as event dialog)
    if (_currentDay >= 2 && !_rentPaid) {
      _rentPaid = true;
      _currentEvent = rentEvent;
      return; // stop processing, let UI show rent event
    }

    // Quiz on scheduled days (9, 19, 29)
    if (quizDays.contains(_currentDay) && _currentEvent == null) {
      _triggerQuiz();
      if (_currentEvent != null) return;
    }

    // Course offer on day 15
    if (_currentDay == 15 && !_coursesOffered && _currentEvent == null) {
      _coursesOffered = true;
      _currentEvent = courseEvent;
      return;
    }

    // Check if hunger is triggered
    if (_daysSinceLastMeal >= _mealThreshold) {
      _needsMeal = true;
    }

    _validateStats();
  }

  void chooseMeal(MealType type) {
    _needsMeal = false;
    _daysSinceLastMeal = 0;
    _mealThreshold = Random().nextInt(3) + 2;

    switch (type) {
      case MealType.economy:
        _applyMandatoryExpense(600);
        _mood -= 10;
        break;
      case MealType.standard:
        _applyMandatoryExpense(1500);
        _mood += 2;
        break;
      case MealType.luxury:
        _applyMandatoryExpense(3500);
        _mood += 15;
        break;
      case MealType.skip:
        _mood -= 25;
        _applyMandatoryExpense(2000);
        break;
    }

    _validateStats();
    notifyListeners();
  }

  void _applyMandatoryExpense(double cost) {
    if (_mandatoryBalance >= cost) {
      _mandatoryBalance -= cost;
      return;
    }
    cost -= _mandatoryBalance;
    _mandatoryBalance = 0;

    if (_walletBalance >= cost) {
      _walletBalance -= cost;
      return;
    }
    cost -= _walletBalance;
    _walletBalance = 0;

    if (_emergencyFund >= cost) {
      _emergencyFund -= cost;
      return;
    }
    cost -= _emergencyFund;
    _emergencyFund = 0;

    if (_savingsGoal >= cost) {
      _savingsGoal -= cost;
      return;
    }
    cost -= _savingsGoal;
    _savingsGoal = 0;

    if (cost > 0) {
      _isGameOver = true;
      _isWin = false;
    }
  }

  // ===== EVENTS =====
  bool canTriggerEvent(String eventId) {
    if (!_eventHistory.containsKey(eventId)) return true;
    if (eventId.contains('repair') || eventId.contains('broken')) {
      return (_currentMonth - _eventHistory[eventId]!) >= 2;
    }
    return true;
  }

  void _triggerRandomEvent() {
    List<GameEvent> eligibleEvents = allEvents
        .where((e) => e.type != EventType.quiz && canTriggerEvent(e.id))
        .toList();
    if (eligibleEvents.isEmpty) return;

    // Mood-based weighting
    final rand = Random();
    if (_mood > 70) {
      // Good mood → prefer negative events
      var negatives = eligibleEvents
          .where((e) => !e.isPositive && e.type == EventType.random)
          .toList();
      if (negatives.isNotEmpty && rand.nextDouble() < 0.6) {
        _currentEvent = negatives[rand.nextInt(negatives.length)];
        _eventHistory[_currentEvent!.id] = _currentMonth;
        return;
      }
    } else if (_mood < 40) {
      // Bad mood → prefer positive events
      var positives = eligibleEvents
          .where((e) => e.isPositive || e.type == EventType.voluntary)
          .toList();
      if (positives.isNotEmpty && rand.nextDouble() < 0.6) {
        _currentEvent = positives[rand.nextInt(positives.length)];
        _eventHistory[_currentEvent!.id] = _currentMonth;
        return;
      }
    }

    _currentEvent = eligibleEvents[rand.nextInt(eligibleEvents.length)];
    _eventHistory[_currentEvent!.id] = _currentMonth;
  }

  void _triggerQuiz() {
    List<GameEvent> quizEvents = allEvents
        .where((e) => e.type == EventType.quiz)
        .toList();
    if (quizEvents.isNotEmpty) {
      _currentEvent = quizEvents[Random().nextInt(quizEvents.length)];
    }
  }

  void _checkGameOver() {
    _isGameOver = true;
    // Win if accumulated savings >= goal cost
    if (_selectedGoal != null && _savingsGoal >= _selectedGoal!.cost) {
      _isWin = true;
      _gamePoints += _selectedGoal!.pointsReward;
    } else {
      _isWin = false;
    }
  }

  // ===== EVENT RESOLUTION =====
  void handleEventChoice(bool accepted) {
    if (_currentEvent == null) return;

    double moneyCost = _currentEvent!.moneyImpact;
    double moodImpact = _currentEvent!.moodImpact;

    if (_currentEvent!.type == EventType.voluntary) {
      if (accepted) {
        _applyFinancialImpact(moneyCost);
        _mood += moodImpact;
      } else {
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

  void resolveEvent(bool accepted, {int? quizAnswerIndex, int? courseChoice}) {
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
    } else if (_currentEvent!.type == EventType.rent) {
      // Apply rent from mandatory
      _applyMandatoryExpense(RENT);
      _currentEvent = null;
    } else if (_currentEvent!.type == EventType.course) {
      if (courseChoice != null && courseChoice < 2) {
        // 0 = Бариста, 1 = Бухгалтер
        String courseName = courseChoice == 0 ? 'Бариста' : 'Бухгалтер';
        if (!_completedCourses.contains(courseName)) {
          _completedCourses.add(courseName);
          _applyFinancialImpact(-5000);
          _notificationController.add(
            'Курс "$courseName" оплачен! Новая профессия доступна со следующего месяца.',
          );
        }
      }
      // courseChoice == 2 or null → refuse
      _currentEvent = null;
    } else {
      handleEventChoice(accepted);
      return;
    }
    _validateStats();
    notifyListeners();
  }

  void _applyFinancialImpact(double amount) {
    if (amount >= 0) {
      _walletBalance += amount;
      return;
    }

    double cost = amount.abs();

    if (_mandatoryBalance >= cost) {
      _mandatoryBalance -= cost;
      return;
    } else {
      cost -= _mandatoryBalance;
      _mandatoryBalance = 0;
    }

    if (_walletBalance >= cost) {
      _walletBalance -= cost;
      return;
    } else {
      cost -= _walletBalance;
      _walletBalance = 0;
    }

    if (_emergencyFund >= cost) {
      _emergencyFund -= cost;
      return;
    } else {
      cost -= _emergencyFund;
      _emergencyFund = 0;
    }

    if (_savingsGoal >= cost) {
      _savingsGoal -= cost;
      return;
    } else {
      cost -= _savingsGoal;
      _savingsGoal = 0;
    }

    if (cost > 0) {
      _isGameOver = true;
      _isWin = false;
    }
  }

  // ===== SHOP =====
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
