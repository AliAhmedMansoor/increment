import 'package:flutter/material.dart';
import 'package:incrementapp/intro_screens/intro_page_1.dart';
import 'package:incrementapp/intro_screens/intro_page_2.dart';
import 'package:incrementapp/intro_screens/intro_page_3.dart';
import 'package:incrementapp/views/login_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _onBoardingScreenState createState() => _onBoardingScreenState();
}

class _onBoardingScreenState extends State<OnBoardingScreen> {
  PageController _controller = PageController();

  bool onLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              onLastPage = (index == 2);
            });
          },
          children: [
            IntroPage1(),
            IntroPage2(),
            IntroPage3(),
          ],
        ),

        //Dot Indicators
        Container(
          alignment: const Alignment(0, 0.75),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Skip Button
              GestureDetector(
                onTap: () {
                  _controller.jumpToPage(2);
                },
                child: const Text("Skip"),
              ),

              //Dot Indicator
              SmoothPageIndicator(controller: _controller, count: 3),

              //Next or Done Button
              onLastPage
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return LoginView();
                        }));
                      },
                      child: const Text("Done"),
                    )
                  : GestureDetector(
                      onTap: () {
                        _controller.nextPage(
                          duration: Duration(milliseconds: 400),
                          curve: Curves.bounceInOut,
                        );
                      },
                      child: const Text("Next"),
                    )
            ],
          ),
        ),
      ]),
    );
  }
}
