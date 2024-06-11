import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/reportModel.dart';

class ReportMapFullScreen extends StatefulWidget {
  final ReportLocation initialLocation;
  final bool isSelecting;

  const ReportMapFullScreen({
    super.key,
    this.initialLocation = const ReportLocation(
      latitude: 37.422,
      longitude: -122.084,
      address: "",
    ),
    this.isSelecting = true,
  });

  @override
  State<ReportMapFullScreen> createState() => _ReportMapFullScreenState();
}

class _ReportMapFullScreenState extends State<ReportMapFullScreen> {
  LatLng? _pickedLocation;

  void _selectLocation(LatLng position) {
    print('Selected Location: $position');
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? "Select Location" : "Reported location"),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: Icon(Icons.check,
                  color: Theme.of(context).colorScheme.onBackground),
              onPressed: () {
                // _pickedLocation == null
                //     ? null
                //     :
                Navigator.of(context).pop(_pickedLocation);
              },
            )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.initialLocation.latitude,
              widget.initialLocation.longitude),
          zoom: 16,
        ),
        onTap: widget.isSelecting == false ? null : _selectLocation,
        markers: (_pickedLocation == null && widget.isSelecting == true)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId("m1"),
                  position: _pickedLocation ??
                      LatLng(widget.initialLocation.latitude,
                          widget.initialLocation.longitude),
                )
              },
      ),
    );
  }
}
