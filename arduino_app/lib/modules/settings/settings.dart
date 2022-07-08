import 'package:arduino_app/modules/settings/change_password.dart';
import 'package:arduino_app/modules/settings/edit_profile.dart';
import 'package:arduino_app/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';

import '../../models/userModel.dart';
import '../../shared/cash_helper.dart';
import '../../shared/components.dart';
import '../auth/login.dart';





class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);



  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    bool _hasInternet =false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
            'Settings'
        ),
        elevation: 10,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(Icons.settings_outlined),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 20,),
            buildListTile(
              // Colors.black,
                "Edit Profile",
                Icons.edit_outlined,
                    (){

                    navigateTo(
                      context,
                      EditProfileScreen(),
                    );



                }
            ),
            buildListTile(
              // Colors.black,
                "Change Password",
                Icons.lock_outlined,
                    (){
                  navigateTo(context, (ChangePasswordScreen()));
                }
            ),
            buildListTile(
              // Colors.black,
                "Delete Account",
                Icons.delete_outline_outlined,
                    ()async{
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            elevation: 24.0,
                            title: const Text('Are You Sure?'),
                            content: const Text(
                                'You will not be able to recover it'),
                            actions: [
                              CupertinoDialogAction(
                                child: Text('Delete',style: TextStyle(
                                  color: Colors.red
                                ),),
                                onPressed: () {
                                  setState(() {
                                    var user = FirebaseAuth.instance.currentUser;
                                    if (user != null) {
                                      user.delete().then((value){

                                        Fluttertoast.showToast(
                                          msg: 'Delete Successfully',
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 5,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                        CacheHelper.removeData(
                                            key: 'uId');
                                        Navigator.pushReplacement(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeftWithFade,
                                              duration: Duration(
                                                  milliseconds: 500),
                                              reverseDuration: Duration(
                                                  milliseconds: 500),
                                              child: Login(),
                                              inheritTheme: true,
                                              ctx: context),
                                        );

                                      }
                                      ).catchError((onError){

                                        Fluttertoast.showToast(
                                          msg: onError,
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 5,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      });
                                    }
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              myDivider(),
                              CupertinoDialogAction(
                                child: Text('Cancel'),
                                onPressed: () {
                                  setState(() {});
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ));




                }
            ),
            buildListTile(
              // Colors.black,
                "Log Out",
                Icons.logout_rounded,
                    (){
                      CacheHelper.removeData(
                          key: 'uId');
                      Navigator.pushReplacement(
                      context,
                      PageTransition(
                      type: PageTransitionType
                          .rightToLeftWithFade,
                      duration: Duration(
                      milliseconds: 500),
                      reverseDuration: Duration(
                      milliseconds: 500),
                      child: Login(),
                      inheritTheme: true,
                      ctx: context),
                      );
                }
            ),



          ],
        ),
      ),
    );
  }
}

