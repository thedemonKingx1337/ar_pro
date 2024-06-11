import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/report_instanceProvider.dart';
import '../widgets/reportedIncidentList.dart';

class ReportedIncidentsDisplayScreen extends ConsumerStatefulWidget {
  static const routeName = "/reportedIncidentsBook";

  const ReportedIncidentsDisplayScreen({super.key});
  @override
  ConsumerState<ReportedIncidentsDisplayScreen> createState() {
    return _ReportedIncidentsDisplayScreenState();
  }
}

class _ReportedIncidentsDisplayScreenState
    extends ConsumerState<ReportedIncidentsDisplayScreen> {
  late Future<void> _reportLogFuture;
  @override
  void initState() {
    super.initState();
    _reportLogFuture =
        ref.read(reportInstanceProvider.notifier).loadReportLogs();
  }

  @override
  Widget build(BuildContext context) {
    final userReports = ref.watch(reportInstanceProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Incident Reports'),
      ),
      body: FutureBuilder(
        future: _reportLogFuture,
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : userReports.isEmpty
                    ? Center(
                        child: Text(
                        'No Reports yet',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ))
                    : ReportedIncidentList(userReports: userReports),
      ),
    );
  }
}
