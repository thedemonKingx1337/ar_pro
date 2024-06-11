import 'dart:io';
import 'package:flutter/material.dart';

class ReportedIncidentImageFullScreen extends StatelessWidget {
  final File imageFile;

  const ReportedIncidentImageFullScreen({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Full Size Image"),
      ),
      body: Center(
        child: Image.file(
          imageFile,
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
