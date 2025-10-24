import 'package:flutter/foundation.dart';
import 'package:solo_04/models/event.dart';
import 'package:solo_04/services/events_db.dart';

class EventModel {
  EventModel._private();
  static final EventModel instance = EventModel._private();

  final ValueNotifier<List<Event>> events = ValueNotifier<List<Event>>([]);

  final USUDatabase _db = USUDatabase();

  /// Load events from the database into the in-memory list.
  Future<void> loadEvents() async {
    final dbEvents = await _db.fetchAllEvents();
    events.value = dbEvents;
  }

  void add(Event e) {
    events.value = [...events.value, e];

    // Persist the new event to the database.
    _db.upsertEvent(e);
  }

  void update(Event updated) {
    events.value = events.value
        .map((e) => e.id == updated.id ? updated : e)
        .toList();

    // Update the database record as well.
    _db.upsertEvent(updated);
  }

  void toggleSignUp(String id, bool value) {
    final idx = events.value.indexWhere((e) => e.id == id);
    if (idx < 0) return;
    final newList = List<Event>.from(events.value);
    newList[idx] = newList[idx].copyWith(signedUp: value);
    events.value = newList;

    // Update the database record as well.
    _db.upsertEvent(newList[idx]);
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

  /// Remove an event by id.
  void remove(String id) {
    events.value = events.value.where((e) => e.id != id).toList();

    // Also remove from the database.
    _db.deleteEvent(id);
  }
}
