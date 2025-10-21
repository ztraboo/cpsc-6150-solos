import 'package:flutter/foundation.dart';
import 'package:solo_04/models/event.dart';

class EventRepository {
  EventRepository._private();
  static final EventRepository instance = EventRepository._private();

  final ValueNotifier<List<Event>> events = ValueNotifier<List<Event>>([]);

  void add(Event e) {
    events.value = [...events.value, e];
  }

  void update(Event updated) {
    events.value = events.value
        .map((e) => e.id == updated.id ? updated : e)
        .toList();
  }

  void toggleSignUp(String id, bool value) {
    final idx = events.value.indexWhere((e) => e.id == id);
    if (idx < 0) return;
    final newList = List<Event>.from(events.value);
    newList[idx] = newList[idx].copyWith(signedUp: value);
    events.value = newList;
  }

  /// Enable or disable sign-up for an event.
  /// Encapsulates mutations to `allowSignUp`.
  void setAllowSignUp(String id, bool value) {
    final idx = events.value.indexWhere((e) => e.id == id);
    if (idx < 0) return;
    final newList = List<Event>.from(events.value);
    newList[idx] = newList[idx].copyWith(allowSignUp: value);
    events.value = newList;
  }
}
