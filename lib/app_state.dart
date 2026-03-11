import 'dart:math';
import 'package:flutter/material.dart';

import 'models/enums.dart';
import 'models/job.dart';
import 'models/goal.dart';
import 'models/event.dart';
import 'models/merch_item.dart';
import 'models/course.dart';
import 'data/game_data.dart';

class GameState with ChangeNotifier {
  // Dynamic salary based on selected job
  double get salary => _selectedJob?.salary ?? 30000;

  // Financial accounts
  double _walletBalance = 0;
  double _emergencyFund = 0;
  double _mandatoryBalance = 0;
  double _savingsGoal = 0;

  double _mood = 60;
  int _currentDay = 1;
  int _currentMonth = 1;
  int _gamePoints = 0;

  // Budget distribution (absolute amounts in rubles)
  double _walletAlloc = 10000;
  double _emergencyAlloc = 5000;
  double _mandatoryAlloc = 15000;

  int _daysSinceLastMeal = 0;
  int _mealThreshold = Random().nextInt(3) + 2;
  bool _needsMeal = false;
  bool _coursesOffered = false; // day 15 course event fired this month

  Job? _selectedJob;
  GameGoal? _selectedGoal;
  GameEvent? _currentEvent;
  bool _isGameOver = false;
  bool _isWin = false;
  bool _isPlanningPhase = false;
  final List<MerchItem> _inventory = [];

  PendingTransaction? _pendingTransaction;

  // Career progression
  List<String> _completedCourses = [];
  List<String> _jobHistory = [];

  final Map<String, int> _eventHistory = {};
  int _overtimeCount = 0;
  final List<PendingPayment> _pendingPayments = [];

  // Track current month's allocations for redistribution
  double _currentMonthSurplus = 0;
  double _currentMonthGoalContrib = 0;
  bool _eligibleForPromotion = false;

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
  PendingTransaction? get pendingTransaction => _pendingTransaction;
  bool get isGameOver => _isGameOver;
  bool get isWin => _isWin;
  bool get isPlanningPhase => _isPlanningPhase;
  bool get needsMeal => _needsMeal;
  int get daysToHunger => _mealThreshold - _daysSinceLastMeal;
  List<MerchItem> get inventory => List.unmodifiable(_inventory);
  List<String> get completedCourses => List.unmodifiable(_completedCourses);
  List<String> get jobHistory => List.unmodifiable(_jobHistory);

  double get walletAlloc => _walletAlloc;
  double get emergencyAlloc => _emergencyAlloc;
  double get mandatoryAlloc => _mandatoryAlloc;
  double get goalAlloc => _selectedGoal?.monthlyContribution ?? 0;

  void updateDistribution(double wallet, double emergency, double mandatory) {
    // 1. Update the rules for future months
    _walletAlloc = wallet;
    _emergencyAlloc = emergency;
    _mandatoryAlloc = mandatory;

    // 2. Redistribute CURRENT balances if in game
    // This fixes the "stale data" bug by redistributing what the user ACTUALLY has now
    double currentTotal = _walletBalance + _emergencyFund + _mandatoryBalance;
    if (currentTotal > 0) {
      double totalAlloc = _walletAlloc + _emergencyAlloc + _mandatoryAlloc;
      if (totalAlloc > 0) {
        _walletBalance = currentTotal * (_walletAlloc / totalAlloc);
        _emergencyFund = currentTotal * (_emergencyAlloc / totalAlloc);
        _mandatoryBalance = currentTotal * (_mandatoryAlloc / totalAlloc);
      }
    }

    notifyListeners();
  }

  void setGoal(GameGoal goal) {
    // 1. Calculate how much we need to adjust
    double oldGoalContrib = _currentMonthGoalContrib;
    _selectedGoal = goal;
    _currentMonthGoalContrib = _selectedGoal?.monthlyContribution ?? 0;

    double diff = _currentMonthGoalContrib - oldGoalContrib;

    // 2. Adjust savings and take/give from other accounts proportionally
    if (diff > 0) {
      // Need more for goal, take from others
      _applyFinancialImpact(-diff);
      _savingsGoal += diff;
    } else if (diff < 0) {
      // Need less for goal, give back to wallet (simplification)
      _savingsGoal += diff; // diff is negative
      _walletBalance -= diff;
    }

    // Refresh surplus calculation for current month
    _currentMonthSurplus = salary - _currentMonthGoalContrib;

    notifyListeners();
  }

  List<Job> getAvailableJobsForMonth() {
    if (_currentMonth <= 1) {
      return GameData.allJobs.where((j) => j.tier == 1).toList();
    }

    List<Job> available = [];

    // Current job's next tier is always a candidate if requirements met
    for (var job in GameData.allJobs) {
      // 1. Course-based jobs (Level 2)
      if (job.requiredCourse != null && job.tier == 2) {
        if (_completedCourses.contains(job.requiredCourse)) {
          available.add(job);
        }
        continue;
      }

      // 2. Experience-based jobs (Level 2+)
      if (job.requiredPreviousJobs.isNotEmpty) {
        // Must have worked in ANY of the required previous jobs
        bool hasExp = job.requiredPreviousJobs.any(
          (prev) => _jobHistory.contains(prev),
        );

        if (hasExp) {
          // If it's a higher tier than current job, check PROMOTION requirements
          if (_selectedJob != null && job.tier > _selectedJob!.tier) {
            if (_eligibleForPromotion) {
              available.add(job);
            }
          } else {
            // Already reached this tier or it's a lateral/backward move (though tree is mostly linear per branch)
            available.add(job);
          }
        }
      }

      // 3. Level 1 jobs are always available as a fallback
      if (job.tier == 1) {
        available.add(job);
      }
    }

    // Remove duplicates and current job
    return available.toSet().toList();
  }

