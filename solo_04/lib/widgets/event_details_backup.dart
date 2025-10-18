import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solo_04/models/event.dart';

class EventDetails extends StatelessWidget {
  const EventDetails({
    super.key,
    required bool darkMode,
    required List<Event> filtered,
  }) : _darkMode = darkMode,
       _filtered = filtered;

  final bool _darkMode;
  final List<Event> _filtered;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, idx) {
        final e = _filtered[idx];
        return Card(
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            height: 175,
            child: FutureBuilder<String>(
              // returns 'png'|'jpg'|'svg'
              future: () async {
                try {
                  await rootBundle.load('assets/landing.png');
                  return 'png';
                } catch (_) {}
                try {
                  await rootBundle.load('assets/landing.jpg');
                  return 'jpg';
                } catch (_) {}
                return 'svg';
              }(),
              builder: (context, snapshot) {
                final kind = snapshot.data ?? 'svg';
                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    // if (kind == 'png')
                    //   Positioned.fill(
                    //     child: Image.asset(
                    //       'assets/landing.png',
                    //       fit: BoxFit.cover,
                    //     ),
                    //   )
                    // else if (kind == 'jpg')
                    //   Positioned.fill(
                    //     child: Image.asset(
                    //       'assets/landing.jpg',
                    //       fit: BoxFit.cover,
                    //     ),
                    //   )
                    // else
                    // Positioned.fill(
                    //   child: SvgPicture.asset(
                    //     'assets/landing.svg',
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    Positioned.fill(
                      child: Container(color: Colors.green.withOpacity(0.35)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            e.show,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: (_darkMode
                                      ? Colors.white
                                      : Colors.black),
                                ),
                          ),
                          const SizedBox(height: 6),
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
                                      TimeOfDay(
                                        hour: dt.hour,
                                        minute: dt.minute,
                                      ),
                                    );
                                formatted = '$weekdayName, $shortDate - $time';
                              } catch (_) {
                                formatted =
                                    e.date +
                                    (e.time.isNotEmpty ? ' - ${e.time}' : '');
                              }
                              return Text(
                                formatted,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: (_darkMode
                                          ? Colors.white70
                                          : Colors.black87),
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
                          const SizedBox(height: 12),
                          Text.rich(
                            TextSpan(
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: (_darkMode
                                        ? Colors.white
                                        : Colors.black),
                                  ),
                              children: [
                                TextSpan(
                                  text: 'Location: ',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: (_darkMode
                                            ? Colors.white
                                            : Colors.black),
                                      ),
                                ),
                                TextSpan(text: friendlyLocation(e.location)),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: (_darkMode
                                        ? Colors.white
                                        : Colors.black),
                                  ),
                              children: [
                                TextSpan(
                                  text: 'Size: ',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: (_darkMode
                                            ? Colors.white
                                            : Colors.black),
                                      ),
                                ),
                                TextSpan(
                                  text: friendlySize(e.size),
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: (_darkMode
                                            ? Colors.white
                                            : Colors.black),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
