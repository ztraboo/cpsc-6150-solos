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
    this.trailing,
    this.onDelete,
  }) : _darkMode = darkMode,
       _filtered = filtered;

  final bool _darkMode;
  final List<Event> _filtered;
  // Optional per-event trailing widget builder. If provided, called with the Event.
  final Widget Function(Event)? trailing;
  // Optional delete callback. If provided, each item will be dismissible and call this with the event id.
  final void Function(String id)? onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, idx) {
        final e = _filtered[idx];

        final item = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                  color: _darkMode ? Colors.amberAccent : Colors.grey,
                  width: 1.0,
                ),
              ),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                children: [
                  // Background image if available
                  if (e.imageAsset != null)
                    Positioned.fill(
                      child: e.imageAsset!.endsWith('.svg')
                          ? SvgPicture.asset(e.imageAsset!, fit: BoxFit.cover)
                          : Image.asset(e.imageAsset!, fit: BoxFit.cover),
                    ),

                  // Semi-opaque overlay for text readability
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.95),
                            Colors.black.withOpacity(0.55),
                          ],
                        ),
                      ),
                    ),
                  ),

                  ListTile(
                    tileColor: _darkMode ? Colors.transparent : Colors.transparent,
                    title: Text(
                      e.show,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                              formatted = '${e.weekDayName}, ${e.arrivalDateShort} - ${e.arrivalTimeShort}';
                            } catch (_) {
                              formatted = e.arrivalDateTimeIso;
                            }
                            return Text(
                              formatted,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.amberAccent,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 30),
                        Text.rich(
                          TextSpan(
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                            children: [
                              TextSpan(
                                text: 'Location: ',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: friendlyLocation(e.location),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                            children: [
                              TextSpan(
                                text: 'Size: ',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: friendlySize(e.size),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    trailing: trailing != null
                        ? trailing!(e)
                        : IconButton(
                            icon: Icon(Icons.edit, color: Colors.white),
                            onPressed: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CreateEventScreen(event: _filtered[idx]),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),

            // Show a small indicator under the card when sign up is disabled
            if (!e.allowSignUp)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Row(
                  children: [
                    Icon(Icons.lock_outline, size: 16, color: _darkMode ? Colors.white70 : Colors.black54),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Sign up closed for this event',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: _darkMode ? Colors.white70 : Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );

        if (onDelete == null) return item;

        return Dismissible(
          key: ValueKey(e.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.redAccent,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Delete event?'),
                content: const Text('Are you sure you want to delete this event? This cannot be undone.'),
                actions: [
                  TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                  TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete')),
                ],
              ),
            );
          },
          onDismissed: (_) => onDelete!(e.id),
          child: item,
        );
      },
    );
  }
}
