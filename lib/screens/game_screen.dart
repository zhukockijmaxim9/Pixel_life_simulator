import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      '/budget_settings',
                                    ),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            'ЦЕЛЬ МЕСЯЦА: ${state.selectedGoal?.cost.toInt() ?? 0} ₽',
                            style: const TextStyle(
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
