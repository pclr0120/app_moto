import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moto_app/provider/AuthProvider.dart';
import 'package:provider/provider.dart';

class ButtonLogOut extends StatelessWidget {
  const ButtonLogOut({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _butonLogOut = GestureDetector(
      onTap: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text("Cerrar sesion ?"),
            content: Text(" "),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('NO'),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('SI'),
                onPressed: () async {
                  Provider.of<AuthProvider>(context, listen: false)
                      .logOut(context);
                },
              )
            ],
          ),
        );
        // Provider.of<AuthProvider>(context, listen: false).logOut(context);
      },
      child: Container(
        height: 30.0,
        width: 50.0,
        // decoration: new BoxDecoration(
        //   borderRadius: BorderRadius.circular(15.0),
        //   gradient: LinearGradient(
        //       colors: [Colors.red[900], Colors.red[100]],
        //       begin: const FractionalOffset(0.5, 0.1),
        //       end: const FractionalOffset(0.5, 0.9)),
        // ),
        child: Center(
          child: Icon(
            Icons.logout,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
    return _butonLogOut;
  }
}
