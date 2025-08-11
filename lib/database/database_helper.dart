import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// Simple SQLite helper used during migration away from ObjectBox.
class DatabaseHelper {
  static Database? _db;

  /// Initialize the database and create required tables if they do not exist.
  static Future<void> initialize() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dbPath = join(docsDir.path, 'next_movie', 'app.db');
    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS movies (
            id INTEGER PRIMARY KEY,
            title TEXT,
            path TEXT,
            cover TEXT
          )
        ''');
      },
    );
  }

  /// Update cover path for a movie.
  static Future<void> updateMovieCover(int id, String coverPath) async {
    final db = _db;
    if (db == null) return;
    await db.update(
      'movies',
      {'cover': coverPath},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