  // Keep backward compat - used in job_selection_screen
  static List<Job> get availableJobs =>
      GameData.allJobs.where((j) => j.tier == 1).toList();
  static List<GameGoal> get availableGoals => GameData.availableGoals;
  static List<MerchItem> get shopItems => GameData.shopItems;
  static List<GameEvent> get allEvents => GameData.allEvents;
  static GameEvent get rentEvent => GameData.rentEvent;
  static List<int> get quizDays => GameData.quizDays;

  // ===== GAME SETUP =====
  void setupGame(
    Job job,
    GameGoal goal, {
    double walletAlloc = 10000,
    double emergencyAlloc = 5000,
    double mandatoryAlloc = 15000,
    bool isNewGame = true,
  }) {
    _selectedJob = job;
    _selectedGoal = goal;
    _walletAlloc = walletAlloc;
    _emergencyAlloc = emergencyAlloc;
    _mandatoryAlloc = mandatoryAlloc;

    if (isNewGame) {
      _currentDay = 1;
      _currentMonth = 1;
      _gamePoints = 0;
      _walletBalance = 0;
      _emergencyFund = 0;
      _mandatoryBalance = 0;
      _savingsGoal = 0;
      _mood = 60;
      _completedCourses = [];
      _jobHistory = [];
      _eventHistory.clear();
      _inventory.clear();
      _overtimeCount = 0;
      _pendingPayments.clear();
      _eligibleForPromotion = false;
    }

    // Add job to history
    if (!_jobHistory.contains(job.title)) {
      _jobHistory.add(job.title);
    }

    // Distribute salary for the month based on absolute rules
    _currentMonthGoalContrib = _selectedGoal?.monthlyContribution ?? 0;
    _currentMonthSurplus = salary - _currentMonthGoalContrib;

    // Use absolute rules or proportional if settings exceed surplus
    double totalAlloc = _walletAlloc + _emergencyAlloc + _mandatoryAlloc;
    if (totalAlloc > _currentMonthSurplus && _currentMonthSurplus > 0) {
      // If rules exceed actual surplus, scale them down proportionally
      _walletBalance += _currentMonthSurplus * (_walletAlloc / totalAlloc);
      _emergencyFund += _currentMonthSurplus * (_emergencyAlloc / totalAlloc);
      _mandatoryBalance +=
          _currentMonthSurplus * (_mandatoryAlloc / totalAlloc);
    } else {
      // Normall case: add the requested amounts
      _walletBalance += _walletAlloc;
      _emergencyFund += _emergencyAlloc;
      _mandatoryBalance += _mandatoryAlloc;
    }

    _savingsGoal += _currentMonthGoalContrib;
    _coursesOffered = false;

    _isGameOver = false;
    _isWin = false;
    _isPlanningPhase = false;
    _daysSinceLastMeal = 0;
    _mealThreshold = Random().nextInt(3) + 2;
    notifyListeners();
  }

  void startNewMonth() {
    // 1. Deduct cost of completed goal if won
    if (_isWin && _selectedGoal != null) {
      _savingsGoal -= _selectedGoal!.cost;
      if (_savingsGoal < 0) _savingsGoal = 0;
    }

    _currentDay = 1;
    _currentMonth++;
    _isPlanningPhase = true;
    _isGameOver = false;
    _isWin = false;
    _coursesOffered = false;
    _daysSinceLastMeal = 0;
    _overtimeCount = 0;
    _pendingPayments.clear();

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

    // Check for pending payments due TODAY or overdue
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

    // Overtime hook: 1 day before any payment is due, if wallet is low
    if (_overtimeCount < 2 && _currentEvent == null) {
      bool paymentSoon = _pendingPayments.any(
        (p) => p.dueDate == _currentDay + 1,
      );
      // Also check the initial scheduled days (2, 5, 10)
      if (!paymentSoon) {
        if ([1, 4, 9].contains(_currentDay)) paymentSoon = true;
      }

      if (paymentSoon && _walletBalance < 2000) {
        _currentEvent = allEvents.firstWhere((e) => e.id == 'overtime_offer');
        _overtimeCount++;
        return;
      }
    }

    // Fixed schedule for initial payments
    if (_currentEvent == null) {
      if (_currentDay == 2) {
        _currentEvent = const GameEvent(
          id: 'initial_rent',
          title: 'Аренда жилья',
          description: 'Хозяин квартиры ждёт оплаты.',
          type: EventType.payment,
          moneyImpact: -7000,
        );
        return;
      }
      if (_currentDay == 5) {
        _currentEvent = const GameEvent(
          id: 'initial_services',
          title: 'Коммунальные услуги',
          description: 'Пришли счета за свет, воду и интернет.',
          type: EventType.payment,
          moneyImpact: -4000,
        );
        return;
      }
      if (_currentDay == 10) {
        _currentEvent = const GameEvent(
          id: 'initial_transport',
          title: 'Транспортная карта',
          description: 'Пора продлить проездной на месяц.',
          type: EventType.payment,
          moneyImpact: -3000, // Corrected from 300 to 3000
        );
        return;
      }
    }

    // Quiz on scheduled days (9, 19, 29)
    if (quizDays.contains(_currentDay) && _currentEvent == null) {
      _triggerQuiz();
      if (_currentEvent != null) return;
    }

    // Course filter handled by shop UI

    // Check if hunger is triggered
    if (_daysSinceLastMeal >= _mealThreshold) {
      _needsMeal = true;
    }

    _validateStats();
  }

