import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:incrementapp/reusables/routes.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: IntroductionScreen(
            globalBackgroundColor: Colors.black,
            scrollPhysics: const BouncingScrollPhysics(),
            pages: [
              PageViewModel(
                titleWidget: const Text(
                  "Hiiii",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                body:
                    "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum",
                image: Image.network(
                  "https://cdn-icons-png.flaticon.com/512/4436/4436481.png",
                  height: 70,
                  width: 70,
                ),
              ),
              PageViewModel(
                titleWidget: const Text(
                  "Hiiii",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                body:
                    "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum",
                image: Image.network(
                  "https://cdn-icons-png.flaticon.com/512/4436/4436481.png",
                  height: 70,
                  width: 70,
                ),
              ),
              PageViewModel(
                titleWidget: const Text(
                  "Hiiii",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                body:
                    "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum",
                image: Image.network(
                  "https://cdn-icons-png.flaticon.com/512/4436/4436481.png",
                  height: 70,
                  width: 70,
                ),
              ),
            ],
            onDone: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            onSkip: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            showSkipButton: true,
            skip: const Text(
              "Skip",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            next: const Icon(
              Icons.arrow_forward,
              color: Colors.amberAccent,
            ),
            done: const Text(
              "Done",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            dotsDecorator: DotsDecorator(
                size: const Size.square(10.0),
                activeSize: const Size(20.0, 10.0),
                color: Colors.black,
                activeColor: Colors.blue,
                spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)))),
      ),
    );
  }
}
