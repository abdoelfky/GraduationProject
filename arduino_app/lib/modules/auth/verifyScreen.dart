import 'dart:async';

import 'package:arduino_app/modules/homePage.dart';
import 'package:arduino_app/shared/components.dart';
import 'package:arduino_app/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../models/userModel.dart';
import '../../shared/cash_helper.dart';
import 'login.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {

  Future<void> verify()async
  {
    setState(() {
      state='loading';
    });
    var user= await FirebaseAuth.instance.currentUser;
    user.sendEmailVerification().then((value)

    {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            elevation: 24.0,
            title: const Text('Please Check Your Inbox'),
            content: const Text(
                'Please Check Your Inbox and Click To the Verification Link'),
            actions: [
              CupertinoDialogAction(
                child: const Text('Ok',style: TextStyle(fontWeight: FontWeight.bold),),
                onPressed: () {
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
            ],
          ));

      setState(() {
        state='success';
      });
      Fluttertoast.showToast(
        msg: 'Sent Successfully',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Timer.periodic(Duration(seconds:1), (timer) async{
        await FirebaseAuth.instance.currentUser..reload();
        print(FirebaseAuth.instance.currentUser.emailVerified);
        // do something or call a function
        if(FirebaseAuth.instance.currentUser.emailVerified==true) {
                 navigateAndEnd(context, HomePage());
                 timer.cancel();

        }

      });




    }).catchError((onError){
      setState(() {
        state='error';
      });
      Fluttertoast.showToast(
        msg: onError.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );

    });
  }
  var state;
  UserModel userModel;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text('Verification'),
        ),
        backgroundColor: primaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                const Text('Skip',style: TextStyle(fontSize: 20),),
                IconButton(onPressed:
                    (){
                  navigateAndEnd(context,HomePage());

                },
                    icon: Icon(Icons.arrow_forward_ios)),
              ],
            ),
          )
        ],
      ) ,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 40,),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Icon(Icons.info_outline_rounded,color: Colors.redAccent,size: 35,),
                  SizedBox(width: 5,),
                  Text(
                    'Your Account not Verified',
                    style: GoogleFonts.lato(
                      color: Colors.redAccent,
                      textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(child: Image(
                height: 250,
                  width: 250,
                  image: AssetImage('assets/v.png')

              )
              ),
            ),
            const SizedBox(height: 50,),
            Center(
              child:ConditionalBuilder(
                condition: state!='loading',
                builder: (context) =>
                    Center(
                      child: defaultButton(
                          width: 270,
                          textColor: Colors.white.withOpacity(.9),
                          context: context,
                          string: 'Verify Your Account',
                          color: primaryColor,
                          function:()async{
                            verify();
                              // showDialog(
                              //   context: context,
                              //   builder: (_) => AlertDialog(
                              //     elevation: 24.0,
                              //     title: const Text('Please Check Your Inbox'),
                              //     content: const Text(
                              //         'Please Check Your Inbox and Click To the Verification Link'),
                              //     actions: [
                              //       CupertinoDialogAction(
                              //         child: const Text('Ok',style: TextStyle(fontWeight: FontWeight.bold),),
                              //         onPressed: () {
                              //           setState(() {});
                              //           Navigator.pop(context);
                              //         },
                              //       ),
                              //     ],
                              //   ));


                          }
                      ),
                    ),
                fallback: (context) =>
                    const Center(child: CircularProgressIndicator()),
              ),

            ),

          ],
        ),
      ),
    );
  }
}



