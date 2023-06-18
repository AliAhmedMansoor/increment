import 'package:flutter/material.dart';
import 'package:incrementapp/themes/colours.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:incrementapp/reusables/routes.dart';
import 'package:lottie/lottie.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(210, 37, 16, 46),
              Color.fromARGB(197, 0, 0, 0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: IntroductionScreen(
              globalBackgroundColor: Colors.transparent,
              scrollPhysics: const BouncingScrollPhysics(),
              pages: [
                PageViewModel(
                  titleWidget: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: const [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colours.body,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                "CREATE",
                                style: TextStyle(
                                  color: Colours.mainText,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colours.body,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Joyful Tasks",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 173, 173, 250),
                        ),
                      ),
                    ],
                  ),
                  bodyWidget: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Celebrate consistency with each decrement of the task count 🎉",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ),
                  image: Transform.scale(
                    scale: 0.8,
                    child: Center(
                      child: Lottie.asset('lib/icons/task.json'),
                    ),
                  ),
                ),
                PageViewModel(
                  titleWidget: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: const [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colours.body,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                "PLAN AHEAD WITH",
                                style: TextStyle(
                                  color: Colours.mainText,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colours.body,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Time-Based Habits",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 146, 235, 200),
                        ),
                      ),
                    ],
                  ),
                  bodyWidget: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Experience the synergy of time and personal growth in perfect harmony ⏰",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ),
                  image: Center(
                    child: Lottie.asset(
                        'lib/icons/habit.json'), //https://lottiefiles.com/146952-masseaux-task
                  ),
                ),
                PageViewModel(
                  titleWidget: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: const [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colours.body,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                "TRACK",
                                style: TextStyle(
                                  color: Colours.mainText,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colours.body,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Incremental Progress",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 255, 229, 113),
                        ),
                      ),
                    ],
                  ),
                  bodyWidget: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Gamify your progress by leveling up 1% daily until you achieve 100% mastery",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ),
                  image: Transform.scale(
                    scale: 0.9,
                    child: Center(
                      child: Lottie.asset('lib/icons/progress.json'),
                    ),
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
                "SKIP",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color.fromARGB(255, 196, 131, 216),
                ),
              ),
              next: const Icon(
                Icons.arrow_forward,
                color: Color.fromARGB(255, 211, 144, 231),
              ),
              done: const Text(
                "LOG IN",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color.fromARGB(255, 215, 150, 235),
                ),
              ),
              dotsDecorator: DotsDecorator(
                  size: const Size.square(10.0),
                  activeSize: const Size(20.0, 10.0),
                  color: const Color.fromARGB(255, 130, 77, 140),
                  activeColor: const Color.fromARGB(255, 196, 131, 216),
                  spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)))),
        ),
      ),
    );
  }
}
