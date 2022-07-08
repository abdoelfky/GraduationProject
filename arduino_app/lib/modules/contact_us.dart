import 'package:flutter/cupertino.dart';

import '../shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        //leading: Icon(Icons.menu, color: Colors.white),
        title: const Text(
          "About Us",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 33.0,left:18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    Text(
                      'Who are we ?',
                      style: GoogleFonts.lato(
                        color: Colors.black,
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                        'A leader in developing smart and powerful AI software'
                            ' applications. We are proud to have an experienced, '
                            'smart working and extremely capable group of developers'
                            ' working for us.They constantly improvise to ensure our'
                            ' clients get the best experience.',
                      style: GoogleFonts.lato(
                        color: Colors.grey[800],
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),

                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'How "Indoor Positioning" Working?',
                      style: GoogleFonts.lato(
                        color: Colors.black,
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'It provides you real time updates on Object Location'
                          'location by sending you Live Location ,'
                          'By Using Wifi Rssi in our Machine Learning Model'
                          'and get you to know about Object indoor Location ',
                      style: GoogleFonts.lato(
                        color: Colors.grey[800],
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Text(
                      'How To Contact Us',
                      style: GoogleFonts.lato(
                        color: Colors.black,
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.home_outlined,size: 35,),
                              SizedBox(width: 15,),
                              Text(
                                'Smart Team',
                                style: GoogleFonts.lato(
                                  color: Colors.black,
                                  textStyle: Theme.of(context).textTheme.headline4,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.italic,
                                ),
                              )

                          ],),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Icon(Icons.email_outlined,size: 30,),
                              SizedBox(width: 15,),
                              Text(
                                'SmartTeam@gmail.com',
                                style: GoogleFonts.lato(
                                  color: Colors.black,
                                  textStyle: Theme.of(context).textTheme.headline4,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.italic,
                                ),
                              )

                            ],),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Icon(Icons.phone_outlined,size: 32,),
                              SizedBox(width: 15,),
                              Text(
                                '+201020304050',
                                style: GoogleFonts.lato(
                                  color: Colors.black,
                                  textStyle: Theme.of(context).textTheme.headline4,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.italic,
                                ),
                              )

                            ],),
                          const SizedBox(height: 10,),

                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
