import '../../shared/components.dart';
import '../ResetScreen.dart';
import '../homePage.dart';
import 'register.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

import '../../shared/cash_helper.dart';


class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var state;
  bool isObsecured=true;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var nameController = TextEditingController();
  var passwordConfirmController=TextEditingController();
  var formKey = GlobalKey<FormState>();
  void userLogin({
    @required String email,
    @required String password,
  })
  {
    setState(() {
    state ='loading';
  });
    // emit(SocialLoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)
        .then((value)
    {
      print(value.user.uid);
      print(value.user.email);
      CacheHelper.saveData(key: 'uId', value: value.user.uid);

      if(CacheHelper.getData(key: 'uId')!=null){
        Fluttertoast.showToast(
          msg: 'Login Success',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        navigateAndEnd(context, HomePage());

      }
      // emit(SocialLoginSuccessState(value.user.uid));
    })
        .catchError((onError)
    {
      Fluttertoast.showToast(
        msg: onError.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      setState(() {
        state ='error';
      });
      // emit(SocialLoginErrorState(onError.toString()));
    });

  }
  @override
  Widget build(BuildContext context) {
    timeDilation=3.0;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
          children:
          [
            Container(
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/background.webp',),
                      fit: BoxFit.cover,
                    )
                ),
                child: BackdropFilter(filter:
                ImageFilter.blur(
                  sigmaX:10,
                  sigmaY:10,
                ),
                  child: Container(
                    color: Colors.black.withOpacity(.35),
                  ),)
            ),
            Padding(
              padding:  EdgeInsets.only(top: size.height*.1,left: size.width*.04),
              child: Container(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.location_city_outlined,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                SizedBox(width: size.width*.02,),
                                Text(
                                  'Indoor Positioning',
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    textStyle: Theme.of(context).textTheme.headline4,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          Text(
                            'Log in',
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
                                style:GoogleFonts.lato(
                                  color: Colors.white,
                                  textStyle: Theme.of(context).textTheme.headline4,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.italic,
                                )),
                          ),
                          SizedBox(
                            height: size.height*.07,
                          ),
                          defaultFormFeild(
                              context: context,
                              validatorText: 'please enter your Email Address',
                              controller: emailController,
                              inputType: TextInputType.emailAddress,
                              prefixIcon: Icon(Icons.email_outlined,color: Colors.white,),
                              labelText: 'Email Address'),
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
                                icon: isObsecured?Icon(Icons.visibility):Icon(Icons.visibility_off),
                                onPressed: (){
                                  setState(() {
                                    isObsecured=!isObsecured ;
                                  });
                                }),
                            inputType: TextInputType.visiblePassword,
                            prefixIcon: Icon(Icons.lock_outline,
                              color: Colors.white,),
                            labelText: 'Password',
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          ConditionalBuilder(
                            condition: state !='loading',
                            builder: (context) =>
                                Center(
                                  child: defaultButton(
                                    context: context,
                                    string: 'Log In',
                                    textColor: Colors.black,
                                    function: () {
                                      if (formKey.currentState.validate()) {
                                        print(emailController.text);
                                        userLogin(
                                            email: emailController.text.trim(),
                                            password: passwordController.text,
                                            );
                                      };


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
                                'Don\'t have an account?',
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
                                  navigateAndEnd(context, Register());
                                },
                                child: Text(
                                  'Sign Up',
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    textStyle: Theme.of(context).textTheme.headline4,
                                    fontSize: 21,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              )
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Forget Your Password?',
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
                                  navigateTo(context, ResetPasswordScreen());
                                },
                                child: Text(
                                  'Reset',
                                  style: GoogleFonts.lato(
                                    color: Colors.redAccent,
                                    textStyle: Theme.of(context).textTheme.headline4,
                                    fontSize: 21,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
}
