import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

void navigateAndEnd(context,widget)=>
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context)=>widget,),
        result: (Route<dynamic> route)=>false,

    );


void navigateTo(context, widget) => Navigator.push(

  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);

Widget defaultButton({
  var textColor =const Color(0xFF014963),
  double width = 200,
  double height = 50.0,
  Color color,
  var context,
  @required String string,
  @required Function function,
}) =>
    Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50)
      ),
      child: Center(
        child: MaterialButton(
            minWidth: width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(string,
                  style:GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.button,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontStyle: FontStyle.italic,
                  )),
            ),
            onPressed: function),
      ),
    );

Widget defaultButton2({
  double width = 200,
  double height = 50.0,
  Color color,
  @required String string,
  @required Function function,
}) =>
    Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50)
      ),
      child: Center(
        child: MaterialButton(
            minWidth: width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(string.toUpperCase(),
                  style: TextStyle(fontSize: 18.2, fontWeight: FontWeight.bold,color: Colors.blue)),
            ),
            onPressed: function),
      ),
    );





Widget defaultFormFeild({
  var cursorColor=Colors.white,
  var color=Colors.white,
  var borderColor=Colors.white,
  @required String validatorText,
  @required var controller,
  @required var inputType,
  IconButton suffixIcon ,
  Function suffixPressed,
  @required Icon prefixIcon ,
  @required String labelText,
  bool isObsecured=false,
  Function onTap,
  context
  
})=>TextFormField(
  cursorColor: cursorColor,
  onChanged: onTap,
  validator: (value){
    if(value.isEmpty)
    {return validatorText;}
    return null;
  },
  controller: controller,
  keyboardType: inputType,
  obscureText: isObsecured,
  decoration: InputDecoration(
    labelStyle: GoogleFonts.lato(
      textStyle: Theme.of(context).textTheme.headline4,
      fontSize: 22,
      color: color,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.italic,
    ),
    filled: true,
    fillColor: Colors.white.withOpacity(0),
    enabledBorder: UnderlineInputBorder(
      borderRadius: BorderRadius.circular(40.0),
      borderSide: BorderSide(
        color: borderColor.withOpacity(.5),
        width: 1,
      ),
    ),
    labelText: labelText,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,


  ),
);


Widget myDivider() => Padding(
  padding: const EdgeInsets.symmetric(vertical: 1.0,horizontal: 15),
  child: Container(
    width: double.infinity,
    height: 0.4,
    color: Colors.grey,
  ),
);

Widget myToaster({@ required String message}){

  Fluttertoast.showToast(
  msg: message,
  toastLength: Toast.LENGTH_LONG,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: 5,
  backgroundColor: Colors.green,
  textColor: Colors.black,
  fontSize: 16.0,
);
}
Widget defaultAppBar(
    {
      @required BuildContext context,
      String title,
      List <Widget> actions
    })=>AppBar(
  titleSpacing: 5.0,
  leading: IconButton(
    onPressed: ()
    {
      Navigator.pop(context);
    },
    icon: Icon(Icons.location_city_outlined),
  ),
  title: Text(title),
  actions: actions,

);


Widget buildListTile(String title,IconData icon,Function tabHandler){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    child: Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(10)),
      ),
      elevation: 10.0,
      child: Container(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading:Icon(icon,size: 30,) ,

            title: Text(title,style: TextStyle(


              fontFamily: '',
              fontWeight: FontWeight.w700,
            ),),
            onTap: tabHandler,
          ),
        ),
      ),
    ),
  );
}