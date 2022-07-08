import 'dart:async';
import 'dart:ui';
import 'package:arduino_app/modules/settings/edit_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'settings/settings.dart';
import '../shared/components.dart';
import '../models/userModel.dart';
import 'userPage.dart';
import 'userPage2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../shared/cash_helper.dart';
import '../shared/constants.dart';
import 'contact_us.dart';
import 'auth/login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePAgeState createState() => _HomePAgeState();
}

class _HomePAgeState extends State<HomePage> {
  UserModel userModel;

  void getUserData() {
    uId = CacheHelper.getData(key: 'uId');
    print('---------------');
    print(FirebaseAuth.instance.currentUser.emailVerified);
    setState(() {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .get()
          .then((value) {
        print(value.data());
        setState(() {
          userModel = UserModel.fromJson(value.data());
        });
        // emit(SocialGetUserSuccessState());
      }).catchError((onError) {
        // emit(SocialGetUserErrorState(onError.toString()));
      });
    });
  }


  Future<void> verify()async
  {

    var user= await FirebaseAuth.instance.currentUser;
    user.sendEmailVerification().then((value)
    {

      Fluttertoast.showToast(
        msg: 'Sent Successfully',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }).catchError((onError){

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



  @override
  Widget build(BuildContext context) {
    if (userModel == null) getUserData();

    Timer(
        const Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Scaffold(
                  backgroundColor: Colors.grey[300],
                  drawer: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(35),
                        bottomRight: Radius.circular(35)),
                    child: Drawer(
                      child: Material(
                        color: primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            children: <Widget>[

                              buildHeader(
                                  Image: 'assets/user.png',
                                  name: '${userModel.name}',
                                  email: '${userModel.email}',
                                  phone: '${userModel.phone}',
                                  Context: context),

                              myDivider(),

                              Container(
                                child: Column(

                                  children: [
                                    const SizedBox(height: 8),
                                    if(FirebaseAuth.instance.currentUser.emailVerified==false)
                                      buildMenuItem(
                                      hoverColor: Colors.redAccent,
                                      color: Colors.redAccent,
                                        text: 'Verify Your Account',
                                        icon: Icons.verified_outlined,
                                        onClicked: ()=>verify()
                                        ),
                                    if(FirebaseAuth.instance.currentUser.emailVerified==false)
                                      myDivider(),
                                    buildMenuItem(
                                        text: 'Home Refresh',
                                        icon: Icons.home_outlined,
                                        onClicked: ()
                                        {
                                          navigateAndEnd(context, HomePage());
                                        }
                                    ),

                                    myDivider(),
                                    const SizedBox(height: 8),
                                    buildMenuItem(
                                        text: 'Settings',
                                        icon: Icons.settings_outlined,
                                        onClicked: () => Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>SettingsScreen(),
                                        ))),

                                    myDivider(),
                                    const SizedBox(height: 8),
                                    buildMenuItem(
                                        text: 'About Us',
                                        icon: Icons.info_outline_rounded,
                                        onClicked: () => Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) => const AboutUsScreen(),
                                            ))),

                                    myDivider(),
                                    buildMenuItem(
                                        text: 'Logout',
                                        icon: Icons.logout,
                                        onClicked: () => {
                                              CacheHelper.removeData(
                                                  key: 'uId'),
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
                                              )
                                            }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  appBar: AppBar(
                    backgroundColor: primaryColor,
                    title: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Users'),
                        ),
                        Spacer(),
                        Icon(Icons.location_city_outlined)
                      ],
                    ),
                  ),
                  body: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ListView.builder(
                        itemCount: 2,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) =>
                            buildItems(context, index)),
                  ),
                ))));
    return Scaffold(
      body: Stack(
        children: [
          Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(
                  'assets/background.webp',
                ),
                fit: BoxFit.cover,
              )),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 0,
                  sigmaY: 0,
                ),
                child: Container(
                  color: Colors.white.withOpacity(0),
                ),
              )),
          Center(
            child: Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height * .7),
              child: const LinearProgressIndicator(
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildItems(context, index) => InkWell(
      onTap: () {
        if (index == 0) {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return UserPage(
              name: 'User ${index + 1}',
            );
          }));
        } else {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return UserPage2(
              name: 'User ${index + 1}',
            );
          }));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Card(
          color: Colors.grey.shade100,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(10)),
          ),
          elevation: 10.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30.0,
                  backgroundColor: secondColor,
                  backgroundImage: AssetImage('assets/user.png'),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'User ${index + 1}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

Widget buildMenuItem({
  var color=Colors.white,
  var hoverColor=Colors.white70,
  @required String text,
  @required IconData icon,
  VoidCallback onClicked,
}) {

  return ListTile(
    leading: Icon(icon,color: hoverColor,),
    title: Text(text, style:TextStyle(color: color)),
    hoverColor: hoverColor,
    onTap: onClicked,
  );
}

Widget buildHeader({
  @required String Image,
  @required String name,
  @required String email,
  @required String phone,
  @required Context,
}) =>
    InkWell(
      onTap: (){
        navigateTo(Context, EditProfileScreen());
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                  radius: 30,
                  backgroundColor: secondColor,
                  backgroundImage: AssetImage(Image)),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.length > 6 ? name.substring(0, 6)+'...' : name,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  email.length > 14 ? email.substring(0, 14)+'...' : email,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  phone,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
            const Spacer(),
            const CircleAvatar(
              radius: 28.0,
              backgroundImage: AssetImage("assets/logo.png"),
              backgroundColor: Colors.transparent,
            )
          ],
        ),
      ),
    );
