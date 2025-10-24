// Simple in-memory event model and repository. Uses a ValueNotifier so UI can
// listen for updates without adding external dependencies.

enum EventLocation { bswa, sma, drive, spartanburgers }

extension EventLocationX on EventLocation {
  String get label => switch (this) {
    EventLocation.bswa => 'Bon Secour Wellness Arena',
    EventLocation.sma => 'Spartanburg Memorial Auditorium',
    EventLocation.drive => 'Drive',
    EventLocation.spartanburgers => 'Spartanburgers',
  };
}

enum EventSize { large, small }

extension EventSizeX on EventSize {
  String get label => switch (this) {
    EventSize.large => 'Large',
    EventSize.small => 'Small',
  };
}

// Helpers to convert stored enum names back to friendly labels.
String friendlyLocation(String name) {
  try {
    return EventLocation.values.byName(name).label;
  } catch (_) {
    return name;
  }
}

String friendlySize(String name) {
  try {
    return EventSize.values.byName(name).label;
  } catch (_) {
    return name;
  }
}

class Event {
  Event({
    required this.id,
    required this.arrivalDateTimeIso,
    required this.location,
    required this.size,
    required this.show,
    this.imageAsset,
    required this.signedUp,
    required this.allowSignUp,
  });

  final String id;
  final String arrivalDateTimeIso; // combined ISO datetime
  final String location;
  final String size;
  final String show;
  final String? imageAsset;
  final bool signedUp;
  final bool allowSignUp;

  Event copyWith({
    String? id,
    String? arrivalDateTimeIso,
    String? location,
    String? size,
    String? imageAsset,
    String? show,
    bool? signedUp,
    bool? allowSignUp,
  }) {
    return Event(
      id: id ?? this.id,
      arrivalDateTimeIso: arrivalDateTimeIso ?? this.arrivalDateTimeIso,
      location: location ?? this.location,
      size: size ?? this.size,
      imageAsset: imageAsset ?? this.imageAsset,
      show: show ?? this.show,
      signedUp: signedUp ?? this.signedUp,
      allowSignUp: allowSignUp ?? this.allowSignUp,
    );
  }

  // Helpers to extract date components from arrivalDateTimeIso.
  // ------------------------------------------------------------

  // Get the weekday name (e.g., "Monday").
  String get weekDayName {
    try {
      final dt = DateTime.parse(arrivalDateTimeIso);
      const wk = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ];
      return wk[dt.weekday - 1];
    } catch (_) {
      return arrivalDateTimeIso;
    }
  }

  // Get the arrival date in MM/DD/YYYY format.
  String get arrivalDateShort {
    try {
      final dt = DateTime.parse(arrivalDateTimeIso);
      return '${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return arrivalDateTimeIso;
    }
  }

  // Get the arrival time in HH:MM AM/PM format.
  String get arrivalTimeShort {
    try {
      final dt = DateTime.parse(arrivalDateTimeIso);
      final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return '$hour:${dt.minute.toString().padLeft(2, '0')} $ampm';
    } catch (_) {
      return arrivalDateTimeIso;
    }
  }
}
