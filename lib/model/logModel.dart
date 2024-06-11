import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class LogData {
  final String id;
  final String username;
  final vector.Vector3 position;
  final DateTime date;
  final PlaceLocation currentLocation;

  LogData({
    required this.id,
    required this.username,
    required this.position,
    required this.date,
    required this.currentLocation,
  });

  String get formattedDate {
    return formatter.format(date);
  }

  Map<String, dynamic> get logMap {
    return {
      'id': id,
      'username': username,
      'posX': position.x,
      'posY': position.y,
      'posZ': position.z,
      'date': date.toIso8601String(),
      'latitude': currentLocation.latitude,
      'longitude': currentLocation.longitude,
      'address': currentLocation.address,
    };
  }
}

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}
