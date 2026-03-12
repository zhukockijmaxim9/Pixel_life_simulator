import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/enums.dart';
import 'models/job.dart';
import 'models/goal.dart';
import 'models/event.dart';
import 'models/merch_item.dart';
import 'models/course.dart';
import 'data/game_data.dart';
import 'domain/managers/career_manager.dart';
import 'domain/managers/finance_manager.dart';

class GameState with ChangeNotifier {
  final CareerManager _career = CareerManager();
  final FinanceManager _finance = FinanceManager();

  // Dynamic salary based on selected job
  double get salary => _career.selectedJob?.salary ?? 30000;

  double _mood = 60;
  int _currentDay = 1;
  int _currentMonth = 1;
  int _gamePoints = 0;

  int _daysSinceLastMeal = 0;
  int _mealThreshold = Random().nextInt(3) + 2;
  bool _needsMeal = false;

  int _quizzesShownThisMonth = 0;
  List<String> _pendingQuizIds = [];

  GameEvent? _currentEvent;
  bool _isGameOver = false;
  bool _isWin = false;
  bool _isPlanningPhase = false;
  final List<MerchItem> _inventory = [];

  PendingTransaction? _pendingTransaction;

  final Map<String, int> _eventHistory = {};
  int _overtimeCount = 0;
  final List<PendingPayment> _pendingPayments = [];

  double _currentMonthSurplus = 0;
  double _currentMonthGoalContrib = 0;

  // Carry-over: leftover money from previous month
  double _carryOver = 0;
  
  // Month start summary
  bool _showMonthSummary = false;

  // Getters (delegated or direct)
  double get walletBalance => _finance.walletBalance;
  double get deferredFund => _finance.deferredFund;
  double get mandatoryBalance => _finance.mandatoryBalance;
  double get savingsGoal => _finance.savingsGoal;
  double get totalMoney => _finance.getTotalMoney();

  double get foodBudget => _finance.walletBalance + _finance.mandatoryBalance;

  double get mood => _mood;
  int get currentDay => _currentDay;
  int get currentMonth => _currentMonth;
  int get gamePoints => _gamePoints;
  Job? get selectedJob => _career.selectedJob;
  GameGoal? get selectedGoal {
    return _selectedGoal;
  }
  GameGoal? _selectedGoal;

  GameEvent? get currentEvent => _currentEvent;
  PendingTransaction? get pendingTransaction => _pendingTransaction;
  bool get isGameOver => _isGameOver;
  bool get isWin => _isWin;
  bool get isPlanningPhase => _isPlanningPhase;
  bool get needsMeal => _needsMeal;
  int get daysToHunger => _mealThreshold - _daysSinceLastMeal;
  List<MerchItem> get inventory => List.unmodifiable(_inventory);
  List<String> get completedCourses => List.unmodifiable(_career.completedCourses);
  List<String> get jobHistory => List.unmodifiable(_career.jobHistory);

  bool get hasNewJobOpportunities => _career.hasNewOpportunities();

  double get walletAlloc => _finance.walletAlloc;
  double get deferredAlloc => _finance.deferredAlloc;
  double get mandatoryAlloc => _finance.mandatoryAlloc;
  double get goalAlloc => _selectedGoal?.monthlyContribution ?? 0;

  double get carryOver => _carryOver;
  bool get showMonthSummary => _showMonthSummary;
  
  // Dynamic rent based on job tier
  double get currentRent => GameData.getRent(_career.selectedJob?.tier ?? 1);

  void updateDistribution(double wallet, double deferred, double mandatory) {
    _finance.updateDistribution(wallet, deferred, mandatory);
    notifyListeners();
    saveToDisk();
  }

