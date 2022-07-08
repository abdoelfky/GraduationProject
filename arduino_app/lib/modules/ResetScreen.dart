import 'package:arduino_app/shared/constants.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../shared/components.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  var emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var state;
  Future<void> resetPassword ({@required email})async
  {
    setState(() {
      state ='loading';

    });
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email)
        .then((value)
    {
setState(() {
  state ='success';

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
    }).catchError((onError){
      setState(() {
        state ='error';

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
  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Reset'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(Icons.lock_outline),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Form(
            key:formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 40.0,
                ),
                Icon(Icons.lock_outline,
                  color: Colors.red,
                  size: 80,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Reset Password',
                  style: GoogleFonts.lato(
                    color: Colors.black,
                    textStyle: Theme.of(context).textTheme.headline4,
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(
                  height: size.height*.04,
                ),


                defaultFormFeild(
                  cursorColor: primaryColor,
                  borderColor: primaryColor,
                  color: primaryColor,
                  context: context,
                  validatorText: 'please Enter Your Email',
                  controller: emailController,

                  inputType: TextInputType.emailAddress,
                  prefixIcon: Icon(Icons.lock_outline,
                    color: primaryColor,),
                  labelText: 'Email',

                ),
                const SizedBox(
                  height: 50.0,
                ),
                ConditionalBuilder(
                  condition: state !='loading',
                  builder: (context) =>
                      Center(
                        child: defaultButton(
                            width: size.width*.7,
                            textColor: Colors.white,
                            context: context,
                            string: 'Reset',
                            function: () {
                              if (formKey.currentState.validate()) {
                                resetPassword(email: emailController.text.trim());

                                }

                              },
                            color: primaryColor
                        ),
                      ),
                  fallback: (context) =>
                      Center(child: CircularProgressIndicator()),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
