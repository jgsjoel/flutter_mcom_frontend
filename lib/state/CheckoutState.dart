import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mcommerce/main.dart';
import 'package:mcommerce/pages/MainLayout.dart';
import 'package:mcommerce/services/ApiService.dart';
import 'package:mcommerce/state/GlobalState.dart';
import 'package:provider/provider.dart';

class CheckoutState extends ChangeNotifier {
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();

  double subtotal = 0.00;
  double delivery = 0.00;
  double? total;
  LatLng? _destination;
  LatLng? sourceLocation;
  double baseCost = 0;
  double incrementCost = 0;
  int baseRadius = 0;

  bool isLoading = true;

  Future<void> loadCheckoutData() async {
    Apiservice.getRequest("/checkout", (response) async {
      var respData = await response.data;
      addressController.text = respData["address"] ?? "";
      nameController.text = respData["userName"] ?? "";
      mobileController.text = respData["mobile"] ?? "";
      subtotal = respData["subTotal"] ?? 0.00;
      _destination =
          LatLng(respData["desLat"] ?? 0.00, respData["desLon"] ?? 0.00);
      sourceLocation =
          LatLng(respData["srcLat"] ?? 0.00, respData["srcLon"] ?? 0.00);
      baseRadius = respData["baseRadius"];
      baseCost = respData["basePrice"];
      incrementCost = respData["incPricce"];

      await calculateDeliveryCost(sourceLocation!, _destination!);

      isLoading = false;
      notifyListeners();
    });
  }

  Future<int> fetchDistance(LatLng sourceLocation, LatLng destination) async {
    final dio = Dio();
    try {
      var response = await dio.get(
          "https://maps.googleapis.com/maps/api/directions/json?origin=${sourceLocation.latitude},${sourceLocation.longitude}&destination=${destination.latitude},${destination.longitude}&key=${dotenv.env['MAPS_API_KEY']}");
      if (response.data != null) {
        var distance =
            response.data['routes'][0]['legs'][0]['distance']['value'];
        print("fetch distance: ${distance}");
        return distance;
      }
    } catch (e) {
      print(e);
    }
    return 0;
  }

  Future<void> calculateDeliveryCost(
      LatLng sourceLocation, LatLng destination) async {
    _destination = destination;
    var distanceInMeters = await fetchDistance(sourceLocation, destination);
    if (distanceInMeters > baseRadius) {
      var balance = distanceInMeters - baseRadius;
      var additional = ((balance / 1000).ceil()) * incrementCost;
      delivery = baseCost + additional;
    } else if (destination.latitude != 0.00 && destination.longitude != 0.00) {
      delivery = baseCost;
    }
  }

  Future<void> updateDeliveryCost(LatLng destination) async {
    await calculateDeliveryCost(sourceLocation!, destination);
    notifyListeners();
  }

  void saveUserDetails() {
    Apiservice.postRequest(
        "/checkout",
        {
          "address": addressController.text,
          "latitude": _destination?.latitude,
          "longitude": _destination?.longitude,
          "total": (subtotal + delivery)
        },
        Options(headers: {Headers.contentTypeHeader: "application/json"}),
        (response) async {
      await initPaymentSheet(response.data);
    });
  }

  Future<void> initPaymentSheet(String paymentIntent) async {
    try {
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              merchantDisplayName: "Dough Delight",
              paymentIntentClientSecret: paymentIntent));

      await Stripe.instance.presentPaymentSheet();

      final globalState =
          Provider.of<Globalstate>(navigatorKey.currentContext!, listen: false);
      globalState.getCount();

      Navigator.pushAndRemoveUntil(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => Mainlayout(initialIndex: 2)),
        (route) => false,
      );
    } catch (e) {
      if (e is StripeException) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(content: Text("Error: ${e.error.localizedMessage}")),
        );
      } else {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(content: Text("An unexpected error occurred")),
        );
      }
    }
  }
}
