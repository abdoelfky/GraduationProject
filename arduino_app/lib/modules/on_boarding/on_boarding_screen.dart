import 'package:arduino_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../shared/cash_helper.dart';
import '../../shared/components.dart';
import '../auth/login.dart';
import 'models.dart';


class On_boarding_Screen extends StatefulWidget {
  @override
  _On_boarding_ScreenState createState() => _On_boarding_ScreenState();
}

class _On_boarding_ScreenState extends State<On_boarding_Screen> {
  var boardController = PageController();
  bool isLast = false;

  void submit() {
    CacheHelper.saveData(
      key: 'onBoarding',
      value: true,
    ).then((value)
    {
      if (value) {
        navigateAndEnd(
          context,
          Login(),
        );
      }
    });
  }

  List<BoardingModel> boarding = [
    BoardingModel(
        title: 'Welcome To Indoor Localization',
        body: 'let\'s tracking objects',
        image: 'assets/logo.png'),
    BoardingModel(
        title: 'Artificial Intelligence',
        body: 'Keep up with the modern era and artificial intelligence',
        image: 'assets/onBoarding2.png'),
    BoardingModel(
        title: 'Get Started',
        body: 'register if You do not have an account ',
        image: 'assets/onBoarding3.png')
  ];




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          actions: [
            TextButton(onPressed: () {
              submit();
              print(CacheHelper.getData(key: 'onBoarding'));

            }, child: Text('SKIP',
              style: TextStyle(
                  color: Colors.white
              ),))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                  child: PageView.builder(
                    onPageChanged: (int index) {
                      if (index == boarding.length - 1) {
                        setState(() {
                          isLast = true;
                        });
                      } else
                        setState(() {
                          isLast = false;
                        });
                    },
                    physics: BouncingScrollPhysics(),
                    controller: boardController,
                    itemBuilder: (context, index) =>
                        buildBoardingItem(boarding[index]),
                    itemCount: boarding.length,
                  )),
              const SizedBox(
                height: 50.0,
              ),
              Row(
                children: [
                  SmoothPageIndicator(
                    controller: boardController,
                    count: boarding.length,
                    effect: const ExpandingDotsEffect(
                        dotColor: Colors.grey,
                        activeDotColor: primaryColor,
                        expansionFactor: 4,
                        dotHeight: 10,
                        dotWidth: 10,
                        spacing: 5.0
                    ),
                  ),
                  Spacer(),
                  FloatingActionButton(
                    backgroundColor: primaryColor,
                    onPressed: () {
                      if (isLast) {
                        submit();
                        print(CacheHelper.getData(key: 'onBoarding'));
                      }
                      else {
                        boardController.nextPage(
                            duration: Duration(
                              milliseconds: 750,),
                            curve: Curves.fastOutSlowIn);
                      }
                    },
                    child: Icon(Icons.arrow_forward_ios),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}

Widget buildBoardingItem(BoardingModel model) =>
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
        child: Image(
          image: AssetImage('${model.image}'),
        ),
      ),
      Text(
        '${model.title}',
        style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        height: 20.0,
      ),
      Text(
        '${model.body}',
        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold,color: Colors.grey),
      ),
      SizedBox(
        height: 20.0,
      ),
    ]);
