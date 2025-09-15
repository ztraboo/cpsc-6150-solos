import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Background fills all remaining space
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/_splash/splash_stars.png'),
                    fit: BoxFit.cover,            // <-- key: preserves aspect, no squashing
                    alignment: Alignment.center,
                  ),
                  // put gradient on TOP of the image:
                  // (use foregroundDecoration so you don't replace the image)
                ),
                foregroundDecoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF3C116D).withOpacity(0.65),
                      Colors.transparent,
                      Color(0xFFB1A8A8).withOpacity(0.65),
                    ],
                    stops: const [0.0, 0.40, 1.0],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Horoscopes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 44),
                        child: Text(
                          'Explore different zodiacs',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom CTA
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 22, 16, 22),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: TextButton(
                    onPressed: () => {
                      // Go to Zodiac Dashboard screen.
                      Navigator.pushReplacementNamed(context, '/zodiac_dashboard', arguments: {
                        // No arguments needed for dashboard
                      })
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF2175c1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
      ),
    );
  }
}