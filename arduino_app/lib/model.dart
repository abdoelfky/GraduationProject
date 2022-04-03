import'package:flutter/material.dart';
import'package:sklite/SVM/SVM.dart';
import'package:sklite/utils/io.dart';
import'dart:convert';
import 'package:arduino_app/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'constants.dart';

var value;


class Home extends StatefulWidget {
  @override
  _HomePageState createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<Home> {
  final textcontroller = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.reference();
  final Future<FirebaseApp> _future = Firebase.initializeApp();

  // void addData(String data) {
  //   databaseRef.push().set({'name': data, 'comment': 'A good season'});
  // }

  void printFirebase(){
    databaseRef.onValue.listen((Event event) {
      setState(() {
        x=[-30.0,-40.0];
        RSSI=event.snapshot.value;
        RSSI.forEach((k, v) => x.add((v.toDouble())));
      });
      print('Data: $x');
    });
  }
  SVC svc;
  _HomePageState() {
    //Load model
    loadModel("assets/svc.json").then((x) {
      this.svc = SVC.fromMap(json.decode(x));
    });
  }

  @override
  Widget build(BuildContext context) {
    printFirebase();
    learnDemo();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('SVM algorithm demonstration'),
            RaisedButton(
              child: Text('Start machine learning'),
              onPressed: (){
                learnDemo();
              },
            ),
            Text('room :$value'),
          ],
        ),
      ),
    );
  }

  learnDemo() async{

    print("SVC");
    print(svc.predict(x));
    setState(() {value=svc.predict(x);});
  }
}