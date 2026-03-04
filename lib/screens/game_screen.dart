import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../widgets/pixel_progress_bar.dart';
import '../widgets/event_dialog.dart';
import '../widgets/meal_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _isMealShowing = false;
  StreamSubscription<String>? _notificationSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = Provider.of<GameState>(context, listen: false);
      _notificationSubscription = state.notifications.listen((message) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                message,
                style: GoogleFonts.getFont('Press Start 2P', fontSize: 10),
              ),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }

  Color _getCharacterColor(double mood) {
    if (mood > 80) return Colors.greenAccent;
    if (mood < 40) return Colors.redAccent;
    return Colors.white;
  }

  void _showMealDialog(BuildContext context, GameState state) {
    if (state.needsMeal && !_isMealShowing) {
      _isMealShowing = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => MealDialog(
            foodBudget: state.foodBudget,
            onChosen: (type) {
              state.chooseMeal(type);
              _isMealShowing = false;
              Navigator.pop(context);
            },
          ),
        ).then((_) {
          _isMealShowing = false;
        });
      });
    }
  }

  void _showBudgetDialog(BuildContext context, GameState state) {
    // Local copies
    int localWallet = state.walletPercentage;
    int localEmergency = state.emergencyPercentage;
    int localMandatory = state.mandatoryPercentage;
    GameGoal? localGoal = state.selectedGoal;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          double surplus =
              state.salary - (localGoal?.monthlyContribution ?? 0.0);
          return AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.white, width: 4),
              borderRadius: BorderRadius.zero,
            ),
            title: Text(
              'БЮДЖЕТ И ЦЕЛИ',
              style: GoogleFonts.getFont(
                'Press Start 2P',
                fontSize: 12,
                color: Colors.yellowAccent,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'РАСПРЕДЕЛЕНИЕ:',
                    style: GoogleFonts.getFont(
                      'Press Start 2P',
                      fontSize: 8,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _dialogSlider(
                    label: 'КОШЕЛЕК',
                    value: localWallet.toDouble(),
                    surplus: surplus,
                    onChanged: (val) {
                      double rem = 100 - val;
                      double oldSum = (localEmergency + localMandatory)
                          .toDouble();
                      if (oldSum > 0) {
                        localEmergency = (rem * (localEmergency / oldSum))
                            .toInt();
                        localMandatory = (rem * (localMandatory / oldSum))
                            .toInt();
                      } else {
                        localEmergency = (rem / 2).toInt();
                        localMandatory = (rem / 2).toInt();
                      }
                      localWallet = val.toInt();
                      setState(() {});
                    },
                  ),
                  _dialogSlider(
                    label: 'ПОДУШКА',
                    value: localEmergency.toDouble(),
                    surplus: surplus,
                    onChanged: (val) {
                      double rem = 100 - val;
                      double oldSum = (localWallet + localMandatory).toDouble();
                      if (oldSum > 0) {
                        localWallet = (rem * (localWallet / oldSum)).toInt();
                        localMandatory = (rem * (localMandatory / oldSum))
                            .toInt();
                      } else {
                        localWallet = (rem / 2).toInt();
                        localMandatory = (rem / 2).toInt();
                      }
                      localEmergency = val.toInt();
                      setState(() {});
                    },
                  ),
                  _dialogSlider(
                    label: 'ОБЯЗАТЕЛЬНЫЕ',
                    value: localMandatory.toDouble(),
                    surplus: surplus,
                    onChanged: (val) {
                      double rem = 100 - val;
                      double oldSum = (localWallet + localEmergency).toDouble();
                      if (oldSum > 0) {
                        localWallet = (rem * (localWallet / oldSum)).toInt();
                        localEmergency = (rem * (localEmergency / oldSum))
                            .toInt();
                      } else {
                        localWallet = (rem / 2).toInt();
                        localEmergency = (rem / 2).toInt();
                      }
                      localMandatory = val.toInt();
                      setState(() {});
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.white10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'НА ЦЕЛЬ (ФИКС):',
                          style: GoogleFonts.getFont(
                            'Press Start 2P',
                            fontSize: 6,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${localGoal?.monthlyContribution.toInt() ?? 0} ₽',
                          style: GoogleFonts.getFont(
                            'Press Start 2P',
                            fontSize: 6,
                            color: Colors.yellowAccent,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  Text(
                    'СМЕНИТЬ ЦЕЛЬ:',
                    style: GoogleFonts.getFont(
                      'Press Start 2P',
                      fontSize: 8,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...GameState.availableGoals.map((goal) {
                    bool isSelected = localGoal?.title == goal.title;
                    return InkWell(
                      onTap: () {
                        localGoal = goal;
                        setState(() {});
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? Colors.cyanAccent
                                : Colors.white24,
                          ),
                          color: isSelected
                              ? Colors.cyanAccent.withValues(alpha: 0.1)
                              : null,
                        ),
                        child: Row(
                          children: [
                            Text(
                              isSelected ? '▶' : ' ',
                              style: const TextStyle(color: Colors.cyanAccent),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                goal.title,
                                style: GoogleFonts.getFont(
                                  'Press Start 2P',
                                  fontSize: 8,
                                  color: isSelected
                                      ? Colors.cyanAccent
                                      : Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              '${goal.cost.toInt()}₽',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'ОТМЕНА',
                  style: GoogleFonts.getFont(
                    'Press Start 2P',
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  state.updateDistribution(
                    localWallet,
                    localEmergency,
                    localMandatory,
                  );
                  if (localGoal != null) {
                    state.setGoal(localGoal!);
                  }
                  Navigator.pop(context);
                },
                child: Text(
                  'ПРИМЕНИТЬ',
                  style: GoogleFonts.getFont(
                    'Press Start 2P',
                    fontSize: 10,
                    color: Colors.cyanAccent,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _dialogSlider({
    required String label,
    required double value,
    required double surplus,
    required ValueChanged<double> onChanged,
  }) {
    double moneyAmount = surplus * (value / 100);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.getFont(
                'Press Start 2P',
                fontSize: 7,
                color: Colors.white70,
              ),
            ),
            Text(
              '${value.toInt()}% (${moneyAmount.toInt()} ₽)',
              style: GoogleFonts.getFont(
                'Press Start 2P',
                fontSize: 7,
                color: Colors.cyanAccent,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: 100,
          divisions: 20,
          activeColor: Colors.cyanAccent,
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameState>(context);

    // Navigation and Popups
    if (state.isGameOver) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/summary');
      });
    }

    _showMealDialog(context, state);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // Status Bar (Accounts & Time)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E1E),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _accountPanel(
                                    '👛',
                                    state.walletBalance,
                                    Colors.yellowAccent,
                                  ),
                                  _accountPanel(
                                    '🛡️',
                                    state.emergencyFund,
                                    Colors.orangeAccent,
                                  ),
                                  _accountPanel(
                                    '📜',
                                    state.mandatoryBalance,
                                    Colors.lightBlueAccent,
                                  ),
                                  _accountPanel(
                                    '🎯',
                                    state.savingsGoal,
                                    Colors.cyanAccent,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'МЕСЯЦ ${state.currentMonth}',
                                    style: GoogleFonts.getFont(
                                      'Press Start 2P',
                                      fontSize: 8,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    'ДЕНЬ ${state.currentDay} / 30',
                                    style: GoogleFonts.getFont(
                                      'Press Start 2P',
                                      fontSize: 8,
                                      color: Colors.white,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        _showBudgetDialog(context, state),
                                    child: const Icon(
                                      Icons.account_balance_wallet,
                                      color: Colors.cyanAccent,
                                      size: 16,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        Navigator.pushNamed(context, '/shop'),
                                    child: const Icon(
                                      Icons.shopping_cart,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // Character Section
                        Icon(
                          Icons.person,
                          size: 150,
                          color: _getCharacterColor(state.mood),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'СУДЬБА В ПИКСЕЛЯХ',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'ЦЕЛЬ МЕСЯЦА: 8000 ₽',
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.cyanAccent,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Mood & Hunger Indicators
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: PixelProgressBar(
                                label: 'НАСТРОЕНИЕ',
                                value: state.mood,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E1E1E),
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      '🍎',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${state.daysToHunger} ДН.',
                                      style: GoogleFonts.getFont(
                                        'Press Start 2P',
                                        fontSize: 6,
                                        color: state.daysToHunger <= 1
                                            ? Colors.redAccent
                                            : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Game Actions
                Container(
                  padding: const EdgeInsets.all(20),
                  child: _pixelButton(
                    'РАБОТАТЬ (ПРОМОТКА)',
                    Colors.cyanAccent,
                    onPressed: () => state.nextTurn(),
                  ),
                ),
              ],
            ),
            if (state.currentEvent != null)
              EventDialog(
                event: state.currentEvent!,
                onResolve: (accepted, {quizAnswerIndex, courseChoice}) {
                  state.resolveEvent(
                    accepted,
                    quizAnswerIndex: quizAnswerIndex,
                    courseChoice: courseChoice,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _accountPanel(String icon, double value, Color color) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 4),
        Text(
          value.toStringAsFixed(0),
          style: TextStyle(
            fontSize: 9,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _pixelButton(
    String label,
    Color color, {
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.black,
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
