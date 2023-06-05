import 'package:flutter/material.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 109, 81, 165),
                  Color.fromARGB(255, 228, 167, 197)
                ],
                begin: Alignment.topCenter,
                end: Alignment.center,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(''),
                  ),
                ),
                Expanded(
                  flex: 50,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 22, 22, 22),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 25),
                        child: Column(
                          children: [
                            const CircleAvatar(
                              radius: 45,
                              backgroundColor: Color.fromARGB(255, 43, 43, 43),
                              child: Text(
                                "🗿",
                                style: TextStyle(fontSize: 45.0),
                              ),
                            ),
                            const SizedBox(height: 25),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      thickness: 0.5,
                                      color: Colors.grey[300],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Text(
                                      "Today's Progress",
                                      style: TextStyle(color: Colors.grey[300]),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      thickness: 0.5,
                                      color: Colors.grey[300],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 25),
                            // Completed Tasks
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 25,
                                        right: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 43, 43, 43),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      height: screenWidth * 0.3,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Tasks",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            ShaderMask(
                                              shaderCallback: (Rect bounds) {
                                                return const LinearGradient(
                                                  colors: [
                                                    Color.fromARGB(
                                                        255, 156, 128, 213),
                                                    Color.fromARGB(
                                                        255, 228, 167, 197)
                                                  ],
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                ).createShader(bounds);
                                              },
                                              child: Text(
                                                'lol',
                                                style: const TextStyle(
                                                  fontSize: 50,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Completed Habits
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        right: 25,
                                        left: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 43, 43, 43),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      height: screenWidth * 0.3,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Habits",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            ShaderMask(
                                              shaderCallback: (Rect bounds) {
                                                return const LinearGradient(
                                                  colors: [
                                                    Color.fromARGB(
                                                        255, 156, 128, 213),
                                                    Color.fromARGB(
                                                        255, 228, 167, 197)
                                                  ],
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                ).createShader(bounds);
                                              },
                                              child: const Text(
                                                "0",
                                                style: TextStyle(
                                                  fontSize: 50,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
