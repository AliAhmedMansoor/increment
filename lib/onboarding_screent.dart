import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:incrementapp/reusables/routes.dart';
import 'package:lottie/lottie.dart';

class introScreen extends StatelessWidget {
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
                  "Tasks",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                body:
                    "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum",
                image: Center(
                  child: Lottie.network(
                      'https://assets9.lottiefiles.com/packages/lf20_6gd6q7yr.json'), //https://lottiefiles.com/87971-task
                ),
              ),
              PageViewModel(
                titleWidget: const Text(
                  "Habits",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                body:
                    "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum",
                image: Center(
                  child: Lottie.network(
                      'https://assets8.lottiefiles.com/packages/lf20_x265fmWrEw.json'), //https://lottiefiles.com/146952-masseaux-task
                ),
              ),
              PageViewModel(
                titleWidget: const Text(
                  "Progress",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                body:
                    "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum",
                image: Center(
                  child: Lottie.network(
                      'https://assets7.lottiefiles.com/private_files/lf30_rxnyqob7.json'), //https://lottiefiles.com/112178-cat-dart
                  //Additional Options : https://lottiefiles.com/84101-task-completion-icon-lottie-animation
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