  void setGoal(GameGoal goal) {
    double oldGoalContrib = _currentMonthGoalContrib;
    _selectedGoal = goal;
    _currentMonthGoalContrib = _selectedGoal?.monthlyContribution ?? 0;

    double diff = _currentMonthGoalContrib - oldGoalContrib;

    if (diff > 0) {
      _applyFinancialImpact(-diff);
      _finance.savingsGoal += diff;
    } else if (diff < 0) {
      _finance.savingsGoal += diff;
      _finance.walletBalance -= diff;
    }

    _currentMonthSurplus = salary - _currentMonthGoalContrib;
    notifyListeners();
    saveToDisk();
  }

  List<Job> getAvailableJobsForMonth() => _career.getAvailableJobs();

  static List<Job> get availableJobs => GameData.allJobs.where((j) => j.tier == 1).toList();
  static List<GameGoal> get availableGoals => GameData.availableGoals;
  static List<MerchItem> get shopItems => GameData.shopItems;
  static List<GameEvent> get allEvents => GameData.allEvents;
  static List<int> get quizDays => GameData.quizDays;

  void setupGame(
    Job job,
    GameGoal goal, {
    double walletAlloc = 10000,
    double deferredAlloc = 5000,
    double mandatoryAlloc = 15000,
    bool isNewGame = true,
  }) {
    if (isNewGame) {
      _currentDay = 1;
      _currentMonth = 1;
      _gamePoints = 0;
      _finance.resetBalances();
      _mood = 60;
      _career.reset(job);
      _eventHistory.clear();
      _inventory.clear();
      _overtimeCount = 0;
      _pendingPayments.clear();
      _quizzesShownThisMonth = 0;
      _pendingQuizIds = [];
      _carryOver = 0;
    } else {
      // Carry over: save leftover from previous month
      _carryOver = _finance.walletBalance + _finance.deferredFund + _finance.mandatoryBalance;
      _career.selectedJob = job;
      _career.eligibleForPromotion = false;
      _career.addJobToHistory(job);
    }
    
    _selectedGoal = goal;
    _finance.walletAlloc = walletAlloc;
    _finance.deferredAlloc = deferredAlloc;
    _finance.mandatoryAlloc = mandatoryAlloc;

    _currentMonthGoalContrib = _selectedGoal?.monthlyContribution ?? 0;
    _currentMonthSurplus = salary - _currentMonthGoalContrib;

    if (isNewGame) {
      // First month: distribute salary only
      double totalAlloc = _finance.walletAlloc + _finance.deferredAlloc + _finance.mandatoryAlloc;
      if (totalAlloc > _currentMonthSurplus && _currentMonthSurplus > 0) {
        _finance.walletBalance += _currentMonthSurplus * (_finance.walletAlloc / totalAlloc);
        _finance.deferredFund += _currentMonthSurplus * (_finance.deferredAlloc / totalAlloc);
        _finance.mandatoryBalance += _currentMonthSurplus * (_finance.mandatoryAlloc / totalAlloc);
      } else {
        _finance.walletBalance += _finance.walletAlloc;
        _finance.deferredFund += _finance.deferredAlloc;
        _finance.mandatoryBalance += _finance.mandatoryAlloc;
      }
    } else {
      // Subsequent months: add salary on top of carried-over balances
      // Reset balances to carry-over, then add new salary distribution
      double totalAvailable = _carryOver + _currentMonthSurplus;
      double totalAlloc = _finance.walletAlloc + _finance.deferredAlloc + _finance.mandatoryAlloc;
      if (totalAlloc > 0) {
        _finance.walletBalance = totalAvailable * (_finance.walletAlloc / totalAlloc);
        _finance.deferredFund = totalAvailable * (_finance.deferredAlloc / totalAlloc);
        _finance.mandatoryBalance = totalAvailable * (_finance.mandatoryAlloc / totalAlloc);
      }
    }

    _finance.savingsGoal += _currentMonthGoalContrib;
    _isGameOver = false;
    _isWin = false;
    _isPlanningPhase = false;
    _daysSinceLastMeal = 0;
    _mealThreshold = Random().nextInt(3) + 2;
    
    // Show month summary at start
    _showMonthSummary = true;
    
    notifyListeners();
    saveToDisk();
  }

