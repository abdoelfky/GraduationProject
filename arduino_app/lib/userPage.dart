import'package:flutter/material.dart';
import 'package:simple_tooltip/simple_tooltip.dart';
import'package:sklite/SVM/SVM.dart';
import'package:sklite/utils/io.dart';
import'dart:convert';
import 'package:arduino_app/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'constants.dart';

var value;

class UserPage extends StatefulWidget {
  final String name;
  UserPage({@required this.name}) ;
  @override
  _UserPageState createState() {
    return new _UserPageState();
  }
}

class _UserPageState extends State<UserPage> {
  final Future<FirebaseApp> _future = Firebase.initializeApp();
  final databaseRef = FirebaseDatabase.instance.reference();

  void printFirebase(){

    Future.delayed(const Duration(milliseconds: 2000), () {

      databaseRef.onValue.listen((Event event) {
        setState(() {
          x=[-30.0,-40.0];
          RSSI=event.snapshot.value;
          RSSI.forEach((k, v) => x.add((v.toDouble())));
        });

        print('Data: $x');
      });

    });


  }
  SVC svc;
  _UserPageState() {
    //Load model
    loadModel("assets/svc.json").then((x) {
      this.svc = SVC.fromMap(json.decode(x));
    });
  }

  bool _show = false;
  @override
  Widget build(BuildContext context) {
    printFirebase();
    learnDemo();
    Size size =MediaQuery.of(context).size;
  return Scaffold(
      appBar: AppBar(

        elevation: 20,
        backgroundColor:primaryColor,
        title: Text(widget.name),
      ),
      body: Stack(
        children: [
          Container(
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/map3.png',),
                    fit: BoxFit.cover,
                  )
              ),
          ),
          //room1
          if(value==1)

          AnimatedPositioned(
            top: size.height*.21,
            left: size.width*.11,
            duration: const Duration(seconds: 2),
            curve: Curves.fastOutSlowIn,
            child:
            location(),

          ),
          if(value==2)

            AnimatedPositioned(
            top: size.height*.21,
            left: size.width*.54,
            duration: const Duration(seconds: 2),
            curve: Curves.fastOutSlowIn,
            child:
            location(),

          ),
           if(value==3)

            AnimatedPositioned(
              top: size.height*.52,
              left: size.width*.5,
              duration: const Duration(seconds: 2),
              curve: Curves.fastOutSlowIn,
              child:
              location(),

            ),



        ],

      ),
    );
  }


  Widget location()=> SimpleTooltip(
    hideOnTooltipTap: true,
    maxWidth: 150,
    maxHeight: 60,
    borderColor: Colors.grey,
    ballonPadding: EdgeInsets.all(1),
    arrowBaseWidth:10 ,
    arrowLength: 5,
    arrowTipDistance: 4,
    animationDuration: Duration(seconds: 1),
    show: _show,
    tooltipDirection: TooltipDirection.up,
    child:
    CircleAvatar(
      radius: 60,
      backgroundColor: Colors.blue.withOpacity(.25),
      child: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.blue.withOpacity(.38),
        child: Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.blue.withOpacity(.9)
          ),
          child:
          IconButton(
            onPressed: (){
              setState(() {
                _show=!_show;
                print(_show);
                Future.delayed(const Duration(milliseconds: 1500), () {

                  setState(() {
                    _show=!_show;
                  });

                });
              });
            },
            icon: Icon(
              Icons.person_sharp,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    ),

    content: Text(
      "Location",
      style: TextStyle(
        color: Colors.black,
        fontSize: 15,
        decoration: TextDecoration.none,
      ),
    ),
  );
  learnDemo() async{

    print("SVC");
    print(svc.predict(x));
    setState(() {value=svc.predict(x);});
  }
}












