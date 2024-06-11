import 'package:flutter/material.dart';

import 'package:ar_dreams/model/reportModel.dart';

class ReportSeverityDropdown extends StatefulWidget {
  final void Function(Severity selectedSeverity) onSelectSeverity;
  const ReportSeverityDropdown({super.key, required this.onSelectSeverity});

  @override
  State<ReportSeverityDropdown> createState() => _ReportSeverityDropdownState();
}

class _ReportSeverityDropdownState extends State<ReportSeverityDropdown> {
  Severity? selectedSeverity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
      child: DropdownButton(
        borderRadius: BorderRadius.circular(10),
        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
        underline: const SizedBox(),
        hint: Text(
          "Select Severity ",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        value: selectedSeverity,
        items: Severity.values
            .map((severity) => DropdownMenuItem(
                value: severity,
                child: Row(
                  children: [
                    Icon(
                      severityIcon[severity],
                      color: severityColor[severity],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      severity.name.toUpperCase().toString(),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ],
                )))
            .toList(),
        onChanged: (value) {
          if (value == null) {
            return;
          }
          setState(() {
            selectedSeverity = value;
          });
          widget.onSelectSeverity(selectedSeverity!);
        },
      ),
    );
  }
}
