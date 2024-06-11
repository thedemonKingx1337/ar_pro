import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import '../model/logModel.dart';
import '../providers/arLog_Provider.dart';
import '../widgets/logScreenItem_List.dart';

class LogScreen extends ConsumerStatefulWidget {
  const LogScreen({super.key});
  static const routeName = "/logScreen";
  @override
  ConsumerState<LogScreen> createState() {
    return _LogScreenState();
  }
}

class _LogScreenState extends ConsumerState<LogScreen> {
  late Future<void> _arLogDBtrigger;
  @override
  void initState() {
    super.initState();
    _arLogDBtrigger = ref.read(areLogProvider.notifier).loadARLogs();
  }

  @override
  Widget build(BuildContext context) {
    final arLogDataList = ref.watch(areLogProvider);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Log Screen'),
        ),
        body: FutureBuilder(
          future: _arLogDBtrigger,
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : arLogDataList.isEmpty
                  ? Center(
                      child: Text(
                      'No Logs yet',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                    ))
                  : ListView.builder(
                      itemCount: arLogDataList.length,
                      itemBuilder: (context, index) {
                        final logData = arLogDataList[index];
                        return LogScreenItem(logData: logData);
                      },
                    ),
        ));
  }
}
