import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../widgets/pixel_progress_bar.dart';
import '../widgets/event_dialog.dart';
import '../widgets/meal_dialog.dart';
import '../widgets/transaction_dialog.dart';
import '../widgets/course_shop_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _isMealShowing = false;
  bool _monthSummaryShown = false;

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

  void _showCourseShop(BuildContext context, GameState state) {
    showDialog(
      context: context,
      builder: (context) => CourseShopDialog(
        walletBalance: state.deferredFund,
        completedCourses: state.completedCourses,
        onBuy: (course) {
          state.buyCourse(course);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showMonthSummaryDialog(BuildContext context, GameState state) {
    if (state.showMonthSummary && !_monthSummaryShown) {
      _monthSummaryShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final rent = state.currentRent;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.cyanAccent, width: 3),
              borderRadius: BorderRadius.zero,
            ),
            title: Text(
              '📋 ОБЯЗАТЕЛЬНЫЕ РАСХОДЫ',
              style: GoogleFonts.getFont(
                'Press Start 2P',
                fontSize: 11,
                color: Colors.cyanAccent,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'В этом месяце вам предстоит оплатить:',
                  style: GoogleFonts.getFont(
                    'Press Start 2P',
                    fontSize: 9,
                    color: Colors.white70,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                _summaryPaymentRow('🏠 Аренда жилья', '${rent.toInt()} ₽', 'день 2'),
                const SizedBox(height: 8),
                _summaryPaymentRow('💡 Коммунальные', '4 000 ₽', 'день 5'),
                const SizedBox(height: 8),
                _summaryPaymentRow('🚌 Транспорт', '3 000 ₽', 'день 10'),
                const SizedBox(height: 16),
                const Divider(color: Colors.white24),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ИТОГО:',
                      style: GoogleFonts.getFont(
                        'Press Start 2P',
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${(rent + 4000 + 3000).toInt()} ₽',
                      style: GoogleFonts.getFont(
                        'Press Start 2P',
                        fontSize: 10,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  onPressed: () {
                    state.dismissMonthSummary();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'ПОНЯТНО',
                    style: GoogleFonts.getFont('Press Start 2P', fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
        );
      });
    }
  }

  Widget _summaryPaymentRow(String label, String amount, String day) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.getFont(
              'Press Start 2P',
              fontSize: 8,
              color: Colors.white,
            ),
          ),
        ),
        Text(
          amount,
          style: GoogleFonts.getFont(
            'Press Start 2P',
            fontSize: 8,
            color: Colors.orangeAccent,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          day,
          style: GoogleFonts.getFont(
            'Press Start 2P',
            fontSize: 7,
            color: Colors.grey,
          ),
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

    _showMonthSummaryDialog(context, state);
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
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.account_balance_wallet, color: Colors.white, size: 14),
                                    const SizedBox(width: 6),
                                    Text(
                                      'ОБЩИЙ БАЛАНС: ${state.totalMoney.toInt()} ₽',
                                      style: GoogleFonts.getFont('Press Start 2P', fontSize: 10, color: Colors.greenAccent),
                                    ),
                                  ],
                                ),
                              ),
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
                                    '📦',
                                    state.deferredFund,
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
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    'ДЕНЬ ${state.currentDay} / 30',
                                    style: GoogleFonts.getFont(
                                      'Press Start 2P',
                                      fontSize: 10,
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
                                      size: 18,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        Navigator.pushNamed(context, '/shop'),
                                    child: const Icon(
                                      Icons.shopping_cart,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                  if (state.isCourseShopAvailable)
                                    GestureDetector(
                                      onTap: () => _showCourseShop(context, state),
                                      child: const Icon(
                                        Icons.school,
                                        color: Colors.greenAccent,
                                        size: 18,
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
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            'ЦЕЛЬ МЕСЯЦА: ${state.selectedGoal?.cost.toInt() ?? 0} ₽',
                            style: const TextStyle(
                              fontSize: 10,
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
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${state.daysToHunger} ДН.',
                                      style: GoogleFonts.getFont(
                                        'Press Start 2P',
                                        fontSize: 8,
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
            if (state.pendingTransaction != null)
              TransactionDialog(
                transaction: state.pendingTransaction!,
                state: state,
                onReallocate: () {
                  Navigator.pushNamed(context, '/budget_settings');
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
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 4),
        Text(
          value.toStringAsFixed(0),
          style: TextStyle(
            fontSize: 11,
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
