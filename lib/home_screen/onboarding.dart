import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Custom colors based on the images provided
    const backgroundColor = Color(0xFFF9F6F1);
    const primaryBrown = Color(0xFF6B4E37);
    // const textSecondary = Color(0xFF8C7A6B);

    return Scaffold(
      backgroundColor: backgroundColor,
      body:
        Column(
          children: [
            // Top Image Section
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                // margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.only(
                  //   topLeft: Radius.circular(24),
                  //   topRight: Radius.circular(24),
                  // ),
                  image: const DecorationImage(
                    image: AssetImage('assets/img/shoe1.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Text Section
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 21),
                    const Text(
                      'Archive your pads\nwith one touch',
                      style: TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6B4E37),
                        height: 1.2,
                        letterSpacing: 0
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Add dimensions, materials and revision history to always find what you need',
                      style: TextStyle(
                        fontSize: 16,
                        color: primaryBrown,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Button Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _completeOnboarding(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBrown,
                    foregroundColor: backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}