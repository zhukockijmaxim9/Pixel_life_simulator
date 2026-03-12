import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161616),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 16,
            color: Color(0xFFFF2E93),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: RichText(
          text: TextSpan(
            style: GoogleFonts.getFont(
              'Press Start 2P',
              fontSize: 12,
              letterSpacing: 1.5,
            ),
            children: const [
              TextSpan(
                text: 'NEOFLEX ',
                style: TextStyle(color: Color(0xFFFF2E93)),
              ),
              TextSpan(
                text: 'MERCH ',
                style: TextStyle(color: Colors.white),
              ),
              TextSpan(
                text: 'SHOP',
                style: TextStyle(color: Color(0xFFFFA500)),
              ),
            ],
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(
            height: 4,
            color: const Color(0xFF2B2B2B),
          ),
        ),
      ),
      body: Consumer<GameState>(
        builder: (context, state, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                color: const Color(0xFF111111),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'ТВОИ БАЛЛЫ: ${state.gamePoints}',
                      style: GoogleFonts.getFont(
                        'Press Start 2P',
                        fontSize: 12,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'официальный мерч neoflex',
                      style: GoogleFonts.getFont(
                        'Press Start 2P',
                        fontSize: 8,
                        color: const Color(0xFF888888),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.78,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: GameState.shopItems.length,
                  itemBuilder: (context, index) {
                    final item = GameState.shopItems[index];
                    final canAfford = state.gamePoints >= item.price;

                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF181818),
                        border: Border.all(
                          color: const Color(0xFF444444),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Image.asset(
                                  item.assetPath,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              item.name.toLowerCase(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.getFont(
                                'Press Start 2P',
                                fontSize: 8,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                            child: SizedBox(
                              height: 32,
                              width: double.infinity,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: canAfford
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0xFFFF7A00),
                                            Color(0xFFFF2E93),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        )
                                      : const LinearGradient(
                                          colors: [
                                            Color(0xFF555555),
                                            Color(0xFF444444),
                                          ],
                                        ),
                                ),
                                child: TextButton(
                                  onPressed: canAfford
                                      ? () => state.buyItem(item)
                                      : null,
                                  child: Text(
                                    'КУПИТЬ',
                                    style: GoogleFonts.getFont(
                                      'Press Start 2P',
                                      fontSize: 8,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
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
