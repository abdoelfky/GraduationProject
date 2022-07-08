import 'package:arduino_app/shared/constants.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../shared/components.dart';
import '../ResetScreen.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var oldPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmNewPasswordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isObsecured1=true;
  bool isObsecured2=true;
  bool isObsecured3=true;
  var state;
  Future<void> changePassword({
    @required String oldPassword,
    @required String newPassword,
  })
  async {
    setState(() {
      state ='loading';
    });
    var user = FirebaseAuth.instance.currentUser;
    String email = user.email;

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: oldPassword,
      );

      user.updatePassword(newPassword).then((_){
        print("Successfully changed password");
        setState(() {
          state ='success';
        });
        setState(() {
          newPasswordController.text='';
        });
        setState(() {
          oldPasswordController.text='';
        });
        setState(() {
          confirmNewPasswordController.text='';
        });
        Fluttertoast.showToast(
          msg: 'Password Changed Successfully',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }).catchError((error){
        print("Password can't be changed" + error.toString());
        Fluttertoast.showToast(
          msg:"Password can't be changed",
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
        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      setState(() {
        state ='error';
      });
      Fluttertoast.showToast(
        msg: e.code,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }


  }
  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Settings'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(Icons.settings_outlined),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key:formKey,
            child: Column(

              children: [
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Change Password',
                  style: GoogleFonts.lato(
                    color: Colors.black,
                    textStyle: Theme.of(context).textTheme.headline4,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(
                  height: size.height*.07,
                ),
            defaultFormFeild(
              cursorColor: primaryColor,
              borderColor: Colors.black,
              color: Colors.black,
              context: context,
              isObsecured: isObsecured1,
              validatorText: 'please enter your Old Password',
              controller: oldPasswordController,
              suffixIcon: IconButton(
                  color: Colors.black,
                  icon: isObsecured1?Icon(Icons.visibility):Icon(Icons.visibility_off),
                  onPressed: (){
                    setState(() {
                      isObsecured1=!isObsecured1 ;
                    });
                  }),
              inputType: TextInputType.visiblePassword,
              prefixIcon: Icon(Icons.lock_outline,
                color: Colors.black,),
              labelText: 'Old Password',

            ),
                const SizedBox(
                  height: 25.0,
                ),
                defaultFormFeild(
                  cursorColor: primaryColor,
                  borderColor: Colors.black,
                  color: Colors.black,
                  context: context,
                  isObsecured: isObsecured2,
                  validatorText: 'please enter your new Password',
                  controller: newPasswordController,
                  suffixIcon: IconButton(
                      color: Colors.black,
                      icon: isObsecured2?Icon(Icons.visibility):Icon(Icons.visibility_off),
                      onPressed: (){
                        setState(() {
                          isObsecured2=!isObsecured2 ;
                        });
                      }),
                  inputType: TextInputType.visiblePassword,
                  prefixIcon: Icon(Icons.lock_outline,
                    color: Colors.black,),
                  labelText: 'New Password',

                ),
                const SizedBox(
                  height: 25.0,
                ),
                defaultFormFeild(
                  cursorColor: primaryColor,
                  borderColor: Colors.black,
                  color: Colors.black,
                  context: context,
                  isObsecured: isObsecured3,
                  validatorText: 'please Confirm Your Password',
                  controller: confirmNewPasswordController,
                  suffixIcon: IconButton(
                      color: Colors.black,
                      icon: isObsecured3?Icon(Icons.visibility):Icon(Icons.visibility_off),
                      onPressed: (){
                        setState(() {
                          isObsecured3=!isObsecured3 ;
                        });
                      }),
                  inputType: TextInputType.visiblePassword,
                  prefixIcon: Icon(Icons.lock_outline,
                    color: Colors.black,),
                  labelText: 'Confirm New Password',

                ),
                const SizedBox(
                  height: 40.0,
                ),
                ConditionalBuilder(
                  condition: state !='loading',
                  builder: (context) =>
                      Center(
                        child: defaultButton(
                          width: size.width*.7,
                          textColor: Colors.white,
                          context: context,
                          string: 'Submit',
                          function: () {
                            if (formKey.currentState.validate()) {
                              if(newPasswordController.text==confirmNewPasswordController.text){
                              changePassword(oldPassword: oldPasswordController.text,
                                  newPassword: newPasswordController.text
                              );
                              }
                              else{
                                Fluttertoast.showToast(
                                  msg: 'Password Confirmation Does not match',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 5,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              }
                            };




                          },
                          color: primaryColor
                        ),
                      ),
                  fallback: (context) =>
                      Center(child: CircularProgressIndicator()),
                ),
                SizedBox(height: 12,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Forget Your Password?',
                      style: GoogleFonts.lato(
                        color: primaryColor,
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                      ),

                    ),
                    SizedBox(width: 2,),
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
    );
  }
}
