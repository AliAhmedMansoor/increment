import 'package:flutter/material.dart';

import 'package:incrementapp/main.dart';
import 'package:incrementapp/pages/habitsFolder/habits_page.dart';
import 'package:incrementapp/reusables/my_button.dart';
import 'package:incrementapp/themes/colours.dart';
import 'package:list_wheel_scroll_view_nls/list_wheel_scroll_view_nls.dart';
import 'package:animated_clipper/animated_clipper.dart';

///Complementary Color:  Color.fromARGB(255, 80, 109, 224)
///Primary Color: Color.fromARGB(255, 28, 33, 41)
///
///
///
/// 1-time at which notification will be received [List View]
/// 2-the days on which the notifications will be received [little fainted texts beneath it aligned vertically or horizontally]
/// 3-Habit Name [written on topCentered with tick and cross symbols on the extremes]
/// 4-Habit duration
///

/// routine$i
/// habitStart$i
/// habitDuration$i
/// habitName

List<String> routine = List.filled(7, '');
TimeOfDay habitStart = const TimeOfDay(hour: 1, minute: 0);

Duration habitDuration = const Duration(minutes: 0, hours: 0);

late String habitName = 'New Habit';

///will be changed in the future

Map<String, int> routineToIndex = {
  'MON': 0,
  'TUE': 1,
  'WED': 2,
  'THU': 3,
  'FRI': 4,
  'SAT': 5,
  'SUN': 6
};

class HabitSettings extends StatefulWidget {
  final int? habitNumber;
  const HabitSettings({Key? key, this.habitNumber}) : super(key: key);

  @override
  State<HabitSettings> createState() => _HabitSettingsState();
}

class _HabitSettingsState extends State<HabitSettings> {
  @override
  void initState() {
    super.initState();
    setUpPreferences();
  }

  void setUpPreferences() async {
    if (widget.habitNumber != null) {
      int habitNumber = widget.habitNumber as int;
      routine =
          preferences.getStringList('routine$habitNumber') as List<String>;
      List<String> tempList =
          (preferences.getStringList('habitStart$habitNumber') as List<String>);

      habitStart = habitStart.replacing(
          hour: int.parse(tempList[0]), minute: int.parse(tempList[1]));
      tempList = preferences.getStringList('habitDuration$habitNumber')
          as List<String>;

      habitDuration = Duration(
          minutes: int.parse(tempList[0]), hours: int.parse(tempList[1]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colours.gradient1,
            Colours.gradient2,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            EditPrompt(habitNumber: widget.habitNumber),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            const Clock(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            const Routine(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            const HabitDuration(),
          ],
        ),
      ),
    );
  }
}

class EditPrompt extends StatelessWidget {
  int? habitNumber;
  EditPrompt({Key? key, required this.habitNumber}) : super(key: key);

  void savePreferences() async {
    if (habitNumber == null) {
      List<String> habitNames =
          preferences.getStringList('habitName') as List<String>;
      habitNames.add(habitName);
      await preferences.setStringList('habitName', habitNames);
      habitNumber = habitNames.length;
      habitsWidgets
          .add(HabitHolder(habitNumber: habitNumber as int, key: GlobalKey()));
    }
    await preferences.setStringList('routine$habitNumber', routine);
    await preferences.setStringList('habitStart$habitNumber',
        [habitStart.hour.toString(), habitStart.minute.toString()]);
    if (habitDuration.inHours == 0) {
      await preferences.setStringList('habitDuration$habitNumber',
          [habitDuration.inMinutes.toString(), '0']);
    } else {
      await preferences.setStringList(
          'habitDuration$habitNumber', ['0', habitDuration.inHours.toString()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  ///exit without saving
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
                color: Colours.mainIcon,
              ),
              const Text(
                'Enter Habit',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Colors.white),
              ),
              IconButton(
                onPressed: () {
                  ///save
                  savePreferences();

                  Navigator.pop(context, () {
                    setState() {}
                    ;
                  });
                },
                icon: const Icon(Icons.check),
                color: Colours.mainIcon,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Clock extends StatefulWidget {
  const Clock({Key? key}) : super(key: key);

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  late FixedExtentScrollController hourScrollController;
  late FixedExtentScrollController minuteScrollController;

  @override
  void initState() {
    super.initState();

    hourScrollController = FixedExtentScrollController();
    minuteScrollController = FixedExtentScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    hourScrollController.dispose();
    minuteScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            VerticalTimeListView(
              screenWidthRatio: 0.5,
              includeZero: true,
              lastNumber: 23,
            ),
            Text(
              ':',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.bold),
            ),
            VerticalTimeListView(
              screenWidthRatio: 0.4,
              includeZero: true,
              lastNumber: 60,
            ),
          ],
        ),
      ),
    );
  }
}

