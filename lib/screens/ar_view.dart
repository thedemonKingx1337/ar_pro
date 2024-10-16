import 'dart:async';
import 'dart:convert';

import 'package:ar_dreams/widgets/loading%20indicator.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import '../model/logModel.dart';
import '../providers/arLog_Provider.dart';

class ARView extends ConsumerStatefulWidget {
  const ARView({super.key});

  static const routeName = "/ar_Screen";

  @override
  ARViewState createState() => ARViewState();
}

class ARViewState extends ConsumerState<ARView> {
  late ArCoreController arCoreController;
  late ArCoreNode node;
  Timer? timer;
  bool showResetButton = false;
  bool showCard = false;
  bool showCaptureBanner = false;
  DateTime capturedAtDateTime = DateTime.now();
  final uuid = const Uuid();
  double? lat = 0.0;
  double? lng = 0.0;

  @override
  void dispose() {
    arCoreController.dispose();
    timer?.cancel();
    super.dispose();
  }

  Future<PlaceLocation?> getCurrentLocation() async {
    const googleapi = "Axxxxx_ReplaceWithYourAPI_xxxxxxxxxx";
    try {
      final locationData = await Location().getLocation();
      setState(() {
        lat = locationData.latitude;
        lng = locationData.longitude;
      });

      final url = Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleapi");
      final response = await http.get(url);
      final responseData = json.decode(response.body);
      final address = responseData["results"][0]["formatted_address"];

      return PlaceLocation(
        latitude: lat!,
        longitude: lng!,
        address: address,
      );
    } on Exception {
      print('Failed to get location');
      return null;
    }
  }

  _onArCoreViewCreated(ArCoreController arcoreController) {
    this.arCoreController = arcoreController;
    _displayEarthMapSphere(arCoreController);

    arCoreController.onNodeTap = (nodeName) => _handleOnNodeTap(nodeName);
  }

  _displayEarthMapSphere(ArCoreController controller) async {
    final ByteData textureByte = await rootBundle.load("assets/earth_map.jpg");

    final material = ArCoreMaterial(
      textureBytes: textureByte.buffer.asUint8List(),
      color: Colors.blue,
      metallic: 1,
    );

    final sphere = ArCoreSphere(
      materials: [material], radius: .15,
      // size: vector.Vector3(0.5, 0.5, 0.5),
    );

    node = ArCoreRotatingNode(
      shape: sphere,
      position: vector.Vector3(0, 0, -2.3),
      degreesPerSecond: 90,
    );

    controller.addArCoreNode(node);
  }

  _handleOnNodeTap(String nodeName) async {
    setState(() {
      showCard = true;
    });

    startTimer();

    // final ByteData textureByte = await rootBundle.load("earth_map_red.png");

    // final random = Random();

    // final material = ArCoreMaterial(
    //   // textureBytes: textureByte.buffer.asUint8List(),
    //   // color: Color.fromRGBO(
    //   //   random.nextInt(256), // Red
    //   //   random.nextInt(256), // Green
    //   //   random.nextInt(256), // Blue
    //   //   1, // Alpha
    //   // ),
    //   color: Colors.green,
    //   metallic: 1,
    // );

    if (nodeName == node.name) {
      arCoreController.removeNode(nodeName: node.name);

      setState(() {
        capturedAtDateTime = DateTime.now();
      });

      // Get the current location
      final currentLocation = await getCurrentLocation();
      if (currentLocation != null) {
        ref.read(areLogProvider.notifier).addARlog(
              'R&C',
              node.position!.value,
              capturedAtDateTime,
              currentLocation,
            );
      }

      final newPosition = vector.Vector3(
          // -0.5 + random.nextDouble(), 0.5 + random.nextDouble(),-3.5 + random.nextDouble(),
          0,
          0,
          -1.5);

      // final sphere = ArCoreSphere(
      //   materials: [material], radius: .3,
      //   // size: vector.Vector3(0.5, 0.5, 0.5),
      // );

      // node = ArCoreNode(
      //   shape: sphere,
      //   position: newPosition,
      // );

      // arCoreController.addArCoreNode(node);
    }
  }

  void startTimer() {
    timer = Timer(const Duration(seconds: 4), () {
      setState(() {
        arCoreController.removeNode(nodeName: node.name);
        showResetButton = true;
        showCard = false;
        showCaptureBanner = true;
      });
      showSnackbar();
    });
  }

  void resetScene() {
    setState(() {
      showResetButton = false;
      _displayEarthMapSphere(arCoreController);
      showCaptureBanner = false;
    });
  }

  String _formatCoordinate(double? coordinate) {
    if (coordinate == null) return '';

    String direction = coordinate >= 0 ? 'N' : 'S';
    int degree = coordinate.abs().floor();
    double minuteDouble = (coordinate.abs() - degree) * 60;
    int minute = minuteDouble.floor();
    double secondDouble = (minuteDouble - minute) * 60;
    int second = secondDouble.floor();
    return '$degree°$minute\'${second.toStringAsFixed(1)}"$direction';
  }

  void showSnackbar() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Capture success')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AR View')),
      body: Stack(children: [
        ArCoreView(
          onArCoreViewCreated: _onArCoreViewCreated,
          enableTapRecognizer: true,
        ),
        // Positioned(
        //   top: 16.0,
        //   left: 16.0,
        //   child: Text(
        //     DateFormat('dd-MM-yyy – kk:mm').format(DateTime.now()),
        //     style: const TextStyle(
        //       fontSize: 24,
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
        Visibility(
          visible: showCard,
          child: Center(
            child: Tilt(
              fps: 120,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey.withOpacity(0.45),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Please wait...',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        height: 70,
                        width: 70,
                        child: infinityCradle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: showCaptureBanner,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Tilt(
                lightConfig: const LightConfig(disable: true),
                shadowConfig: const ShadowConfig(disable: true),
                fps: 120,
                borderRadius: BorderRadius.circular(15),
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // Perspective
                    ..rotateX(0.05), // Rotate along X axis for a tilted effect
                  // alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromRGBO(
                              147, 128, 146, 0.8), // Adjusted opacity
                          Color.fromRGBO(
                              141, 102, 173, 0.8), // Adjusted opacity
                        ],
                      ),
                      // border:
                      //     Border.all(color: Color.fromARGB(255, 214, 217, 240), width: 2), // Border
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Tilt(
                                fps: 120,
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                    height: 40,
                                    width: 40,
                                    child: Lottie.asset(
                                        "assets/succesfulLottie.json")),
                                // child: Image.asset(
                                //   'assets/sucess.png',
                                //   height: 35,
                                //   width: 40,
                                // ),
                              ),
                              const SizedBox(width: 10),
                              Tilt(
                                fps: 120,
                                child: Text(
                                  'Successfully captured at',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white, // Text color
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            /// Headings
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '  Latitude',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '  Longitude',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Tilt(
                                  fps: 120,
                                  borderRadius: BorderRadius.circular(15),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Date",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white, // Text color
                                          ),
                                        ),
                                        Text(
                                          " Time",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white, // Text color
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            ///Values
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ' ${_formatCoordinate(lat)}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  ' ${_formatCoordinate(lng)}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Tilt(
                                  fps: 120,
                                  borderRadius: BorderRadius.circular(15),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${DateFormat('dd-MM-yyyy').format(capturedAtDateTime)}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white, // Text color
                                          ),
                                        ),
                                        Text(
                                          "${DateFormat('hh:mm a').format(capturedAtDateTime)}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white, // Text color
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: showResetButton
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: resetScene,
                child: const Icon(Icons.refresh),
              ),
            )
          : null,
    );
  }
}
