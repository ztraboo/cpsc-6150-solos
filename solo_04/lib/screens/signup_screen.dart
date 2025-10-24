import 'package:flutter/material.dart';
import 'package:solo_04/models/event.dart';
import 'package:solo_04/models/event_filter.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:solo_04/models/event_model.dart';
import 'package:solo_04/widgets/event_details.dart';
import 'package:solo_04/widgets/events_empty.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({
    super.key,
    required bool darkMode,
  }) : _darkMode = darkMode;

  final bool _darkMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ValueListenableBuilder<List<Event>>(
        valueListenable: EventModel.instance.events,
        builder: (context, events, _) {
          if (events.isEmpty) {
            return EventsEmpty(
              darkMode: _darkMode,
              title: 'Your sign up event list is empty',
              message: 'No sign up events have been created. Wait for an event to be created by the USU staff.'
            );
          }

          // Build distinct sizes and months from data
          final sizes = events.map((e) => e.size).toSet().toList()..sort();
          final months =
              events
                  .map((e) {
                    try {
                      final dt = DateTime.parse(e.arrivalDateTimeIso);
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
                  'Use the checkbox on the right of each event to select it for sign up. Events with closed sign-up cannot be selected. Times shown are USU volunteer arrival times for the event. Use the filters below to narrow down the list of events displayed.',
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
                                  final dt = DateTime.parse(e.arrivalDateTimeIso);
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
                          trailing: (Event e) => Transform.scale(
                            scale: 1.2,
                            child: Checkbox(

                              value: e.signedUp,
                              onChanged: e.allowSignUp
                                  ? (val) {
                                      EventModel.instance.toggleSignUp(e.id, val ?? false);
                                    }
                                  : null,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                              side: BorderSide(color: (e.allowSignUp ? Colors.white : Colors.grey.shade600), width: 2.0),
                            ),
                          ),
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
