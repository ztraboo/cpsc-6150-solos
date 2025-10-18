import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Small reusable widget shown when the cart is empty.
/// Includes an SVG image and some instructional text.

class EventsEmpty extends StatelessWidget {
  const EventsEmpty({
    super.key,
    required this.darkMode,
    required this.title,
    required this.message,
  });

  final bool darkMode;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final maxImageSize = math.min(375.0, mq.height * 0.45);

    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Shows an illustration of an empty events illustration. Constrain
            // the size so it doesn't overflow smaller viewports (tests, small
            // windows).
            Flexible(
              child: SizedBox(
                width: maxImageSize,
                height: maxImageSize,
                child: SvgPicture.asset(
                  darkMode ? 'assets/usu_logo_dark.svg' : 'assets/usu_logo.svg',
                  fit: BoxFit.contain,
                  semanticsLabel: 'Empty events',
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Text instructions on how to add items to the cart.
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).textTheme.bodySmall?.color?.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
