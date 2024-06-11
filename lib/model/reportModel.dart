import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

const uuid = Uuid();
final formatter = DateFormat('h:mm a MM/dd/yyyy');

enum Severity { high, medium, normal, low }

const severityColor = {
  Severity.high: Colors.red,
  Severity.medium: Colors.orange,
  Severity.normal: Colors.blue,
  Severity.low: Colors.green,
};

final Map<Severity, IconData> severityIcon = {
  Severity.high: Icons.sentiment_very_dissatisfied,
  Severity.medium: Icons.sentiment_dissatisfied,
  Severity.normal: Icons.sentiment_satisfied,
  Severity.low: Icons.sentiment_very_satisfied,
};

class Report {
  final String id;
  final String title;
  final String description;
  final DateTime time;
  final Severity severity;
  final List<File> images;
  final ReportLocation location;

  Report({
    required this.title,
    required this.description,
    required this.time,
    required this.severity,
    required this.images,
    required this.location,
    String? id,
  }) : id = id ?? uuid.v4();

  String get formattedDate {
    return formatter.format(time);
  }
}

class ReportLocation {
  final double latitude;
  final double longitude;
  final String address;

  const ReportLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}
