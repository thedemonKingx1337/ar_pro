import 'package:flutter/material.dart';
import '../model/reportModel.dart';
import '../screens/reportedIncidentsDetails_Screen.dart';

class ReportedIncidentList extends StatelessWidget {
  final List<Report> userReports;

  const ReportedIncidentList({super.key, required this.userReports});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: userReports.length,
      itemBuilder: (context, index) {
        final report = userReports[index];
        final severityText =
            report.severity.toString().split('.').last.toUpperCase();

        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            leading: CircleAvatar(
              backgroundColor: severityColor[report.severity],
              child: Icon(
                severityIcon[report.severity],
                color: Colors.black,
              ),
            ),
            title: Text(
              report.title,
              style: TextStyle(color: severityColor[report.severity]),
            ),
            subtitle: Text(report.formattedDate),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "SEVERITY",
                ),
                Text(
                  severityText,
                  style: TextStyle(
                    color: severityColor[report.severity],
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ReportedIncidents_DetailsScreen(report: report),
              ));
            },
          ),
        );
      },
    );
  }
}
