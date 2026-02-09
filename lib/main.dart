import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoe_store/home_screen/home_screen.dart';
import 'package:shoe_store/home_screen/onboarding.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Check if onboarding was previously completed
  final prefs = await SharedPreferences.getInstance();
  final bool onboardingComplete = prefs.getBool('onboarding_complete') ?? false;

  runApp(
    // Wrapping the App with ProviderScope for future Riverpod state management
    ProviderScope(
      child: MyApp(onboardingComplete: onboardingComplete),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool onboardingComplete;
  
  const MyApp({super.key, required this.onboardingComplete});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shoe_Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9F6F1),
        useMaterial3: true,
        fontFamily: 'Roboto', // Using standard font, Noto Sans CJK for multi-lang if needed
      ),
      // Use the persisted state to decide the home screen
      home: onboardingComplete ? const HomeScreen() : const OnboardingScreen(),
    );
  }
}