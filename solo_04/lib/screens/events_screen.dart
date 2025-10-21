import 'package:flutter/material.dart';
import 'package:solo_04/models/event.dart';
import 'package:solo_04/models/event_filter.dart';
import 'package:solo_04/models/event_model.dart';
import 'package:solo_04/screens/create_events_screen.dart';
import 'package:solo_04/widgets/event_details.dart';
import 'package:solo_04/widgets/events_empty.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({
    super.key,
    required bool darkMode,
  }) : _darkMode = darkMode;

  final bool _darkMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ValueListenableBuilder<List<Event>>(
        valueListenable: EventRepository.instance.events,
        builder: (context, events, _) {
          if (events.isEmpty) {
            // return Center(child: Text('No events created yet.'));
            return EventsEmpty(
              darkMode: _darkMode,
              title: 'Your event list is empty',
              message: 'No events have been created. Click the + button to create an event.', 
            );
          }

          final sizes = events.map((e) => e.size).toSet().toList()..sort();
          final months =
              events
                  .map((e) {
                    try {
                      final dt = DateTime.parse(e.dateTimeIso);
                      return '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}';
                    } catch (_) {
                      return null;
                    }
                  })
                  .whereType<String>()
                  .toSet()
                  .toList()
                ..sort();

          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  'Use the Add Event button to create new events. Use the filters below to narrow down the list of events displayed.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(width: 4),
                    ValueListenableBuilder<Set<String>>(
                      valueListenable: EventFilter.instance.selectedSizes,
                      builder: (context, selectedSizes, _) {
                        return Row(
                          children: sizes.map((sz) {
                            final label = (sz == 'large')
                                ? 'Large'
                                : (sz == 'small')
                                ? 'Small'
                                : sz;
                            final isSelected = selectedSizes.contains(sz);
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              child: ChoiceChip(
                                label: Text(label),
                                selected: isSelected,
                                onSelected: (_) {
                                  final next = Set<String>.from(selectedSizes);
                                  if (next.contains(sz)) {
                                    next.remove(sz);
                                  } else {
                                    next.add(sz);
                                  }
                                  EventFilter.instance.selectedSizes.value =
                                      next;
                                },
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    ValueListenableBuilder<Set<String>>(
                      valueListenable: EventFilter.instance.selectedMonths,
                      builder: (context, selectedMonths, _) {
                        return Row(
                          children: months.map((m) {
                            final parts = m.split('-');
                            final y = int.tryParse(parts[0]) ?? 0;
                            final mm = int.tryParse(parts[1]) ?? 0;
                            final monthName = DateTime(y, mm).month == mm
                                ? MaterialLocalizations.of(
                                    context,
                                  ).formatMonthYear(DateTime(y, mm))
                                : m;
                            final isSelected = selectedMonths.contains(m);
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              child: ChoiceChip(
                                label: Text(monthName),
                                selected: isSelected,
                                onSelected: (_) {
                                  final next = Set<String>.from(selectedMonths);
                                  if (next.contains(m)) {
                                    next.remove(m);
                                  } else {
                                    next.add(m);
                                  }
                                  EventFilter.instance.selectedMonths.value =
                                      next;
                                },
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => EventFilter.instance.clear(),
                      child: const Text('Clear Filters'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ValueListenableBuilder<Set<String>>(
                  valueListenable: EventFilter.instance.selectedSizes,
                  builder: (context, selectedSizes, _) {
                    return ValueListenableBuilder<Set<String>>(
                      valueListenable: EventFilter.instance.selectedMonths,
                      builder: (context, selectedMonths, _) {
                        final filtered = events.where((e) {
                          final matchesSize =
                              selectedSizes.isEmpty ||
                              selectedSizes.contains(e.size);
                          final matchesMonth =
                              selectedMonths.isEmpty ||
                              (() {
                                try {
                                  final dt = DateTime.parse(e.dateTimeIso);
                                  final key =
                                      '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}';
                                  return selectedMonths.contains(key);
                                } catch (_) {
                                  return false;
                                }
                              })();
                          return matchesSize && matchesMonth;
                        }).toList();

                        if (filtered.isEmpty) {
                          return Center(
                            child: Text('No events match the filters.'),
                          );
                        }

                        return EventDetails(
                          darkMode: _darkMode,
                          filtered: filtered,
                          trailing: (Event e) => IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CreateEventScreen(event: filtered[filtered.indexOf(e)]),
                                ),
                              );
                            },
                          )
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
