import 'package:arduino_app/userPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePAgeState createState() => _HomePAgeState();
}

class _HomePAgeState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Row(
          children: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Users'),
            ),
            Spacer(),
            Icon(Icons.search)
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ListView.builder(
            itemCount: 4,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder:(context,index)=>buildItems(context,index)
        ),
      ),
    );
  }
}



Widget buildItems(context,index) => InkWell(
  onTap: ()
  {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return UserPage(name:'User ${index+1}',);
    }));
  },
  child:   Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft:Radius.circular(10)
            ,topRight:Radius.circular(30)
            ,bottomLeft: Radius.circular(10)),
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
            SizedBox(
              width: 20.0,
            ),
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'User ${index+1}',
                  style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ),
);
