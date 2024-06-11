import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/reportModel.dart';

class MapScreen extends StatefulWidget {
  final ReportLocation initialLocation;
  final bool isSelecting;

  const MapScreen(
      {super.key,
      this.initialLocation = const ReportLocation(
          latitude: 37.422, longitude: -122.084, address: ""),
      this.isSelecting = false});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  // Set<Marker> _createMarkers() {
  //   if (_pickedLocation != null && widget.isSelecting == false) {
  //     return {
  //       Marker(
  //         markerId: MarkerId("m1"),
  //         position: _pickedLocation ??
  //             LatLng(widget.initialLocation.latitude,
  //                 widget.initialLocation.longitude),
  //       )
  //     };
  //   }
  //   return {};
  // }

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
        title: Text("Map"),
        actions: [
          if (widget.isSelecting)
            IconButton(
                onPressed: () {
                  _pickedLocation == null
                      ? null
                      : Navigator.of(context).pop(_pickedLocation);
                },
                icon: Icon(Icons.check, color: Colors.black))
        ],
      ),
      // body: GoogleMap(
      //   initialCameraPosition: CameraPosition(
      //     // target: LatLng(widget.initialLocation.latitude,
      //     //     widget.initialLocation.longitude),
      //     zoom: 16,
      //   ),
      //   onTap: widget.isSelecting ? _selectLocation : null,
      //   // markers : _pickedLocation == null ? <Marker>{} : {Marker(markerId: MarkerId("m1"), position: _pickedLocation! )},
      //   // markers: _createMarkers(),
      // ),
    );
  }
}
