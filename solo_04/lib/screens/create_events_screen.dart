import 'package:flutter/material.dart';
import 'package:solo_04/models/event.dart';
import 'package:solo_04/widgets/event_form.dart';

class CreateEventScreen extends StatelessWidget {
  const CreateEventScreen({super.key, this.event});

  final Event? event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event == null ? 'Create Event' : 'Edit Event'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: EventForm(event: event),
          ),
        ),
      ),
    );
  }
}
