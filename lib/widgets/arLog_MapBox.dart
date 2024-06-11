import 'package:flutter/material.dart';
import '../helper/location_helper.dart';
import '../model/logModel.dart';
import '../screens/arLogMap_fullscreen.dart';

class LocationBox extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String address;

  const LocationBox({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  @override
  State<LocationBox> createState() => _LocationBoxState();
}

class _LocationBoxState extends State<LocationBox> {
  String? _previewImageUrl;
  bool isGettingLocation = false;

  @override
  void initState() {
    super.initState();
    _showPreview(widget.latitude, widget.longitude);
  }

  void _showPreview(double lat, double lng) {
    setState(() {
      isGettingLocation = true;
    });
    final mapPreviewURL = LocationHelper.generateLocationPreviewImageURL(
        latitude: lat, longitude: lng);
    setState(() {
      _previewImageUrl = mapPreviewURL;
      isGettingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(border: Border.all(width: 1)),
            height: 200,
            width: double.infinity,
            alignment: Alignment.center,
            child: _previewImageUrl == null
                ? const Text(
                    "No Location",
                    textAlign: TextAlign.center,
                  )
                : isGettingLocation
                    ? const Center(child: CircularProgressIndicator())
                    : InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ARLogMapFullScreen(
                                initialLocation: PlaceLocation(
                                  latitude: widget.latitude,
                                  longitude: widget.longitude,
                                  address: widget.address,
                                ),
                                isSelecting: false,
                              ),
                            ),
                          );
                        },
                        child: Image.network(
                          height: 200,
                          _previewImageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
          ),
          const SizedBox(height: 10),
          Text(
            "Address : ${widget.address}",
            style: TextStyle(
                fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
