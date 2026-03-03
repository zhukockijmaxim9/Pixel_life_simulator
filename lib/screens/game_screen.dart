import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../widgets/pixel_progress_bar.dart';
import '../widgets/event_dialog.dart';
import '../widgets/budget_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _isDialogShowing = false;
  bool _isPlanningShowing = false;

  Color _getCharacterColor(double mood) {
    if (mood > 80) return Colors.greenAccent;
    if (mood < 40) return Colors.redAccent;
    return Colors.white;
  }

  void _showEventIfNeeded(BuildContext context, GameState state) {
    if (state.currentEvent != null && !_isDialogShowing) {
      _isDialogShowing = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => EventDialog(
            event: state.currentEvent!,
            onResolve: (accepted, {quizAnswerIndex}) {
              state.resolveEvent(accepted, quizAnswerIndex: quizAnswerIndex);
              _isDialogShowing = false;
              Navigator.of(context).pop();
            },
          ),
        ).then((_) {
          _isDialogShowing = false;
        });
      });
    }
  }

  void _showPlanningIfNeeded(BuildContext context, GameState state) {
    if (state.isPlanningPhase && !_isPlanningShowing) {
      _isPlanningShowing = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => BudgetDialog(
            totalToDistribute: state
                .walletBalance, // In planning phase, all money is temporarily in wallet
            onDistribute:
                ({
                  required toWallet,
                  required toEmergency,
                  required toSavings,
                }) {
                  state.distributeBudget(
                    toWallet: toWallet,
                    toEmergency: toEmergency,
                    toSavings: toSavings,
                  );
                  _isPlanningShowing = false;
                  Navigator.of(context).pop();
                },
          ),
        ).then((_) {
          _isPlanningShowing = false;
        });
      });
    }
  }

  void _showGameOverIfNeeded(BuildContext context, GameState state) {
    if (state.isGameOver) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/summary', (route) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Consumer<GameState>(
        builder: (context, state, child) {
          _showEventIfNeeded(context, state);
          _showPlanningIfNeeded(context, state);
          _showGameOverIfNeeded(context, state);

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Status Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _balanceText(
                            '👜 ${state.walletBalance.toStringAsFixed(0)}',
                            Colors.yellowAccent,
                          ),
                          _balanceText(
                            '🏥 ${state.emergencyFund.toStringAsFixed(0)}',
                            Colors.orangeAccent,
                          ),
                          _balanceText(
                            '🎯 ${state.savingsGoal.toStringAsFixed(0)}',
                            Colors.cyanAccent,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'МЕСЯЦ ${state.currentMonth}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'ДЕНЬ ${state.currentDay} / 30',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.pushNamed(context, '/shop'),
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Character Section
                  Icon(
                    Icons.person,
                    size: 150,
                    color: _getCharacterColor(state.mood),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    state.selectedJob?.title ?? 'БЕЗРАБОТНЫЙ',
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  if (state.selectedGoal != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'ЦЕЛЬ: ${state.selectedGoal!.title} (${state.selectedGoal!.cost.toStringAsFixed(0)} ₽)',
                        style: const TextStyle(
                          fontSize: 8,
                          color: Colors.cyanAccent,
                        ),
                      ),
                    ),
                  const Spacer(),
                  // Progress Bars
                  PixelProgressBar(value: state.mood, label: 'НАСТРОЕНИЕ'),
                  const SizedBox(height: 40),
                  // Controls
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                      ),
                      onPressed:
                          state.currentEvent == null &&
                              !state.isGameOver &&
                              !state.isPlanningPhase
                          ? () => state.nextTurn()
                          : null,
                      child: const Text('РАБОТАТЬ (+?), КИДАТЬ КОСТЬ'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      onPressed: () =>
                          Navigator.pushNamed(context, '/planning'),
                      child: const Text('ПЛАНИРОВАНИЕ'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _balanceText(String text, Color color) {
    return Text(text, style: TextStyle(fontSize: 9, color: color, height: 1.5));
  }
}
