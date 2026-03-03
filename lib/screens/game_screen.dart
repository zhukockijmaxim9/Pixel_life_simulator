import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../widgets/pixel_progress_bar.dart';
import '../widgets/event_dialog.dart';

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
        Navigator.pushReplacementNamed(context, '/planning');
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              '🎯',
                              state.savingsGoal,
                              Colors.cyanAccent,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
}
