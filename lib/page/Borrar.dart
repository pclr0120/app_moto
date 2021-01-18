import 'package:flutter/material.dart';
import 'package:moto_app/provider/locationDevice.dart';
import 'package:provider/provider.dart';

class GetLocationPage extends StatefulWidget {
  GetLocationPage({Key key}) : super(key: key);

  @override
  _GetLocationPageState createState() => _GetLocationPageState();
}

class _GetLocationPageState extends State<GetLocationPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'APP MOTO',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: new Column(
        children: <Widget>[
          Text(
            "Localizacion:->" +
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
          )
        ],
      ),
    );
  }
}
