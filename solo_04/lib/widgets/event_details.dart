import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solo_04/models/event.dart';
import 'package:solo_04/screens/create_events_screen.dart';

class EventDetails extends StatelessWidget {
  const EventDetails({
    super.key,
    required bool darkMode,
    required List<Event> filtered,
    required Widget trailing,
  }) : _darkMode = darkMode,
       _filtered = filtered,
       _trailing = trailing;

  final bool _darkMode;
  final List<Event> _filtered;
  final Widget _trailing;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, idx) {
        final e = _filtered[idx];
        return Card(
          color: _darkMode ? Colors.grey[800] : Colors.white,
          child: ListTile(
            title: Text(
              e.show,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: (_darkMode ? Colors.white : Colors.black),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Builder(
                  builder: (context) {
                    String formatted = '';
                    try {
                      final dt = DateTime.parse(e.dateTimeIso);
                      const wk = [
                        'Monday',
                        'Tuesday',
                        'Wednesday',
                        'Thursday',
                        'Friday',
                        'Saturday',
                        'Sunday',
                      ];
                      final weekdayName = wk[dt.weekday - 1];
                      final shortDate =
                          '${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}/${dt.year}';
                      final time = MaterialLocalizations.of(context)
                          .formatTimeOfDay(
                            TimeOfDay(hour: dt.hour, minute: dt.minute),
                          );
                      formatted = '$weekdayName, $shortDate - $time';
                    } catch (_) {
                      formatted =
                          e.date + (e.time.isNotEmpty ? ' - ${e.time}' : '');
                    }
                    return Text(
                      formatted,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.normal,
                        color: (_darkMode ? Colors.white70 : Colors.black87),
                      ),
                    );
                  },
                ),
                Divider(
                  color: (_darkMode
                      ? Colors.white70
                      : Colors.black87), // line color
                  thickness: 1.0, // actual line thickness
                  height:
                      20.0, // vertical space the divider occupies (including padding)
                ),
                Text.rich(
                  TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      // fontWeight: FontWeight.bold,
                      color: (_darkMode ? Colors.white : Colors.black),
                    ),
                    children: [
                      TextSpan(
                        text: 'Location: ',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: (_darkMode ? Colors.white : Colors.black),
                        ),
                      ),
                      TextSpan(text: friendlyLocation(e.location)),
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: 'Size: ',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: (_darkMode ? Colors.white : Colors.black),
                        ),
                      ),
                      TextSpan(
                        text: friendlySize(e.size),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: (_darkMode ? Colors.white : Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CreateEventScreen(event: _filtered[idx]),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
