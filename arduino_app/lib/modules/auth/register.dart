import 'dart:ui';
import 'package:arduino_app/modules/auth/verifyScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../shared/cash_helper.dart';
import '../../shared/components.dart';
import '../homePage.dart';
import 'login.dart';
import '../../models/userModel.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isObsecured = true;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var nameController = TextEditingController();
  var passwordConfirmController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  UserModel userModel;
  var state;

  @override
  void userRegister({
    @required String email,
    @required String password,
    @required String name,
    @required String phone,
  }) {
    setState(() {
      setState(() {
        state = 'loading';
      });
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        print(value.user.email);
        print(value.user.uid);
        userCreate(email: email, name: name, phone: phone, uId: value.user.uid);
      }).catchError((onError) {
        print(onError);
        setState(() {
          state = 'error';
        });
      });
    });
  }

  void userCreate({
    @required String email,
    @required String name,
    @required String phone,
    @required String uId,
  }) {
    setState(() {
      UserModel model = UserModel(
        name: name,
        email: email,
        phone: phone,
        uId: uId,
        isEmailVerified: false,
      );
      userModel = model;
      setState(() {
        CacheHelper.saveData(key: 'uId', value: userModel.uId.toString());
      });
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .set(model.toMap())
          .then((value) {
        setState(() {
          if (CacheHelper.getData(key: 'uId') != null) {
            Fluttertoast.showToast(
              msg: 'Register Success',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 5,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            navigateAndEnd(context, VerifyScreen());
          }
          state = 'success';
        });
      }).catchError((onError) {
        Fluttertoast.showToast(
          msg: onError.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        print(onError);
      });
    });
  }

  Widget build(BuildContext context) {
    timeDilation = 4.0;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage(
                'assets/background.webp',
              ),
              fit: BoxFit.cover,
            )),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: Container(
                color: Colors.black.withOpacity(.35),
              ),
            )),
        Padding(
          padding:
              EdgeInsets.only(top: size.height * .08, left: size.width * .05),
          child: Container(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_city_outlined,
                              color: Colors.white,
                              size: 35,
                            ),
                            SizedBox(
                              width: size.width * .02,
                            ),
                            Text(
                              'Indoor Positioning',
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * .03,
                      ),
                      Text(
                        'Sign Up',
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          textStyle: Theme.of(context).textTheme.headline4,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Hero(
                        tag: 'TextTag',
                        child: Text('Enter your data to continue',
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              textStyle: Theme.of(context).textTheme.headline4,
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                            )),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      defaultFormFeild(
                        context: context,
                        validatorText: 'please enter your Name',
                        controller: nameController,
                        inputType: TextInputType.name,
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        labelText: 'Name',
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      defaultFormFeild(
                          context: context,
                          validatorText: 'please enter your Email Address',
                          controller: emailController,
                          inputType: TextInputType.emailAddress,
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Colors.white,
                          ),
                          labelText: 'Email Address'),
                      SizedBox(
                        height: 25.0,
                      ),
                      defaultFormFeild(
                        context: context,
                        validatorText: 'please enter your Phone Number',
                        controller: phoneController,
                        inputType: TextInputType.phone,
                        prefixIcon: Icon(
                          Icons.phone_iphone,
                          color: Colors.white,
                        ),
                        labelText: 'Phone Number',
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      defaultFormFeild(
                        context: context,
                        isObsecured: isObsecured,
                        validatorText: 'please enter your Password',
                        controller: passwordController,
                        suffixIcon: IconButton(
                            color: Colors.white,
                            icon: isObsecured
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                isObsecured = !isObsecured;
                              });
                            }),
                        inputType: TextInputType.visiblePassword,
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                        ),
                        labelText: 'Password',
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      ConditionalBuilder(
                        condition: state != 'loading',
                        builder: (context) => Center(
                          child: defaultButton(
                            context: context,
                            string: 'Submit',
                            function: () {
                              if (formKey.currentState.validate()) {
                                print(emailController.text);
                                userRegister(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                    name: nameController.text,
                                    phone: phoneController.text);
                              }
                              ;
                            },
                            color: Colors.white.withOpacity(.5),
                          ),
                        ),
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator()),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: GoogleFonts.lato(
                              color: Colors.white.withOpacity(.7),
                              textStyle: Theme.of(context).textTheme.headline4,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              navigateAndEnd(context, Login());
                            },
                            child: Text(
                              'Sign in',
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                fontSize: 21,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