class Routine extends StatelessWidget {
  const Routine({Key? key}) : super(key: key);
  static const List<String> days = [
    "MON",
    "TUE",
    "WED",
    "THU",
    "FRI",
    "SAT",
    "SUN"
  ];
  static List<RoutineUnit> DaysofWeek = List.generate(
      7,
      (index) => RoutineUnit(
            day: days[index],
          ));
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                      "Routine",
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
            const SizedBox(height: 10),
            Table(
                defaultColumnWidth: const FixedColumnWidth(360 / 7),
                children: [
                  TableRow(children: [
                    DaysofWeek[0],
                    DaysofWeek[1],
                    DaysofWeek[2],
                    DaysofWeek[3],
                    DaysofWeek[4],
                    DaysofWeek[5],
                    DaysofWeek[6],
                  ]),
                ]),
          ],
        ));
  }
}

class RoutineUnit extends StatefulWidget {
  final String day;
  const RoutineUnit({Key? key, required this.day}) : super(key: key);

  @override
  State<RoutineUnit> createState() => _RoutineUnitState();
}

class _RoutineUnitState extends State<RoutineUnit> {
  static const Color beforeTap = Colours.hintEye;
  static const Color afterTap = Colours.mainText;
  late Color currentColor;
  late int index = routineToIndex[widget.day] as int;

  @override
  void initState() {
    super.initState();

    if (routine[index] == widget.day) {
      currentColor = afterTap;
    } else {
      currentColor = beforeTap;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentColor = (currentColor == beforeTap) ? afterTap : beforeTap;
          routine[index] = (currentColor == beforeTap) ? '' : widget.day;
        });
      },
      child: Align(
          heightFactor: 2,
          child: Text(
            widget.day,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: currentColor,
            ),
          )),
    );
  }
}

class HabitDuration extends StatefulWidget {
  const HabitDuration({Key? key}) : super(key: key);

  @override
  State<HabitDuration> createState() => _HabitDurationState();
}

class _HabitDurationState extends State<HabitDuration> {
  static const Color beforeTap = Colors.white12;
  static const Color afterTap = Colors.white;
  Color minuteColor = beforeTap;
  Color hourColor = afterTap;
  CrossClipState crossClipState = CrossClipState.showSecond;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                    "Duration",
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

          ///add the list view here
          AnimatedCrossClip(
            duration: const Duration(milliseconds: 250),
            crossClipState: crossClipState,
            pathBuilder: PathBuilders.slideRight,
            curve: Curves.linear,
            firstChild: const HorizontalTimeListView(
                itemExtent: 0.15, includeZero: true, lastNumber: 60),
            secondChild: const HorizontalTimeListView(
                itemExtent: 0.2, includeZero: true, lastNumber: 23),
          ),

