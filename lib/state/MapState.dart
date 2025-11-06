import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapState extends ChangeNotifier {
  Location location = Location();
  late GoogleMapController mapController;

  LatLng? deliveryLocation;
  LatLng? currentUserLocation;

  void updateDeliveryLocation(LatLng newLocation) {
    deliveryLocation = newLocation;
    notifyListeners();
  }

  Set<Marker> buildMarkers() {
    return {
      if (currentUserLocation != null)
        Marker(
          markerId: const MarkerId("Current Location"),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: const InfoWindow(
            title: 'User Location',
            snippet: 'This is your location',
          ),
          position: currentUserLocation!,
        ),
      if (deliveryLocation != null)
        Marker(
          markerId: const MarkerId("Delivery Location"),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: const InfoWindow(
            title: 'Delivery Location',
            snippet: 'This is where the delivery will be made',
          ),
          position: deliveryLocation!,
        ),
    };
  }

  Future<void> getLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    location.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        currentUserLocation = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );

        if (deliveryLocation == null) {
          deliveryLocation = currentUserLocation;
        }

        notifyListeners();
      }
    });
  }
}