  void resolvePendingTransaction(AccountType source) {
    if (_pendingTransaction == null) return;

    final transaction = _pendingTransaction!;
    final deficit = transaction.deficit;

    // Deduct from source
    switch (source) {
      case AccountType.wallet:
        if (_walletBalance >= deficit) {
          _walletBalance -= deficit;
        } else {
          _walletBalance = 0;
          _isGameOver = true;
        }
        break;
      case AccountType.emergency:
        if (_emergencyFund >= deficit) {
          _emergencyFund -= deficit;
        } else {
          _emergencyFund = 0;
          _isGameOver = true;
        }
        break;
      case AccountType.mandatory:
        if (_mandatoryBalance >= deficit) {
          _mandatoryBalance -= deficit;
        } else {
          _mandatoryBalance = 0;
          _isGameOver = true;
        }
        break;
      case AccountType.savings:
        if (_savingsGoal >= deficit) {
          _savingsGoal -= deficit;
        } else {
          _savingsGoal = 0;
          _isGameOver = true;
        }
        break;
    }

    _pendingTransaction = null;
    _validateStats();
    notifyListeners();
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
    String title = "Обязательные расходы";
    // Check if we are currently in chooseMeal or similar to give better title
    // But for now, generic is fine or passed as argument.
    // Let's assume _applyMandatoryExpense is for mandatory.

    if (_mandatoryBalance >= cost) {
      _mandatoryBalance -= cost;
      return;
    }

    double availableInPrimary = _mandatoryBalance;
    double deficit = cost - availableInPrimary;
    _mandatoryBalance = 0;

    _pendingTransaction = PendingTransaction(
      title: title,
      amount: cost,
      primaryAccount: AccountType.mandatory,
      deficit: deficit,
    );
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
    // Win if accumulated savings >= goal cost AND mood > 0
    bool goalReached =
        _selectedGoal != null && _savingsGoal >= _selectedGoal!.cost;
    bool moodOk = _mood > 0;

    if (goalReached && moodOk) {
      _isWin = true;
      _gamePoints += _selectedGoal!.pointsReward;
      // Promotion eligibility: Goal reached AND Mood >= 60
      if (_mood >= 60) {
        _eligibleForPromotion = true;
      }
    } else {
      _isWin = false;
      _eligibleForPromotion = false;
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
    } else if (_currentEvent!.type == EventType.payment) {
      if (accepted) {
        // Option A: Pay Now
        _applyMandatoryExpense(_currentEvent!.moneyImpact.abs());
        _mood += 5;
      } else {
        // Option B: Delay
        _pendingPayments.add(
          PendingPayment(
            title: _currentEvent!.title,
            amount: _currentEvent!.moneyImpact,
            dueDate: _currentDay + 7,
          ),
        );
        _mood -= 15;
      }
      _currentEvent = null;
    } else {
      if (_currentEvent!.id == 'overtime_offer') {
        // Custom check for overtime choice
        if (accepted) {
          _overtimeCount++;
          _applyFinancialImpact(2000);
          _mood -= 15;
        }
        _currentEvent = null;
      } else {
        handleEventChoice(accepted);
        return;
      }
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

    if (_walletBalance >= cost) {
      _walletBalance -= cost;
      return;
    }

    double availableInPrimary = _walletBalance;
    double deficit = cost - availableInPrimary;
    _walletBalance = 0;

    _pendingTransaction = PendingTransaction(
      title: "Финансовое событие",
      amount: cost,
      primaryAccount: AccountType.wallet,
      deficit: deficit,
    );
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
    _mood = _mood.clamp(0, 100);
    if (_mood <= 0) {
      _isGameOver = true;
      _isWin = false;
    }
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
  // ===== COURSE SHOP =====
  bool get isCourseShopAvailable {
    return _currentMonth >= 2 && _currentDay <= 15;
  }

  void buyCourse(Course course) {
    if (_walletBalance >= course.cost &&
        !_completedCourses.contains(course.title)) {
      _walletBalance -= course.cost;
      _completedCourses.add(course.title);
      notifyListeners();
    }
  }
}
