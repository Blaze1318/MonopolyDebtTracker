import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Load extends StatefulWidget {
  const Load({Key? key}) : super(key: key);

  @override
  _LoadState createState() => _LoadState();
}

class _LoadState extends State<Load> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Colors.lightBlueAccent,
        body: Center(
            child: SpinKitPulse(
              color: Colors.white,
              size: 50.0,
            )
        )
    );
  }
}
