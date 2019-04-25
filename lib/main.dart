import "dart:async";
import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import "package:local_auth/local_auth.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fingerprint Demo',
      home: MyHomePage(title: 'Fingerprint Demo'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 
  final LocalAuthentication auth = new LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = "Not Authorized";


  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics; 

    try {
      canCheckBiometrics = await auth.canCheckBiometrics;

    } on PlatformException catch (e) {
      print(e);
    }
    if(!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;

    try{
      availableBiometrics = await auth.getAvailableBiometrics();

    } on PlatformException catch(e){
      print(e);
    }
    if(!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;

    try {
      authenticated = await auth.authenticateWithBiometrics(
        localizedReason: "Scan your fingerprint to authenticate",
        useErrorDialogs: true,
        stickyAuth: false
      );

    } on PlatformException catch (e) {
    print(e);
    }

    if(!mounted) return;

    setState(() {
        _authorized = authenticated ? "Authorized" : "Non Authorized";
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        
        title: Text(widget.title),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Container(
          color: Colors.purple,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
                Text("Can check biometrics: $_canCheckBiometrics\n",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0
                  ),
                ),
                RaisedButton(
                  child: const Text("Check Biometrics"),
                  onPressed: _checkBiometrics,
                ),
                Text("Available biometrics: $_availableBiometrics\n",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16.0
                  ),
                  ),
                  RaisedButton(
                  child: const Text("Get Availabele Biometrics"),
                  onPressed: _getAvailableBiometrics,
                ),
                Text("Current State: $_authorized\n",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0
                  ),
                  ),
                  RaisedButton(
                  child: const Text("Authenticate"),
                  onPressed: _authenticate,
                ),
          ],
          ),
        ),
      )
    );
  }
}
