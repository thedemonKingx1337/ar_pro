import 'package:flutter/material.dart';

import '../model/logModel.dart';
import 'arLog_MapBox.dart';

class LogScreenItem extends StatelessWidget {
  final LogData logData;

  const LogScreenItem({super.key, required this.logData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Log ID: ${logData.id}',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface)),
            const SizedBox(height: 8),
            Text('Username: ${logData.username}',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface)),
            const SizedBox(height: 8),
            Text('Formatted Date: ${logData.formattedDate}',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface)),
            const SizedBox(height: 8),
            FittedBox(
              child: Row(
                children: [
                  Chip(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    backgroundColor: Colors.blue,
                    label:
                        Text('Latitude: ${logData.currentLocation.latitude}'),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    backgroundColor: Colors.blue,
                    label:
                        Text('Longitude: ${logData.currentLocation.longitude}'),
                  ),
                ],
              ),
            ),
            LocationBox(
              latitude: logData.currentLocation.latitude,
              longitude: logData.currentLocation.longitude,
              address: logData.currentLocation.address,
            )
          ],
        ),
      ),
    );
  }
}
