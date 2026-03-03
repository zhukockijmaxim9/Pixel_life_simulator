import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../widgets/pixel_progress_bar.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  Color _getCharacterColor(double mood) {
    if (mood > 80) return Colors.greenAccent;
    if (mood < 40) return Colors.redAccent;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Consumer<GameState>(
        builder: (context, state, child) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Status Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '💰 ${state.money.toStringAsFixed(0)} ₽',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        'ДЕНЬ ${state.currentDay} / 30',
                        style: const TextStyle(fontSize: 10),
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
                    style: const TextStyle(fontSize: 14),
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
                      onPressed: () => state.nextTurn(3),
                      child: const Text('РАБОТАТЬ (+3 ДНЯ)'),
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
}