  void dismissMonthSummary() {
    _showMonthSummary = false;
    notifyListeners();
    saveToDisk();
  }

  void startNewMonth() {
    if (_isWin && _selectedGoal != null) {
      _finance.savingsGoal -= _selectedGoal!.cost;
      if (_finance.savingsGoal < 0) _finance.savingsGoal = 0;
    }

    _currentDay = 1;
    _currentMonth++;
    _isPlanningPhase = true;
    _isGameOver = false;
    _isWin = false;
    _daysSinceLastMeal = 0;
    _overtimeCount = 0;
    _pendingPayments.clear();
    _quizzesShownThisMonth = 0;

    notifyListeners();
    saveToDisk();
  }

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
      saveToDisk();
      await Future.delayed(const Duration(milliseconds: 400));
    }

    if (!_needsMeal && !_isGameOver && _currentEvent == null) {
      _triggerRandomEvent();
      notifyListeners();
      saveToDisk();
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

    for (int i = 0; i < _pendingPayments.length; i++) {
      if (_currentDay >= _pendingPayments[i].dueDate) {
        PendingPayment pay = _pendingPayments.removeAt(i);
        _currentEvent = GameEvent(
          id: 'pending_${pay.title}',
          title: pay.title,
          description: 'Пришло время оплатить ${pay.title.toLowerCase()}.',
          type: EventType.payment,
          moneyImpact: pay.amount,
          moodImpact: 0,
        );
        return;
      }
    }

    if (_overtimeCount < 2 && _currentEvent == null) {
      bool paymentSoon = _pendingPayments.any((p) => p.dueDate == _currentDay + 1);
      if (!paymentSoon) {
        if ([1, 4, 9].contains(_currentDay)) paymentSoon = true;
      }

      if (paymentSoon && _finance.walletBalance < 2000) {
        _currentEvent = allEvents.firstWhere((e) => e.id == 'overtime_offer');
        _overtimeCount++;
        return;
      }
    }

    if (_currentEvent == null) {
      if (_currentDay == 2) {
        // Dynamic rent based on job tier
        _currentEvent = GameEvent(id: 'initial_rent', title: 'Аренда жилья', description: 'Хозяин квартиры ждёт оплаты.', type: EventType.payment, moneyImpact: -currentRent);
        return;
      }
      if (_currentDay == 5) {
        _currentEvent = const GameEvent(id: 'initial_services', title: 'Коммунальные услуги', description: 'Пришли счета за свет, воду и интернет.', type: EventType.payment, moneyImpact: -4000);
        return;
      }
      if (_currentDay == 10) {
        _currentEvent = const GameEvent(id: 'initial_transport', title: 'Транспортная карта', description: 'Пора продлить проездной на месяц.', type: EventType.payment, moneyImpact: -3000);
        return;
      }
    }

    if (quizDays.contains(_currentDay) && _currentEvent == null && _quizzesShownThisMonth < 2) {
      _triggerQuiz();
      if (_currentEvent != null) return;
    }

    if (_daysSinceLastMeal >= _mealThreshold) {
      _needsMeal = true;
    }

    _validateStats();
  }

  void resolvePendingTransaction(AccountType source) {
    if (_pendingTransaction == null) return;

    final deficit = _pendingTransaction!.deficit;

    switch (source) {
      case AccountType.wallet:
        if (_finance.walletBalance >= deficit) { _finance.walletBalance -= deficit; } else { _finance.walletBalance = 0; _isGameOver = true; }
        break;
      case AccountType.deferred:
        if (_finance.deferredFund >= deficit) { _finance.deferredFund -= deficit; } else { _finance.deferredFund = 0; _isGameOver = true; }
        break;
      case AccountType.mandatory:
        if (_finance.mandatoryBalance >= deficit) { _finance.mandatoryBalance -= deficit; } else { _finance.mandatoryBalance = 0; _isGameOver = true; }
        break;
      case AccountType.savings:
        if (_finance.savingsGoal >= deficit) { _finance.savingsGoal -= deficit; } else { _finance.savingsGoal = 0; _isGameOver = true; }
        break;
    }

    _pendingTransaction = null;
    _validateStats();
    notifyListeners();
    saveToDisk();
  }

  void chooseMeal(MealType type) {
    _needsMeal = false;
    _daysSinceLastMeal = 0;
    _mealThreshold = Random().nextInt(3) + 2;

    switch (type) {
      case MealType.economy: _applyMandatoryExpense(600); _mood -= 10; break;
      case MealType.standard: _applyMandatoryExpense(1500); _mood += 2; break;
      case MealType.luxury: _applyMandatoryExpense(3500); _mood += 15; break;
      case MealType.skip: _mood -= 25; _applyMandatoryExpense(2000); break;
    }

    _validateStats();
    notifyListeners();
    saveToDisk();
  }

  void _applyMandatoryExpense(double cost) {
    if (_finance.mandatoryBalance >= cost) {
      _finance.mandatoryBalance -= cost;
      return;
    }

    double deficit = cost - _finance.mandatoryBalance;
    _finance.mandatoryBalance = 0;

    _pendingTransaction = PendingTransaction(
      title: "Обязательные расходы",
      amount: cost,
      primaryAccount: AccountType.mandatory,
      deficit: deficit,
    );
  }

  void _triggerRandomEvent() {
    List<GameEvent> eligibleEvents = allEvents.where((e) => e.type != EventType.quiz && canTriggerEvent(e.id)).toList();
    if (eligibleEvents.isEmpty) return;

    final rand = Random();
    if (_mood > 70) {
      var negatives = eligibleEvents.where((e) => !e.isPositive && e.type == EventType.random).toList();
      if (negatives.isNotEmpty && rand.nextDouble() < 0.6) {
        _currentEvent = negatives[rand.nextInt(negatives.length)];
        _eventHistory[_currentEvent!.id] = _currentMonth;
        return;
      }
    } else if (_mood < 40) {
      var positives = eligibleEvents.where((e) => e.isPositive || e.type == EventType.voluntary).toList();
      if (positives.isNotEmpty && rand.nextDouble() < 0.6) {
        _currentEvent = positives[rand.nextInt(positives.length)];
        _eventHistory[_currentEvent!.id] = _currentMonth;
        return;
      }
    }

    _currentEvent = eligibleEvents[rand.nextInt(eligibleEvents.length)];
    _eventHistory[_currentEvent!.id] = _currentMonth;
  }

  bool canTriggerEvent(String eventId) {
    if (!_eventHistory.containsKey(eventId)) return true;
    if (eventId.contains('repair') || eventId.contains('broken')) {
      return (_currentMonth - _eventHistory[eventId]!) >= 2;
    }
    return true;
  }

  void _triggerQuiz() {
    if (_pendingQuizIds.isEmpty) {
      _pendingQuizIds = GameData.allEvents.where((e) => e.type == EventType.quiz).map((e) => e.id).toList();
      _pendingQuizIds.shuffle();
    }

    if (_pendingQuizIds.isNotEmpty) {
      String nextId = _pendingQuizIds.removeLast();
      _currentEvent = GameData.allEvents.firstWhere((e) => e.id == nextId);
      _quizzesShownThisMonth++;
    }
  }

  void _checkGameOver() {
    _isGameOver = true;
    bool goalReached = _selectedGoal != null && _finance.savingsGoal >= _selectedGoal!.cost;
    bool moodOk = _mood > 0;

    if (goalReached && moodOk) {
      _isWin = true;
      _gamePoints += _selectedGoal!.pointsReward;
      if (_mood >= 60) _career.eligibleForPromotion = true;
    } else {
      _isWin = false;
      _career.eligibleForPromotion = false;
    }
  }

  void resolveEvent(bool accepted, {int? quizAnswerIndex, int? courseChoice}) {
    if (_currentEvent == null) return;

    if (_currentEvent!.type == EventType.quiz) {
      if (quizAnswerIndex == _currentEvent!.correctAnswerIndex) {
        _finance.walletBalance += _currentEvent!.moneyImpact;
        _gamePoints += 10;
        _mood += 10;
      } else {
        _mood -= 10;
      }
      _currentEvent = null;
    } else if (_currentEvent!.type == EventType.payment) {
      if (accepted) {
        _applyMandatoryExpense(_currentEvent!.moneyImpact.abs());
        _mood += 5;
      } else {
        _pendingPayments.add(PendingPayment(title: _currentEvent!.title, amount: _currentEvent!.moneyImpact, dueDate: _currentDay + 7));
        _mood -= 15;
      }
      _currentEvent = null;
    } else {
      if (_currentEvent!.id == 'overtime_offer') {
        if (accepted) { _overtimeCount++; _applyFinancialImpact(2000); _mood -= 15; }
        _currentEvent = null;
      } else {
        handleEventChoice(accepted);
        return;
      }
    }
    _validateStats();
    notifyListeners();
    saveToDisk();
  }

  void handleEventChoice(bool accepted) {
    if (_currentEvent == null) return;
    if (_currentEvent!.type == EventType.voluntary) {
      if (accepted) { _applyFinancialImpact(_currentEvent!.moneyImpact); _mood += _currentEvent!.moodImpact; }
      else { _mood -= 15; }
    } else if (_currentEvent!.type == EventType.random) {
      _applyFinancialImpact(_currentEvent!.moneyImpact);
      _mood += _currentEvent!.moodImpact;
    }
    _currentEvent = null;
    _validateStats();
    notifyListeners();
    saveToDisk();
  }

  void _applyFinancialImpact(double amount) {
    if (amount >= 0) { _finance.walletBalance += amount; return; }
    double cost = amount.abs();
    if (_finance.walletBalance >= cost) { _finance.walletBalance -= cost; return; }
    double deficit = cost - _finance.walletBalance;
    _finance.walletBalance = 0;
    _pendingTransaction = PendingTransaction(title: "Финансовое событие", amount: cost, primaryAccount: AccountType.wallet, deficit: deficit);
  }

  void buyItem(MerchItem item) {
    if (_gamePoints >= item.price) { _gamePoints -= item.price; _inventory.add(item); notifyListeners(); saveToDisk(); }
  }

  void _validateStats() {
    _mood = _mood.clamp(0, 100);
    if (_mood <= 0) { _isGameOver = true; _isWin = false; }
  }

  void updateWallet(double amount) { _finance.walletBalance += amount; notifyListeners(); saveToDisk(); }
  void updateMood(double amount) { _mood += amount; _validateStats(); notifyListeners(); saveToDisk(); }
  bool get isCourseShopAvailable => _currentMonth >= 2 && _currentDay <= 15;

  void buyCourse(Course course) {
    // Courses are bought from the deferred fund
    if (_finance.deferredFund >= course.cost && !_career.completedCourses.contains(course.title)) {
      _finance.deferredFund -= course.cost;
      _career.completedCourses.add(course.title);
      notifyListeners();
      saveToDisk();
    }
  }

  // --- Persistence ---

  Map<String, dynamic> toJson() => {
        'mood': _mood,
        'currentDay': _currentDay,
        'currentMonth': _currentMonth,
        'gamePoints': _gamePoints,
        'daysSinceLastMeal': _daysSinceLastMeal,
        'mealThreshold': _mealThreshold,
        'needsMeal': _needsMeal,
        'quizzesShownThisMonth': _quizzesShownThisMonth,
        'pendingQuizIds': _pendingQuizIds,
        'currentEvent': _currentEvent?.toJson(),
        'isGameOver': _isGameOver,
        'isWin': _isWin,
        'isPlanningPhase': _isPlanningPhase,
        'inventory': _inventory.map((i) => i.toJson()).toList(),
        'pendingTransaction': _pendingTransaction?.toJson(),
        'eventHistory': _eventHistory,
        'overtimeCount': _overtimeCount,
        'pendingPayments': _pendingPayments.map((p) => p.toJson()).toList(),
        'currentMonthSurplus': _currentMonthSurplus,
        'currentMonthGoalContrib': _currentMonthGoalContrib,
        'carryOver': _carryOver,
        'showMonthSummary': _showMonthSummary,
        'selectedGoal': _selectedGoal?.toJson(),
        'career': _career.toJson(),
        'finance': _finance.toJson(),
      };

  Future<void> saveToDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = jsonEncode(toJson());
      await prefs.setString('game_state', data);
    } catch (e) {
      debugPrint('Error saving game state: $e');
    }
  }

  Future<void> loadFromDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('game_state');
      if (data != null) {
        final Map<String, dynamic> json = jsonDecode(data);
        _mood = json['mood']?.toDouble() ?? 60;
        _currentDay = json['currentDay'] ?? 1;
        _currentMonth = json['currentMonth'] ?? 1;
        _gamePoints = json['gamePoints'] ?? 0;
        _daysSinceLastMeal = json['daysSinceLastMeal'] ?? 0;
        _mealThreshold = json['mealThreshold'] ?? 2;
        _needsMeal = json['needsMeal'] ?? false;
        _quizzesShownThisMonth = json['quizzesShownThisMonth'] ?? 0;
        _pendingQuizIds = List<String>.from(json['pendingQuizIds'] ?? []);
        _currentEvent = json['currentEvent'] != null ? GameEvent.fromJson(json['currentEvent']) : null;
        _isGameOver = json['isGameOver'] ?? false;
        _isWin = json['isWin'] ?? false;
        _isPlanningPhase = json['isPlanningPhase'] ?? false;
        _inventory.clear();
        if (json['inventory'] != null) {
          _inventory.addAll((json['inventory'] as List).map((i) => MerchItem.fromJson(i)));
        }
        _pendingTransaction = json['pendingTransaction'] != null ? PendingTransaction.fromJson(json['pendingTransaction']) : null;
        _eventHistory.clear();
        if (json['eventHistory'] != null) {
          _eventHistory.addAll(Map<String, int>.from(json['eventHistory']));
        }
        _overtimeCount = json['overtimeCount'] ?? 0;
        _pendingPayments.clear();
        if (json['pendingPayments'] != null) {
          _pendingPayments.addAll((json['pendingPayments'] as List).map((p) => PendingPayment.fromJson(p)));
        }
        _currentMonthSurplus = json['currentMonthSurplus']?.toDouble() ?? 0;
        _currentMonthGoalContrib = json['currentMonthGoalContrib']?.toDouble() ?? 0;
        _carryOver = json['carryOver']?.toDouble() ?? 0;
        _showMonthSummary = json['showMonthSummary'] ?? false;
        _selectedGoal = json['selectedGoal'] != null ? GameGoal.fromJson(json['selectedGoal']) : null;
        _career.fromJson(json['career'] ?? {});
        _finance.fromJson(json['finance'] ?? {});
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading game state: $e');
    }
  }

  Future<void> clearSave() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('game_state');
  }

  Future<void> clearSaveAndReset() async {
    await clearSave();
    
    _currentDay = 1;
    _currentMonth = 1;
    _gamePoints = 0;
    _finance.resetBalances();
    _mood = 60;
    _career.reset(null);
    _eventHistory.clear();
    _inventory.clear();
    _overtimeCount = 0;
    _pendingPayments.clear();
    _quizzesShownThisMonth = 0;
    _pendingQuizIds = [];
    _carryOver = 0;
    _selectedGoal = null;
    _isGameOver = false;
    _isWin = false;
    _isPlanningPhase = false;
    _needsMeal = false;
    _daysSinceLastMeal = 0;
    _currentEvent = null;
    _pendingTransaction = null;
    _currentMonthSurplus = 0;
    _currentMonthGoalContrib = 0;
    _showMonthSummary = false;
    
    notifyListeners();
  }
}
