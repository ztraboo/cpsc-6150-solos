import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:solo_04/models/event.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  String? _selectedAsset;
  final _showController = TextEditingController();
  bool _allowSignUp = false;
  String? _editingId;

  @override
  void initState() {
    super.initState();
    final e = widget.event;
    if (e != null) {
      _editingId = e.id;
      _date = DateTime.parse(e.arrivalDateTimeIso);
      // Populate time from the saved combined ISO datetime so the picker shows it when editing.
      try {
        final dt = DateTime.parse(e.arrivalDateTimeIso);
        _time = TimeOfDay(hour: dt.hour, minute: dt.minute);
      } catch (_) {
        _time = null;
      }
      _location = EventLocation.values.byName(e.location);
      _eventSize = EventSize.values.byName(e.size);
      _showController.text = e.show;
      _allowSignUp = e.allowSignUp;
      _selectedAsset = e.imageAsset;
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

    // Persist to in-memory EventsModel so the Sign Up tab can list events.
    // Use existing ID if editing, otherwise generate a new one.
    // New UUIDs can be generated using the 'uuid' package.
    // Creates a globally unique identifier for the event avoiding collisions across devices/sessions.
    final id = _editingId ?? Uuid().v4();

    // Combine date and time into a single ISO datetime string.
    final combined = DateTime(
      _date!.year,
      _date!.month,
      _date!.day,
      _time?.hour ?? 0,
      _time?.minute ?? 0,
    );

    final newEvent = Event(
      id: id,
      arrivalDateTimeIso: combined.toIso8601String(),
      location: _location!.name,
      size: _eventSize!.name,
      imageAsset: _selectedAsset,
      show: _showController.text.trim(),
      signedUp: false,
      allowSignUp: _allowSignUp,
    );

    if (_editingId != null) {
      EventModel.instance.update(newEvent);
    } else {
      EventModel.instance.add(newEvent);
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

          // Background picker (modal)
          const SizedBox(height: 8),
          Text('Background (optional)', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildAssetPreview(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FilledButton(
                      onPressed: _openAssetPicker,
                      child: const Text('Choose Background'),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _selectedAsset = null),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              ),
            ],
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

  // ...existing code...

  Widget _buildAssetPreview() {
    final path = _selectedAsset;
    return SizedBox(
      width: 92,
      height: 88,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: path == null
              ? Center(child: Icon(Icons.image_outlined, color: Theme.of(context).colorScheme.onSurfaceVariant))
              : path.endsWith('.svg')
                  ? SvgPicture.asset(path, fit: BoxFit.cover)
                  : Image.asset(path, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Future<void> _openAssetPicker() async {
    // Try to read AssetManifest.json so we can list any images under assets/gallery/
    List<String> assets = [];
    try {
      final manifestContent = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent) as Map<String, dynamic>;
      final gallery = manifestMap.keys.where((k) => k.startsWith('assets/gallery/')).toList()..sort();
      if (gallery.isNotEmpty) {
        assets = gallery;
      }
    } catch (_) {
      // ignore and fallback below
    }

    // Fallback curated list if no gallery assets found
    if (assets.isEmpty) {
      assets = [
        'assets/landing.png',
        'assets/landing.jpg',
        'assets/landing.svg',
        'assets/usu_logo.svg',
        'assets/usu_logo_dark.svg',
      ];
    }

    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets + const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(4))),
              const SizedBox(height: 12),
              Text('Choose Background', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              SizedBox(
                height: 360,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 1.2),
                  itemCount: assets.length,
                  itemBuilder: (c, i) {
                    final p = assets[i];
                    final selected = p == _selectedAsset;
                    return GestureDetector(
                      onTap: () => Navigator.of(context).pop(p),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 140),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: selected ? Theme.of(context).colorScheme.primary : Colors.transparent, width: 2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: p.endsWith('.svg') ? SvgPicture.asset(p, fit: BoxFit.cover) : Image.asset(p, fit: BoxFit.cover),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (picked != null) setState(() => _selectedAsset = picked);
  }
}