          const SizedBox(height: 15),
          Align(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 170,
                  height: 70,
                  child: MyButton(
                    color: Colours.mainButton,
                    onTap: () {
                      setState(() {
                        crossClipState =
                            (crossClipState == CrossClipState.showSecond)
                                ? CrossClipState.showFirst
                                : CrossClipState.showFirst;
                        minuteColor =
                            (minuteColor == beforeTap) ? afterTap : minuteColor;
                        hourColor =
                            (hourColor == afterTap) ? beforeTap : hourColor;
                      });
                    },
                    child: const Center(
                      child: Text(
                        "Minutes",
                        style: TextStyle(
                          color: Colours.mainText,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 170,
                  height: 70,
                  child: MyButton(
                    color: Colours.mainButton,
                    onTap: () {
                      setState(() {
                        crossClipState =
                            (crossClipState == CrossClipState.showFirst)
                                ? CrossClipState.showSecond
                                : CrossClipState.showSecond;
                        minuteColor =
                            (minuteColor == afterTap) ? beforeTap : minuteColor;
                        hourColor =
                            (hourColor == beforeTap) ? afterTap : hourColor;
                      });
                    },
                    child: const Center(
                      child: Text(
                        "Hours",
                        style: TextStyle(
                          color: Colours.mainText,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
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

class HorizontalTimeListView extends StatelessWidget {
  final double itemExtent;
  final bool includeZero;
  final int lastNumber;
  const HorizontalTimeListView(
      {super.key,
      required this.itemExtent,
      required this.includeZero,
      required this.lastNumber});

  int numberAtIndex(int index) {
    late int currentNumber;
    if (includeZero) {
      currentNumber = (index % lastNumber);
    } else {
      currentNumber = (((index) % lastNumber) + 1);
    }
    return currentNumber;
  }

  String numberToListViewDisplayFormat(int number) {
    late String display;
    if (number < 10) {
      display = '0$number';
    } else {
      display = number.toString();
    }
    return display;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 30, 10, 52),
      child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
          child: ListWheelScrollViewX.useDelegate(
            onSelectedItemChanged: (int index) {
              if (lastNumber == 60) {
                habitDuration =
                    Duration(minutes: numberAtIndex(index), hours: 0);

                ///update minute
              } else {
                habitDuration =
                    Duration(minutes: 0, hours: numberAtIndex(index));

                ///update hour
              }
            },
            itemExtent: MediaQuery.of(context).size.width * itemExtent,
            overAndUnderCenterOpacity: 0.1,
            physics: const FixedExtentScrollPhysics(),
            controller: FixedExtentScrollController(
                initialItem: (lastNumber == 60)
                    ? habitDuration.inMinutes
                    : (habitDuration.inHours)),
            scrollDirection: Axis.horizontal,
            childDelegate:
                ListWheelChildBuilderDelegate(builder: (context, index) {
              return Text(
                numberToListViewDisplayFormat(numberAtIndex(index)),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 28,
                ),
              );
            }),
          )),
    );
  }
}

class VerticalTimeListView extends StatelessWidget {
  final double screenWidthRatio;
  final bool includeZero;
  final int lastNumber;

  const VerticalTimeListView(
      {super.key,
      required this.screenWidthRatio,
      required this.includeZero,
      required this.lastNumber});

  int numberAtIndex(int index) {
    late int currentNumber;
    if (includeZero) {
      currentNumber = (index % lastNumber);
    } else {
      currentNumber = (((index) % lastNumber) + 1);
    }
    return currentNumber;
  }

  String numberToListViewDisplayFormat(int number) {
    late String display;
    if (number < 10) {
      display = '0$number';
    } else {
      display = number.toString();
    }
    return display;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * screenWidthRatio,

      /// 1->0.5
      child: ListWheelScrollView.useDelegate(
        onSelectedItemChanged: (int index) {
          if (lastNumber == 60) {
            habitStart = habitStart.replacing(minute: numberAtIndex(index));

            ///update minute
          } else {
            habitStart = habitStart.replacing(hour: numberAtIndex(index));

            ///update hour
          }
        },
        controller: FixedExtentScrollController(
            initialItem:
                (lastNumber == 23) ? habitStart.hour : (habitStart.minute)),
        overAndUnderCenterOpacity: 0.4,
        useMagnifier: true,
        magnification: 1.25,
        itemExtent: 50,
        physics: const FixedExtentScrollPhysics(),
        childDelegate: ListWheelChildBuilderDelegate(builder: (context, index) {
          return FittedBox(
            child: Text(
              numberToListViewDisplayFormat(numberAtIndex(index)),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );
        }),
      ),
    );
  }
}
