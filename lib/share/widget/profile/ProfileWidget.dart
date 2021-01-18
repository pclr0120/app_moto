import 'package:animate_do/animate_do.dart';

import 'package:flutter/material.dart';
import 'package:moto_app/provider/AuthProvider.dart';
import 'package:provider/provider.dart';

class ProfileWidget extends StatefulWidget {
  ProfileWidget({Key key}) : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: ZoomIn(
                child: Container(
                  height: 30.0,
                  width: 35.0,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: new AssetImage("images/logo.png"),
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            Flexible(
              flex: 3,
              child: ZoomIn(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    Provider.of<AuthProvider>(context, listen: true)
                                .userModel ==
                            null
                        ? "cargando..."
                        : Provider.of<AuthProvider>(context, listen: true)
                            .userModel
                            .email,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
