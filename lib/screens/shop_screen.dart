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
        leadingWidth: 48,
        leading: IconButton(
          padding: const EdgeInsets.only(left: 12),
          onPressed: () => Navigator.of(context).pop(),
          icon: const _GradientText(
            '<',
            fontSize: 14,
          ),
        ),
        title: const _GradientText(
          'NEOFLEX MERCH SHOP',
          fontSize: 12,
          textAlign: TextAlign.center,
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
                    _GradientText(
                      'ТВОИ БАЛЛЫ: ${state.gamePoints}',
                      fontSize: 12,
                      textAlign: TextAlign.center,
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
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          stops: [0.0, 0.2, 0.49, 0.71, 0.95],
                                          colors: [
                                            Color(0xFFEA872B),
                                            Color(0xFFE63E32),
                                            Color(0xFFD40655),
                                            Color(0xFFAB095F),
                                            Color(0xFF8B1163),
                                          ],
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

class _GradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final TextAlign? textAlign;

  const _GradientText(
    this.text, {
    required this.fontSize,
    this.textAlign,
  });

  static const LinearGradient _gradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.0, 0.33, 0.58, 0.78, 1.0],
    colors: [
      Color(0xFF8F1162),
      Color(0xFFC0045C),
      Color(0xFFC5035C),
      Color(0xFFE74B31),
      Color(0xFFEB9B2A),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return _gradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        );
      },
      child: Text(
        text,
        textAlign: textAlign,
        style: GoogleFonts.getFont(
          'Press Start 2P',
          fontSize: fontSize,
          letterSpacing: 1.5,
          color: Colors.white,
        ),
      ),
    );
  }
}
