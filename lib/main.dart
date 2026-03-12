import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'screens/main_menu_screen.dart';
import 'screens/game_screen.dart';
import 'screens/job_selection_screen.dart';
import 'screens/planning_screen.dart';
import 'screens/shop_screen.dart';

import 'screens/summary_screen.dart';
import 'screens/budget_settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final gameState = GameState();
  await gameState.loadFromDisk();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider.value(value: gameState)],
      child: const PixelPurseApp(),
    ),
  );
}

class PixelPurseApp extends StatelessWidget {
  const PixelPurseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixel Purse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.cyanAccent,
        textTheme: GoogleFonts.getTextTheme(
          'Press Start 2P',
          ThemeData.dark().textTheme,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.cyanAccent,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            side: const BorderSide(color: Colors.white, width: 2),
            textStyle: GoogleFonts.getFont(
              'Press Start 2P',
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainMenuScreen(),
        '/job_select': (context) => const JobSelectionScreen(),
        '/game': (context) => const GameScreen(),
        '/planning': (context) => const PlanningScreen(),
        '/shop': (context) => const ShopScreen(),
        '/summary': (context) => const SummaryScreen(),
        '/budget_settings': (context) => const BudgetSettingsScreen(),
      },
    );
  }
}
