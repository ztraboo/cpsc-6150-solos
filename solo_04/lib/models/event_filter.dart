import 'package:flutter/foundation.dart';

// Filter singleton for multi-select chips
class EventFilter {
  EventFilter._();
  static final EventFilter instance = EventFilter._();

  final ValueNotifier<Set<String>> selectedSizes = ValueNotifier<Set<String>>(
    <String>{},
  );
  final ValueNotifier<Set<String>> selectedMonths = ValueNotifier<Set<String>>(
    <String>{},
  );

  void clear() {
    selectedSizes.value = <String>{};
    selectedMonths.value = <String>{};
  }
}
