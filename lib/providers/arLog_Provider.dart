import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:intl/intl.dart';

import '../model/logModel.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, "AR_DB.db"),
    onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE ar_log(id TEXT PRIMARY KEY, username TEXT, posX REAL, posY REAL, posZ REAL, date TEXT, latitude REAL, longitude REAL, address TEXT)");
    },
    version: 1,
  );
  return db;
}

class ARLogNotifier extends StateNotifier<List<LogData>> {
  ARLogNotifier() : super([]);

  Future<void> addARlog(
    String username,
    vector.Vector3 position,
    DateTime date,
    PlaceLocation currentLocation,
  ) async {
    const uuid = Uuid();
    final newLog = LogData(
      id: uuid.v4(),
      username: username,
      position: position,
      date: date,
      currentLocation: currentLocation,
    );

    final db = await _getDatabase();

    db.insert("ar_log", newLog.logMap,
        conflictAlgorithm: ConflictAlgorithm.replace);

    state = [newLog, ...state];
  }

  Future<void> loadARLogs() async {
    final db = await _getDatabase();
    final arLogdata = await db.query("ar_log");

    List<LogData> loadedARLogs = arLogdata.map((arLog) {
      return LogData(
        id: arLog["id"] as String,
        username: arLog["username"] as String,
        date: DateTime.parse(arLog["date"] as String),
        position: vector.Vector3(
          arLog["posX"] as double,
          arLog["posY"] as double,
          arLog["posZ"] as double,
        ),
        currentLocation: PlaceLocation(
          latitude: arLog["latitude"] as double,
          longitude: arLog["longitude"] as double,
          address: arLog["address"] as String,
        ),
      );
    }).toList();
    state = loadedARLogs;
  }
}

final areLogProvider = StateNotifierProvider<ARLogNotifier, List<LogData>>(
    (ref) => ARLogNotifier());
