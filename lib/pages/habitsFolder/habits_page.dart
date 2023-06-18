import 'dart:async';

import 'package:flutter/material.dart';
import 'package:incrementapp/pages/habitsFolder/alarmSettings.dart';
import 'package:incrementapp/themes/colours.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:animations/animations.dart';
import 'package:incrementapp/main.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';

StreamController<HabitHolder> habitsWidgets = StreamController<HabitHolder>();

class HabitsPage extends StatefulWidget {
  const HabitsPage({Key? key}) : super(key: key);

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colours.topFlexBackground1,
                  Colours.topFlexBackground2,
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
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20),
// Habit Counter
                      child: Text(
                        '1',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 60,
                          color: Colours.counter,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colours.bottomFlexBackground,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: Stack(
                      children: const [
                        HabitList(),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colours.bottomFlexBackground,
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 17, bottom: 20),
                  child: Row(
                    children: const [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colours.bottomFlexBackground,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class HabitList extends StatefulWidget {
  const HabitList({Key? key}) : super(key: key);

  @override
  State<HabitList> createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  List<HabitHolder> habits = List.empty(growable: true);
  static Stream<HabitHolder> stream = habitsWidgets.stream.asBroadcastStream();

  @override
  void initState() {
    super.initState();
    setUpHabits();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setUpHabits() async {
    List<String> habitsName =
        preferences.getStringList('habitName') as List<String>;

    for (int i = 0; i < habitsName.length; i++) {
      habits.add(
          HabitHolder(habitNumber: int.parse(habitsName[i]), key: GlobalKey()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HabitHolder>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          bool flag = true;
          List<String> habitNames =
              preferences.getStringList('habitName') as List<String>;
          habits = List.generate(
              habitNames.length,
              (index) => HabitHolder(
                    habitNumber: int.parse(habitNames[index]),
                    key: GlobalKey(),
                  ));
        }
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 7,
            ),
            child: ListView(
              children: habits,
            ),
          ),
        );
      },
    );
  }
}

class HabitHolder extends StatefulWidget {
  final int habitNumber;
  const HabitHolder({super.key, required this.habitNumber});

  @override
  State<HabitHolder> createState() => _HabitHolderState();
}

class _HabitHolderState extends State<HabitHolder> {
  double containerWidth = 350;
  int value = 5000;
  bool isPlaying = false;
  bool hasStopped = false;
  late Duration duraion;
  final StopWatchTimer stopWatchTimer =
      StopWatchTimer(mode: StopWatchMode.countUp);
  double progressRatio = 1;
  late TimeOfDay timeOfDay;
  bool transitioned = false;

  @override
  void initState() {
    super.initState();
    setDuration();
  }

  void setDuration() async {
    List<String> habits = preferences
        .getStringList('habitDuration${widget.habitNumber}') as List<String>;
    duraion =
        Duration(minutes: int.parse(habits[0]), hours: int.parse(habits[1]));
  }

  void setTimeOfDay() async {
    List<String> startTime = preferences
        .getStringList('habitStart${widget.habitNumber}') as List<String>;
    timeOfDay = TimeOfDay(
        hour: int.parse(startTime[0]), minute: int.parse(startTime[1]));
  }

  String getTimeLeft() {
    DateTime now = DateTime.now();
    DateTime targetDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    if (targetDateTime.isBefore(now)) {
      targetDateTime = targetDateTime.add(const Duration(days: 1));

      /// later add some animation to prevent it from playing if it already has played
    }

    int minuteTime = 0;
    int hourTime = 0;
    int timeLeft = targetDateTime.difference(now).inMinutes;

    hourTime = timeLeft ~/ 60;
    minuteTime = timeLeft % 60;

    return "in $hourTime hours and $minuteTime min";
  }

  Widget openState(BuildContext context, void Function({Object? returnValue})) {
    return HabitSettings(
      habitNumber: widget.habitNumber,
    );
  }

  final GlobalKey key = GlobalKey();
  late void Function() actionReference;

  @override
  Widget build(BuildContext context) {
    setTimeOfDay();

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Dismissible(
        key: GlobalKey(),
        confirmDismiss: (confirm) async {
          if (confirm == DismissDirection.endToStart) {
            // preferences.getStringList("habitName")!.removeLast();
            return true;
          } else if (confirm == DismissDirection.startToEnd) {
            actionReference();
            return false;
          } else if (confirm == DismissDirection.startToEnd) {
            List<String> habitName =
                preferences.getStringList("habitName") as List<String>;

            habitName.remove(widget.habitNumber.toString());
            preferences.setStringList('habitName', habitName);

            return true;
          }
          return true;
        },
        background: OpenContainer(
          closedColor: Colours.bottomFlexBackground,
          tappable: false,
          clipBehavior: Clip.none,
          openColor: Colours.topFlexBackground1,
          middleColor: Colours.bottomFlexBackground,
          transitionDuration: const Duration(milliseconds: 500),
          transitionType: ContainerTransitionType.fadeThrough,
          closedBuilder: (BuildContext context, void Function() action) {
            actionReference = action;
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colours.topFlexBackground2,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: actionReference,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Icon(
                        Icons.edit,
                        color: Colours.mainIcon,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          openBuilder: (BuildContext context,
              void Function({Object? returnValue}) action) {
            return HabitSettings(
              habitNumber: widget.habitNumber,
            );
          },
        ),
        secondaryBackground: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [
                Colours.deleteGradient1,
                Colours.deleteGradient2,
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.delete,
                  color: Colours.mainIcon,
                ),
              ),
            ],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(alignment: Alignment.bottomCenter, children: [
            habitBox(child: habitTable()),
            progressBar(),
          ]),
        ),
      ),
    );
  }

  Widget progressBar() {
    setDuration();
    return (isPlaying || hasStopped)
        ? Positioned(
            left: -5,
            child: SimpleAnimationProgressBar(
              height: 12,
              width: containerWidth + 5,
              backgroundColor: Colors.transparent,
              foregrondColor: Colours.navigationFocused,
              ratio: progressRatio,
              direction: Axis.horizontal,
              curve: Curves.linear,
              duration: duraion,
              borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(10), right: Radius.circular(10)),
            ),
          )

        ///if isPlaying is false
        : const SizedBox(
            height: 0,
            width: 0,
          );
  }

  Widget habitTable() {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Running',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(222, 222, 180, 234),
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 8),
                (isPlaying || hasStopped)
                    ? TimeLeft(stopWatchTimer: stopWatchTimer)
                    : Text(
                        getTimeLeft(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colours.body,
                        ),
                      ),
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  // Toggle the play/pause state
                  isPlaying = !isPlaying;
                  if (isPlaying) {
                    stopWatchTimer.onStartTimer();
                    progressRatio = 1;
                    duraion =
                        Duration(seconds: 5 - stopWatchTimer.secondTime.value);
                  } else {
                    stopWatchTimer.onStopTimer();
                    progressRatio = 0;
                    duraion = const Duration(days: 1000);
                  }
                });
              },
              iconSize: 0.16 * containerWidth,
              icon: isPlaying
                  ? SizedBox(
                      height: 36,
                      child: Image.asset(
                        'lib/icons/pause.png',
                        color: Colours.mainIcon,
                      ),
                    )
                  : SizedBox(
                      height: 28,
                      child: Image.asset(
                        'lib/icons/play.png',
                        color: Colours.mainIcon,
                      ),
                    )),
        ],
      ),
    );
  }

  Widget habitBox({required Widget child}) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: isPlaying
              ? Border.all(
                  color: Colours.navigationFocused,
                  width: 2,
                )
              : null,
          borderRadius: BorderRadius.circular(15),
          color: isPlaying
              ? const Color.fromARGB(28, 178, 127, 194)
              : Colours.cardFocused,
        ),
        height: isPlaying ? 120 : 90,
        child: child,
      ),
    );
  }
}

