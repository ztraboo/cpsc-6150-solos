import 'package:flutter/material.dart';
import 'package:solo_04/models/event.dart';
import 'package:solo_04/models/event_model.dart';

class EventForm extends StatefulWidget {
  const EventForm({super.key, this.event});

  final Event? event;

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _date;
  TimeOfDay? _time;
  EventLocation? _location;
  EventSize? _eventSize;
  final _showController = TextEditingController();
  bool _allowSignUp = false;
  String? _editingId;

  @override
  void initState() {
    super.initState();
    final e = widget.event;
    if (e != null) {
      _editingId = e.id;
      _date = DateTime.parse(e.date);
      // Populate time from the saved combined ISO datetime so the picker shows it when editing.
      try {
        final dt = DateTime.parse(e.dateTimeIso);
        _time = TimeOfDay(hour: dt.hour, minute: dt.minute);
      } catch (_) {
        _time = null;
      }
      _location = EventLocation.values.byName(e.location);
      _eventSize = EventSize.values.byName(e.size);
      _showController.text = e.show;
      _allowSignUp = e.allowSignUp;
      // time parsing from the saved string is omitted (best-effort parsing
      // is fragile across locales); leave _time null so user can re-select.
    }
  }

  Future<void> _pickTime() async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? now,
    );
    if (picked != null) setState(() => _time = picked);
  }

  @override
  void dispose() {
    _showController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
      helpText: 'Select Event Date',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          datePickerTheme: const DatePickerThemeData(
            // surfaceContainerHighest: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  void _submit() {
    final ok = _formKey.currentState?.validate() ?? false;
    debugPrint('Form validation: $ok');
    if (!ok || _date == null || _location == null || _eventSize == null) {
      // Trigger any missing validations
      setState(() {}); // re-render to show helper texts
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields.')),
      );
      return;
    }

    final data = {
      'date': _date!.toIso8601String(),
      'location': _location!.name,
      'size': _eventSize!.name,
      'show': _showController.text.trim(),
    };

    // Handle your save logic here (API call, local DB, etc.)
    debugPrint('Event form submitted: $data');

    // Persist to in-memory repository so the Sign Up tab can list events.
    final id = _editingId ?? DateTime.now().millisecondsSinceEpoch.toString();
    final timeStr = _time == null
        ? ''
        : MaterialLocalizations.of(context).formatTimeOfDay(_time!);
    final combined = DateTime(
      _date!.year,
      _date!.month,
      _date!.day,
      _time?.hour ?? 0,
      _time?.minute ?? 0,
    );

    final newEvent = Event(
      id: id,
      date: _date!.toIso8601String(),
      time: timeStr,
      dateTimeIso: combined.toIso8601String(),
      location: _location!.name,
      size: _eventSize!.name,
      // kind: EventType.general,
      show: _showController.text.trim(),
      signedUp: false,
      allowSignUp: _allowSignUp,
    );

    if (_editingId != null) {
      EventRepository.instance.update(newEvent);
    } else {
      EventRepository.instance.add(newEvent);
    }
    // ScaffoldMessenger.of(
    //   context,
    // ).showSnackBar(const SnackBar(content: Text('Event saved!')));

    // Close the create/edit screen and return to the Events page.
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _date == null
        ? 'Pick a date'
        : MaterialLocalizations.of(context).formatMediumDate(_date!);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          // Date
          Text(
            'Enter in information below about the upcoming event.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: _pickDate,
            borderRadius: BorderRadius.circular(12),
            child: InputDecorator(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.event),
                labelText: 'Date',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                errorText: _date == null ? 'Required' : null,
              ),
              child: Text(dateText),
            ),
          ),
          const SizedBox(height: 12),

          // Time
          InkWell(
            onTap: _pickTime,
            borderRadius: BorderRadius.circular(12),
            child: InputDecorator(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.access_time),
                labelText: 'Arrival Time',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                errorText: _time == null ? 'Required' : null,
              ),
              child: Text(
                _time == null
                    ? 'Pick a time'
                    : MaterialLocalizations.of(context).formatTimeOfDay(_time!),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Location
          DropdownButtonFormField<EventLocation>(
            initialValue: _location,
            isExpanded: true,
            items: EventLocation.values
                .map(
                  (loc) => DropdownMenuItem(
                    value: loc,
                    child: Text(
                      loc.label,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                )
                .toList(),
            decoration: InputDecoration(
              labelText: 'Location',
              prefixIcon: const Icon(Icons.place_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (v) => v == null ? 'Please choose a location' : null,
            onChanged: (v) => setState(() => _location = v),
          ),
          const SizedBox(height: 20),

          // Event Size
          DropdownButtonFormField<EventSize>(
            initialValue: _eventSize,
            isExpanded: true,
            items: EventSize.values
                .map(
                  (t) => DropdownMenuItem(
                    value: t,
                    child: Text(
                      t.label,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                )
                .toList(),
            decoration: InputDecoration(
              labelText: 'Event Size',
              prefixIcon: const Icon(Icons.category_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (v) => v == null ? 'Please choose an event size' : null,
            onChanged: (v) => setState(() => _eventSize = v),
          ),
          const SizedBox(height: 20),

          // Show (event name)
          TextFormField(
            controller: _showController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Show',
              hintText: 'e.g., Opening Night, Summer Concert',
              prefixIcon: const Icon(Icons.theaters_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Please enter the show name'
                : null,
          ),
          const SizedBox(height: 12),

          // Sign Up
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _allowSignUp,
            onChanged: (v) => setState(() => _allowSignUp = v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('Allow Sign Up'),
          ),

          const SizedBox(height: 12),

          // Submit
          FilledButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.check),
            label: const Text('Save Event'),
          ),
        ],
      ),
    );
  }
}
