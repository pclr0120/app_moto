import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:moto_app/provider/location_device.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<LocationDevice>(context, listen: false).getPermisos();
    super.initState();
  }

  @override
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
          SizedBox(height: 300.0),
          GestureDetector(
            child: FadeInLeftBig(
              child: Container(
                height: 50.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Column(
                    children: [
                      Icon(
                        Icons.map_outlined,
                        size: 10.0,
                      ),
                      Text("INICIAR MAPA"),
                    ],
                  )),
                ),
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(150.0),
                    gradient: LinearGradient(
                        colors: [Colors.amber, Colors.blue],
                        begin: const FractionalOffset(1.0, 0.1),
                        end: const FractionalOffset(1.0, 0.9))),
              ),
            ),
            onTap: () => {Navigator.pushNamed(context, '/prueba')},
          )
        ],
      ),
    );
  }
}
