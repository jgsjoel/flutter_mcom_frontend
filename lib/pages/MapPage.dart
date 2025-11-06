import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mcommerce/state/CheckoutState.dart';
import 'package:mcommerce/state/MapState.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    context.read<MapState>().getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          Consumer<MapState>(
            builder: (context, provider, child) {
              return provider.currentUserLocation == null
                  ? const Center(child: Text("Loading..."))
                  : GoogleMap(
                      onMapCreated: (GoogleMapController controller) {
                        _mapController = controller;
                        provider.mapController = controller;
                      },
                      initialCameraPosition: CameraPosition(
                        target: provider.currentUserLocation!,
                        zoom: 17,
                      ),
                      onCameraMove: (cameraPosition) {
                        provider.updateDeliveryLocation(cameraPosition.target);
                      },
                      markers: provider.buildMarkers(),
                    );
            },
          ),

          Positioned(
            top: 60,
            left: 10,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),

      
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 4,
          fixedSize: const Size(110, 50),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          backgroundColor: Colors.black,
        ),
        onPressed: () async {
          var mapState = Provider.of<MapState>(context, listen: false);
          var checkoutState = Provider.of<CheckoutState>(context, listen: false);

          await checkoutState.updateDeliveryCost(mapState.deliveryLocation!);

          Navigator.pop(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Confirm",
              style: TextStyle(color: Colors.white),
            ),
            Icon(
              Icons.check,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
