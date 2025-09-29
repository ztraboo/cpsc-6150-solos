import 'package:flutter/services.dart';

class MaxValueTextInputFormatter extends TextInputFormatter {
  MaxValueTextInputFormatter({
    required this.max,
    this.allowDecimal = true,
    this.maxDecimalPlaces,
  });

  final double max;
  final bool allowDecimal;
  final int? maxDecimalPlaces;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final t = newValue.text;

    // Allow clearing
    if (t.isEmpty) return newValue;

    // Character-level guard
    final pattern = allowDecimal ? RegExp(r'^\d*\.?\d*$') : RegExp(r'^\d*$');
    if (!pattern.hasMatch(t)) return oldValue;

    // Optional decimal place cap
    if (allowDecimal && maxDecimalPlaces != null && t.contains('.')) {
      final parts = t.split('.');
      if (parts.length > 2 || parts[1].length > maxDecimalPlaces!) {
        return oldValue;
      }
    }

    // Let user type things like "0." or trailing dot before number is complete
    if (t == '.' || t.endsWith('.')) return newValue;

    final value = double.tryParse(t);
    if (value == null) return oldValue;

    // Hard cap
    if (value > max) return oldValue;

    return newValue;
  }
}
