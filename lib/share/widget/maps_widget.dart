import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moto_app/provider/location_device.dart';
import 'package:provider/provider.dart';

class Maps extends StatefulWidget {
  @override
  State<Maps> createState() => MapsState();
}

class MapsState extends State<Maps> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  @override
  void initState() {
    super.initState();
  }

  CameraPosition _locationInit = CameraPosition(
    target: LatLng(25.950212, -108.932921),
    zoom: 18.0,
  );

  @override
  Widget build(BuildContext context) {
    _locationInit = CameraPosition(
      target: LatLng(
          Provider.of<LocationDevice>(context, listen: true)
              .locationData
              .latitude,
          Provider.of<LocationDevice>(context, listen: true)
              .locationData
              .longitude),
      zoom: 18.0,
    );

    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _locationInit,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomGesturesEnabled: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print("hola");
        },
        label: FadeInLeft(
          child: Text(
            "lat:" +
                Provider.of<LocationDevice>(context, listen: true)
                    .locationData
                    .latitude
                    .toString() +
                "/long:" +
                Provider.of<LocationDevice>(context, listen: true)
                    .locationData
                    .longitude
                    .toString(),
            style: TextStyle(fontSize: 8.0),
          ),
        ),
        backgroundColor: Colors.amberAccent,
        icon: Icon(Icons.map_rounded),
      ),
    );
  }
}
