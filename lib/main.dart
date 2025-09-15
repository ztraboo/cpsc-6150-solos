import 'package:flutter/material.dart';
import 'package:solo_01/ui/screens/splash.dart';
import 'package:solo_01/ui/screens/zodiac_dashboard.dart';
import 'package:solo_01/ui/screens/zodiac_details.dart';
import 'package:solo_01/ui/services/zodiac_sign.dart';

void main() {
  // runApp(const MyApp());
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const Splash(),
      '/zodiac_dashboard': (context) => const ZodiacDashboard(),
      '/zodiac_detail': (context) {
        final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        final ZodiacSign sign = args['zodiacSign'] as ZodiacSign;
        return ZodiacDetailsPage(zodiacSign: sign);
      },
    },
  ));
}
  