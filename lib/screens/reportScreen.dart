import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/reportModel.dart';
import '../widgets/reportImageBox.dart';
import '../widgets/reportLocationBox.dart';
import '../providers/report_instanceProvider.dart';
import '../widgets/reportSeverityDropdown.dart';

class ReportScreen extends ConsumerStatefulWidget {
  static const routeName = "/reportScreen";
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  final _reportTitleController = TextEditingController();
  final _reportDescriptionController = TextEditingController();
  List<File>? _pickedImage;
  ReportLocation? _pickedLocation;
  Severity? selectedSeverity;

  void _saveReport() {
    final enteredTitle = _reportTitleController.text;
    final enteredDescription = _reportDescriptionController.text;

    if (enteredDescription.isEmpty ||
        enteredTitle.isEmpty ||
        _pickedImage == null ||
        _pickedLocation == null ||
        selectedSeverity == null) {
      return;
    }

    ref.read(reportInstanceProvider.notifier).addReport(
        enteredTitle,
        enteredDescription,
        DateTime.now(),
        _pickedImage!,
        _pickedLocation!,
        selectedSeverity!);

    Navigator.of(context).pop();
  }

  void _selectImages(List<File> pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectPlace(ReportLocation pickedLocation) {
    _pickedLocation = pickedLocation;
  }

  void _onSeveritySelected(Severity? severity) {
    setState(() {
      selectedSeverity = severity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report Incident")),
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReportSeverityDropdown(
                        onSelectSeverity: _onSeveritySelected),
                    TextField(
                        decoration: const InputDecoration(labelText: "Title"),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                        controller: _reportTitleController),
                    const SizedBox(height: 15),
                    ImageInput(onSelectImage: _selectImages),
                    const SizedBox(height: 15),
                    LocationInput(onSelectReportLocation: _selectPlace),
                    const SizedBox(height: 15),
                    TextField(
                      decoration:
                          const InputDecoration(labelText: "Discription"),
                      controller: _reportDescriptionController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            onPressed: _saveReport,
            icon: const Icon(Icons.add),
            label: const Text("Create Incident Log"),
            style: const ButtonStyle(),
          ),
        ),
      ]),
    );
  }
}
