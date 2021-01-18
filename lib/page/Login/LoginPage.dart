import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moto_app/provider/AuthProvider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _frmLogin = GlobalKey<FormState>();
  TextEditingController _inputMail = TextEditingController();
  TextEditingController _inputPass = TextEditingController();
  FToast fToast;
  String errorAuth;
  void onValueChange() {
    setState(() {
      _inputMail.text;
      _inputPass.text;
    });
  }

  @override
  void setState(fn) {
    super.setState(fn);
    fToast = FToast();
    fToast.init(context);
  }

  @override
  void initState() {
    super.initState();
    _inputMail.addListener(onValueChange);
    _inputPass.addListener(onValueChange);
    errorAuth = null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("images/fondo.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ZoomIn(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          height: 80.0,
                          decoration: new BoxDecoration(
                            image: new DecorationImage(
                              image: new AssetImage("images/logo2.png"),
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Form(key: _frmLogin, child: _formLogin()))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formLogin() {
    var _errorAuthMsn = Text(
      this.errorAuth != null ? this.errorAuth : '',
      style: TextStyle(
          fontSize: 14.0,
          color: Colors.blueAccent[400],
          fontWeight: FontWeight.w800),
    );

    var _inputEmail = Container(
      height: 60.5,
      child: TextFormField(
        controller: _inputMail,
        readOnly: false,
        maxLength: 50,
        decoration: InputDecoration(
          counterText: "",
          fillColor: Colors.transparent,
          filled: true,
          labelText: 'Correo',
          icon: Icon(Icons.email, color: Colors.white),
          labelStyle: TextStyle(color: Colors.white, fontSize: 16),
          counterStyle: TextStyle(color: Colors.white),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(30.0),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(color: Colors.white)),
          hintStyle: TextStyle(color: Colors.white.withAlpha(80)),
        ),
        style: new TextStyle(
          color: Colors.white,
          fontSize: 12.0,
          fontWeight: FontWeight.w800,
        ),
        textAlign: TextAlign.left,
        // keyboardType: TextInputType.number,
        // inputFormatters: <TextInputFormatter>[
        //   WhitelistingTextInputFormatter.digitsOnly
        // ],
        validator: (String value) {
          String pattern =
              r'^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)';
          RegExp regExp = new RegExp(pattern);
          if (value.isEmpty) {
            return 'Se requiere capturar';
          } else if (!regExp.hasMatch(value)) {
            return 'Formato incorrecto';
          } else
            return null;
        },
      ),
    );
    var _inputPassword = Container(
      height: 60.5,
      child: TextFormField(
        obscureText: true,
        controller: _inputPass,
        readOnly: false,
        maxLength: 8,
        decoration: InputDecoration(
          fillColor: Colors.transparent,
          filled: true,
          labelText: 'Contraseña',
          icon: Icon(Icons.lock, color: Colors.white),
          labelStyle: TextStyle(color: Colors.white, fontSize: 16),
          counterStyle: TextStyle(color: Colors.white),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(30.0),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(color: Colors.white)),
          hintStyle: TextStyle(color: Colors.white.withAlpha(80)),
        ),
        style: new TextStyle(
          color: Colors.white,
          fontSize: 12.0,
          fontWeight: FontWeight.w800,
        ),
        textAlign: TextAlign.center,
        // keyboardType: TextInputType.number,
        // inputFormatters: <TextInputFormatter>[
        //   WhitelistingTextInputFormatter.digitsOnly
        // ],
        validator: (String value) {
          //  String pattern = r'^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$';
          // RegExp regExp = new RegExp(pattern);
          if (value.isEmpty) {
            return 'Se requiere capturar';
          } else
            return null;
        },
      ),
    );

    var _butonLogin = GestureDetector(
      onTap: () async {
        if (_frmLogin.currentState.validate()) {
          await Provider.of<AuthProvider>(context, listen: false)
              .login(this._inputMail.text, this._inputPass.text, context)
              .then((value) {
            if (value['status'] == "true")
              Navigator.pushNamed(context, 'home');
            else if (value['status'] == 'ERROR')
              _showToast(value['msn'], "TOP_RIGHT");
            else if (value['status'] == 'auth') {
              setState(() {
                this.errorAuth = value['msn'];
              });
            }
            _frmLogin.currentState.save();
          });
        } else {
          _showToast("Faltan campos por capturar", "TOP_RIGHT");
        }
      },
      child: Container(
        height: 30.0,
        width: 150.0,
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: LinearGradient(
              colors: [Colors.blue[900], Colors.red[400]],
              begin: const FractionalOffset(1.0, 0.1),
              end: const FractionalOffset(2.0, 0.9)),
        ),
        child: Center(
          child: Text(
            "INICIAR SESION",
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      ),
    );

    return Container(
      child: Card(
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        shadowColor: Colors.black,
        color: Colors.transparent,
        elevation: 10,
        child: Container(
          height: 350.0,
          padding: new EdgeInsets.all(32.0),
          child: Column(children: [
            SlideInDown(child: _inputEmail),
            SizedBox(
              height: 20,
            ),
            SlideInRight(child: _inputPassword),
            SizedBox(
              height: 5,
            ),
            Pulse(child: _errorAuthMsn),
            SizedBox(
              height: 5,
            ),
            SlideInLeft(child: Hero(tag: 'ls1', child: _butonLogin))
          ]),
        ),
      ),
    );
  }

  _showToast(String mensaje, String posicion) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.red,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning),
          SizedBox(
            width: 10.0,
          ),
          Text(
            mensaje,
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: posicion == "TOP_RIGHT"
          ? ToastGravity.TOP_RIGHT
          : ToastGravity.BOTTOM_LEFT,
      toastDuration: Duration(seconds: 3),
    );
  }
}
