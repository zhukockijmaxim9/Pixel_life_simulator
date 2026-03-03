import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          'NEOFLEX MERCH',
          style: GoogleFonts.getFont('Press Start 2P', fontSize: 16),
        ),
        backgroundColor: const Color(0xFF005EB8), // Neoflex Blue
        elevation: 0,
      ),
      body: Consumer<GameState>(
        builder: (context, state, child) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                color: const Color(0xFF1E1E1E),
                child: Column(
                  children: [
                    Text(
                      'ТВОИ БАЛЛЫ: ${state.gamePoints}',
                      style: GoogleFonts.getFont(
                        'Press Start 2P',
                        fontSize: 14,
                        color: Colors.yellowAccent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Официальный мерч Neoflex',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: GameState.shopItems.length,
                  itemBuilder: (context, index) {
                    final item = GameState.shopItems[index];
                    final canAfford = state.gamePoints >= item.price;

                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        color: const Color(0xFF1E1E1E),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(item.icon, style: const TextStyle(fontSize: 40)),
                          const SizedBox(height: 10),
                          Text(
                            item.name.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 8),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${item.price} БАЛЛОВ',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.yellowAccent,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: canAfford
                                  ? Colors.greenAccent
                                  : Colors.grey,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                            ),
                            onPressed: canAfford
                                ? () => state.buyItem(item)
                                : null,
                            child: const Text(
                              'КУПИТЬ',
                              style: TextStyle(fontSize: 8),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
