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

// enum EventType {
//   comedy,
//   concert,
//   dance,
//   festival,
//   general,
//   graduation,
//   lecture,
//   play,
//   sport
// }

// enum ConcertType { rock, jazz, pop }
// enum SportType { baseball, basketball, football, hockey }

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
    required this.date,
    required this.time,
    required this.dateTimeIso,
    required this.location,
    required this.size,
    // required this.kind,
    required this.show,
    this.imageAsset,
    required this.signedUp,
    required this.allowSignUp,
  });

  final String id;
  final String date; // ISO date
  final String time; // human-friendly time
  final String dateTimeIso; // combined ISO datetime
  final String location;
  final String size;
  // final EventType kind;
  final String show;
  final String? imageAsset;
  final bool signedUp;
  final bool allowSignUp;

  Event copyWith({
    String? id,
    String? date,
    String? time,
    String? dateTimeIso,
    String? location,
    String? size,
    String? imageAsset,
    String? show,
    bool? signedUp,
    bool? allowSignUp,
  }) {
    return Event(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      dateTimeIso: dateTimeIso ?? this.dateTimeIso,
      location: location ?? this.location,
      size: size ?? this.size,
      imageAsset: imageAsset ?? this.imageAsset,
      // kind: kind ?? this.kind,
      show: show ?? this.show,
      signedUp: signedUp ?? this.signedUp,
      allowSignUp: allowSignUp ?? this.allowSignUp,
    );
  }
}
