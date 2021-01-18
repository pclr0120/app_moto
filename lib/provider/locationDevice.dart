import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:moto_app/model/locationDevice.dart';

class LocationDevice with ChangeNotifier {
  Location _location;

  // ignore: unnecessary_getters_setters
  Location get location => _location;

  // ignore: unnecessary_getters_setters
  set location(Location location) {
    _location = location;
  }

  LocationData _locationData;
  Completer<GoogleMapController> _controller = Completer();

  Completer<GoogleMapController> get controller => _controller;

  set controller(Completer<GoogleMapController> controller) {
    _controller = controller;
    notifyListeners();
  }

  LocationData get locationData => _locationData;

  set locationData(LocationData locationData) {
    _locationData = locationData;
    notifyListeners();
  }

  LoctionDevice _locationDeviceData;

  LocationDevice() {
    LocationData s;

    this.getPermisos();
  }

  LoctionDevice get locationDeviceData => _locationDeviceData;

  set locationDeviceData(LoctionDevice locationDevice) {
    _locationDeviceData = locationDevice;
    notifyListeners();
  }

  getPermisos() async {
    this.location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    // this._locationData = await location.getLocation();

    // location.onLocationChanged.listen((LocationData currentLocation) {
    //   // Use current locationç

    //   this.locationDeviceData.lat = currentLocation.latitude;
    //   this.locationDeviceData.log = currentLocation.longitude;
    //   // this.controller.print(this.locationDeviceData.log);
    // }).onData((data) {
    //   this.locationData = data;
    // });
  }

  getLocation() {}

  error() {
    print("errors");
  }
}
