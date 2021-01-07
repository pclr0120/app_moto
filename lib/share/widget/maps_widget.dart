import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:moto_app/model/location_api.dart';
import 'package:moto_app/provider/location_device.dart';
import 'package:provider/provider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:signalr_core/signalr_core.dart';
import 'dart:convert';

class Maps extends StatefulWidget {
  @override
  State<Maps> createState() => MapsState();
}

class MapsState extends State<Maps> {
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;
  Location location;
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _initCameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  double _originLatitude = 6.5212402, _originLongitude = 3.3679965;
  double _destLatitude = 6.849660, _destLongitude = 3.648190;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Uuid id;
  HubConnection _connection;
  bool _isConectado = false;
  String _myUsuario;
  double _long0 = 0;
  double _lat0 = 0;

  MapsState() {
    getPermisos();
  }
  @override
  void initState() {
    super.initState();
    setState(() {
      this._long0 = 0;
      this._lat0 = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: _initCameraPosition,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomGesturesEnabled: true,
          tiltGesturesEnabled: true,
          zoomControlsEnabled: true,
          markers: Set<Marker>.of(markers.values),
          polylines: Set<Polyline>.of(polylines.values),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          myLocate();
        },
        label: FadeInLeft(
          child:
              Provider.of<LocationDevice>(context, listen: true).locationData !=
                      null
                  ? Column(
                      children: [
                        Text(
                          "u1 lat:" +
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
                        Text(
                          " U2 lata:" +
                              this._long0.toString() +
                              "/long:" +
                              this._lat0.toString(),
                          style: TextStyle(fontSize: 8.0),
                        )
                      ],
                    )
                  : Text("0"),
        ),
        backgroundColor: Colors.amberAccent,
        icon: Icon(Icons.map_rounded),
      ),
    );
  }

  getPermisos() async {
    _initConectionAPI();
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

    location.onLocationChanged.listen((LocationData currentLocation) {
      // Use current locationç
    }).onData((data) async {
      dibujarMaker(data);
      _enviarLocation(data);

      setState(() {
        Provider.of<LocationDevice>(context, listen: false).locationData = data;
      });
    });
  }

  dibujarMaker(LocationData data) async {
    // final GoogleMapController controller = await _controller.future;
    // controller.animateCamera(
    //   CameraUpdate.newCameraPosition(
    //     CameraPosition(
    //       target: LatLng(data.latitude, data.longitude),
    //       zoom: 18.0,
    //     ),
    //   ),
    // );
    _addMarker(LatLng(data.latitude, data.longitude), "destination",
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    String id = new Uuid().v4();
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    setState(() {
      markers[markerId] = marker;
    });
  }

  Future<void> _initConectionAPI() async {
    this._connection = HubConnectionBuilder()
        .withUrl(
            'http://107.180.100.204:8080/location',
            HttpConnectionOptions(
              withCredentials: false,
              client: IOClient(HttpClient()
                ..badCertificateCallback = (x, y, z) {
                  return true;
                }),
              // logging: (level, message) => print(message),
            ))
        .build();

    await this._connection.start().whenComplete(() {
      this._myUsuario = this._connection.connectionId;
      this._isConectado = true;
      print(
          "Conectado:" + this._isConectado.toString() + "/" + this._myUsuario);
    });

    _connection.on('RecibirLocation', (message) {
      print("RecibirLocation");
      // if (_count == 0) {
      //   print(message[0]['usuario']);
      //   this._usuario = message[0]['usuario'];
      //   _count += 1;
      // }
      if (this._myUsuario != message[0]['usuario']) {
        print("Usuario añadido");
        this._lat0 = message[0]['latitude'];
        this._long0 = message[0]['longitude'];

        _addMarker(
            LatLng(message[0]['latitude'], message[0]['longitude']),
            "origin",
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue));
      }
    });
  }

// 25.951602, -108.927023
  Future<void> _enviarLocation(LocationData data) async {
    if (_isConectado)
      await this._connection.invoke('EnviarLocation', args: [
        {
          'Latitude': data.latitude,
          'Longitude': data.longitude,
          'Altitude': data.altitude
        }
      ]);
    else
      print("No se envio");
  }

  myLocate() {
    //_enviarLocation();
    setState(() async {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
                Provider.of<LocationDevice>(context, listen: false)
                    .locationData
                    .latitude,
                Provider.of<LocationDevice>(context, listen: false)
                    .locationData
                    .longitude),
            zoom: 18.0,
          ),
        ),
      );
    });
  }
}
