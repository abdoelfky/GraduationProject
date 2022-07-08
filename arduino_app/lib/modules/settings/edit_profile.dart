import 'package:arduino_app/models/userModel.dart';
import 'package:arduino_app/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../shared/cash_helper.dart';
import '../../shared/components.dart';

class EditProfileScreen extends StatefulWidget {

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var state;
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


  Future<void> updateUserData({
    @required String name,
    @required String email,
    @required String phone,

  }) async {
    setState(() {
      state='loading';
    });
    UserModel model = UserModel(
      name: name,
      phone: phone,
      email: email,
      uId: userModel.uId,
      isEmailVerified: false,

    );
    var user = await FirebaseAuth.instance.currentUser;
    user.updateEmail(email).then((value){

      FirebaseFirestore.instance
          .collection('users')
          .doc(userModel.uId)
          .update(model.toMap())
          .then((value) async {



        getUserData();
        setState(() {
          state='success';
        });
        Fluttertoast.showToast(
          msg: 'Data Updated Successfully',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );


      })
          .catchError((onError) {
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

      setState(() {
        state='error';
      });

    });

  }

  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    getUserData();

    if(userModel!=null&&userModel.email!=emailController.text.trim()
        &&userModel.name!=nameController.text.trim()
        &&userModel.phone!=phoneController.text.trim()

    ) {
      nameController.text = userModel.name;
      emailController.text = userModel.email;
      phoneController.text = userModel.phone;

    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Edit Profile'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(Icons.edit),
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
                  'Update Profile',
                  style: GoogleFonts.lato(
                    color: Colors.black,
                    textStyle: Theme.of(context).textTheme.headline4,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(
                  height: size.height*.03,
                ),
            const CircleAvatar(
              radius: 50.0,
              backgroundColor: secondColor,
              backgroundImage: AssetImage('assets/user.png'),
            ),
                SizedBox(
                  height: size.height*.03,
                ),

                defaultFormFeild(
                  cursorColor: primaryColor,
                  borderColor: Colors.black,
                  color: Colors.black,
                  context: context,
                  validatorText: 'please enter your name',
                  controller: nameController,
                  inputType: TextInputType.name,
                  prefixIcon: Icon(Icons.person,
                    color: Colors.black,),
                  labelText: 'Name',

                ),
                const SizedBox(
                  height: 25.0,
                ),
                defaultFormFeild(
                  cursorColor: primaryColor,
                  borderColor: Colors.black,
                  color: Colors.black,
                  context: context,
                  validatorText: 'please enter your Email',
                  controller: emailController,
                  inputType: TextInputType.emailAddress,
                  prefixIcon: Icon(Icons.email_outlined,
                    color: Colors.black,),
                  labelText: 'Email',

                ),
                const SizedBox(
                  height: 25.0,
                ),
                defaultFormFeild(
                  cursorColor: primaryColor,
                  borderColor: Colors.black,
                  color: Colors.black,
                  context: context,
                  validatorText: 'please enter your Phone',
                  controller: phoneController,
                  inputType: TextInputType.phone,
                  prefixIcon: Icon(Icons.phone_outlined,
                    color: Colors.black,),
                  labelText: 'Phone',

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
                            string: 'Update',
                            function: () {
                              if (formKey.currentState.validate()) {

                                updateUserData(name: nameController.text.trim(),
                                    email: emailController.text.trim(),
                                    phone: phoneController.text.trim()

                                );



                              };




                            },
                            color: Colors.blueAccent
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