class TimeLeft extends StatelessWidget {
  const TimeLeft({Key? key, required this.stopWatchTimer}) : super(key: key);
  final StopWatchTimer stopWatchTimer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Ticker(stopWatchTimer: stopWatchTimer),
          const Text(' / 02 mins',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colours.body)),
        ],
      ),
    );
  }
}

class Ticker extends StatefulWidget {
  final StopWatchTimer stopWatchTimer;
  const Ticker({Key? key, required this.stopWatchTimer}) : super(key: key);

  @override
  State<Ticker> createState() => _TickerState();
}

class _TickerState extends State<Ticker> {
  late int _value;
  String _elapsedSeconds = '';
  String _elapsedMinutes = '';

  @override
  void initState() {
    super.initState();
    widget.stopWatchTimer.onStartTimer();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: widget.stopWatchTimer.rawTime,
        initialData: 0,
        builder: (context, snap) {
          // print(widget.stopWatchTimer.rawTime.value);
          _value = snap.data!;
          _elapsedMinutes = StopWatchTimer.getDisplayTimeMinute(_value);

          _elapsedSeconds = StopWatchTimer.getDisplayTimeSecond(_value);

          return Text(
            '$_elapsedMinutes:$_elapsedSeconds',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    widget.stopWatchTimer.dispose();
  }
}
