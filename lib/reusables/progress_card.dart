import 'package:flutter/material.dart';
import 'package:incrementapp/themes/colours.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProgressCard extends StatefulWidget {
  const ProgressCard({
    Key? key,
    required this.percentage,
    required this.habitName,
  }) : super(key: key);

  final double percentage;
  final String habitName;

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(
        left: 25,
        right: 25,
        top: 5,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 43, 43, 43),
          borderRadius: BorderRadius.circular(20),
        ),
        height: screenWidth * 0.3,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.habitName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colours.mainText,
                      ),
                      maxLines: 1,
                    ),
                    Text(
                      "${(widget.percentage * 100).toInt()}%",
                      // Replace with the actual percentage value
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                        color: Colours.mainText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: [
                      Color.fromARGB(210, 140, 108, 195),
                      Color.fromARGB(210, 236, 192, 252),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ).createShader(bounds);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 10,
                ),
                child: Center(
                    child: LinearPercentIndicator(
                  barRadius: const Radius.circular(20),
                  lineHeight: 18,
                  // Change this to actual increment
                  percent: widget.percentage,
                  linearGradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(210, 140, 108, 195),
                      Color.fromARGB(210, 236, 192, 252),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  backgroundColor: const Color.fromARGB(48, 255, 255, 255),

                  // animation: true,
                  // animationDuration: 2500,
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
