import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:solo_04/models/event.dart';

/// A small sqflite-backed service to persist `EventModel` instances.
/// This keeps the schema close to the in-memory `EventModel` so we can
/// easily migrate the ValueNotifier-backed repository to persistent storage.

class USUDatabase {
  // Singleton pattern so we don’t open multiple DB connections accidentally. 
  static final USUDatabase _instance = USUDatabase._internal();
  factory USUDatabase() => _instance;
  USUDatabase._internal();

  static const _dbName = 'usu_events.db';
  static const tableEvents = 'events';

  // Column names
  static const colId = 'id';
  // static const colArrivalDate = 'arrival_date';
  // static const colArrivalTime = 'arrival_time';
  static const colArrivalDateTimeIso = 'arrival_date_time_iso';
  static const colLocation = 'location';
  static const colSize = 'size';
  static const colShow = 'show';
  static const colImageAsset = 'image_asset';
  static const colSignedUp = 'signed_up';
  static const colAllowSignUp = 'allow_sign_up';

  Database? _db;

  // Lazily open (or return existing) DB instance and create schema if needed.
  // Version numbers should be incremented when making schema changes.
  // $colArrivalDate TEXT NOT NULL,
  // $colArrivalTime TEXT NOT NULL,
  Future<Database> get database async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), _dbName);
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $tableEvents (
            $colId TEXT PRIMARY KEY,
            $colArrivalDateTimeIso TEXT NOT NULL,
            $colLocation TEXT NOT NULL,
            $colSize TEXT NOT NULL,
            $colShow TEXT NOT NULL,
            $colImageAsset TEXT,
            $colSignedUp INTEGER NOT NULL,
            $colAllowSignUp INTEGER NOT NULL
          )
        ''');
      }
    );
    return _db!;
  }

  // Close the database connection to free resources.
  Future<void> close() async {
    final db = _db;
    if (db != null) {
      await db.close();
      _db = null;
    }
  }

  // Convert Event to Map for storage with the database.
  Map<String, Object?> _toMap(Event e) => {
        colId: e.id,
        // colArrivalDate: e.date,
        // colArrivalTime: e.time,
        colArrivalDateTimeIso: e.arrivalDateTimeIso,
        colLocation: e.location,
        colSize: e.size,
        colShow: e.show,
        colImageAsset: e.imageAsset,
        colSignedUp: e.signedUp ? 1 : 0,
        colAllowSignUp: e.allowSignUp ? 1 : 0,
      };

  // Convert Map from database to Event from retrieval from the database.
  Event _fromMap(Map<String, Object?> m) => Event(
        id: m[colId] as String,
        // date: m[colArrivalDate] as String,
        // time: m[colArrivalTime] as String,
        arrivalDateTimeIso: m[colArrivalDateTimeIso] as String,
        location: m[colLocation] as String,
        size: m[colSize] as String,
        show: m[colShow] as String,
        imageAsset: m[colImageAsset] as String?,
        signedUp: (m[colSignedUp] as int) == 1,
        allowSignUp: (m[colAllowSignUp] as int) == 1,
      );

  /// Insert or replace an event.
  Future<void> upsertEvent(Event e) async {
    final db = await database;
    await db.insert(tableEvents, _toMap(e), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Retrieve all events ordered by arrival date/time ascending from the database.
  Future<List<Event>> fetchAllEvents() async {
    final db = await database;
    final rows = await db.query(tableEvents, orderBy: '$colArrivalDateTimeIso ASC');
    return rows.map(_fromMap).toList();
  }

  // Delete an event by id in the database.
  Future<void> deleteEvent(String id) async {
    final db = await database;
    await db.delete(tableEvents, where: '$colId = ?', whereArgs: [id]);
  }
}