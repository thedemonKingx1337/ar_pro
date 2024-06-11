import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import '../model/reportModel.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, "reports.db"),
    onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE report_log(id TEXT PRIMARY KEY, title TEXT, description TEXT, datetime TEXT, severity TEXT, images TEXT, latitude REAL, longitude REAL, address TEXT)");
    },
    version: 1,
  );
  return db;
}

class ReportInstanceNotifier extends StateNotifier<List<Report>> {
  ReportInstanceNotifier() : super(const []);

  Future<void> addReport(
    String title,
    String description,
    DateTime time,
    List<File> images,
    ReportLocation location,
    Severity severity,
  ) async {
    final appDir = await syspath.getApplicationDocumentsDirectory();
    List<String> imagePaths = [];

    for (File image in images) {
      final fileName = path.basename(image.path);
      final File storedImage = await image.copy("${appDir.path}/$fileName");
      imagePaths.add(storedImage.path);
    }

    final newReport = Report(
        title: title,
        description: description,
        time: time,
        severity: severity,
        images: imagePaths.map((path) => File(path)).toList(),
        location: location);

    final db = await _getDatabase();

    db.insert("report_log", {
      "id": newReport.id,
      "title": newReport.title,
      "description": newReport.description,
      "datetime": newReport.time.toIso8601String(),
      "severity": newReport.severity.toString(),
      "images": imagePaths.join(';'),
      "latitude": newReport.location.latitude,
      "longitude": newReport.location.longitude,
      "address": newReport.location.address,
    });

    state = [newReport, ...state];
  }

  Future<void> loadReportLogs() async {
    final db = await _getDatabase();
    final logdata = await db.query("report_log");

    List<Report> loadedReports = logdata.map((reportLog) {
      List<String> imagePaths = (reportLog["images"] as String).split(';');
      List<File> images = imagePaths.map((path) => File(path)).toList();

      return Report(
        id: reportLog["id"] as String,
        title: reportLog["title"] as String,
        description: reportLog["description"] as String,
        time: DateTime.parse(reportLog["datetime"] as String),
        severity: Severity.values
            .firstWhere((enums) => enums.toString() == reportLog["severity"]),
        images: images,
        location: ReportLocation(
          latitude: reportLog["latitude"] as double,
          longitude: reportLog["longitude"] as double,
          address: reportLog["address"] as String,
        ),
      );
    }).toList();

    state = loadedReports;
  }
}

final reportInstanceProvider =
    StateNotifierProvider<ReportInstanceNotifier, List<Report>>(
  (ref) => ReportInstanceNotifier(),
);
