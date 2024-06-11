import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import '../helper/location_helper.dart';
import '../model/reportModel.dart';
import '../screens/ReportMap_fullscreen.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({required this.onSelectReportLocation, super.key});

  final void Function(ReportLocation pickedLocation) onSelectReportLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  ReportLocation? _pickedLocation;
  bool _isGettingLocation = false;

  static const googleapi = "AIzaSyAuRZaj9Sx4R509r28fItGHwCUXGM3bmrQ";

  String get locationImageURL {
    if (_pickedLocation == null) {
      return "";
    }
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:purple%7Clabel:A%7C$lat,$lng&key=$GOOGLE_API';
  }

  Future<void> _savePlace(double lat, double lng) async {
    final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleapi");
    final response = await http.get(url);
    final responseData = json.decode(response.body);
    final address = responseData["results"][0]["formatted_address"];
    setState(() {
      _pickedLocation = ReportLocation(
        latitude: lat,
        longitude: lng,
        address: address,
      );
      _isGettingLocation = false;
    });
    widget.onSelectReportLocation(_pickedLocation!);
  }

  Future<void> _getCurrentLocatin() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isGettingLocation = true;
    });
    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;
    if (lat == null || lng == null) {
      return;
    }
    _savePlace(lat, lng);
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const ReportMapFullScreen(),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    print(selectedLocation.toString());
    _savePlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      "No Location",
      textAlign: TextAlign.center,
      style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
    );

    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImageURL,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 1, color: Colors.grey),
          ),
          height: 200,
          width: double.infinity,
          alignment: Alignment.center,
          child: previewContent,
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _getCurrentLocatin,
                icon: const Icon(Icons.gps_fixed),
                label: const Text("Current Location"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  side: BorderSide(color: Theme.of(context).colorScheme.onPrimary, width: 5),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
                child: OutlinedButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.pin_drop),
              label: const Text("Select Location"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(15),
                side: BorderSide(color: Theme.of(context).colorScheme.onPrimary, width: 5),
              ),
            ))
          ],
        )
      ],
    );
  }
}
