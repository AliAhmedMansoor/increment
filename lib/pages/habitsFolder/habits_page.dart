import 'dart:async';

import 'package:flutter/material.dart';
import 'package:incrementapp/pages/habitsFolder/alarmSettings.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'package:animations/animations.dart';
import 'package:incrementapp/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';


StreamController<HabitHolder> habitsWidgets=StreamController<HabitHolder>();

class HabitsPage extends StatefulWidget {
  const HabitsPage({super.key});

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}
///Complementary Color:  const Color.fromARGB(255, 80, 109, 224)
///Primary Color: const Color.fromARGB(255, 28, 33, 41)


class _HabitsPageState extends State<HabitsPage> {


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: const Color.fromARGB(255, 80, 109, 224),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,height: 500,///Remove height late
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                color: Color.fromARGB(255, 28, 33, 41),
              ),




              child: const HabitList(),
            ),
          ),
        ),
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


  List<HabitHolder> habits=List.empty(growable:true);
   static Stream<HabitHolder> stream=habitsWidgets.stream.asBroadcastStream();

  @override
  void initState(){
    super.initState();
    setUpHabits();
  }
  @override
  void dispose(){
    super.dispose();

  }
  void setUpHabits() async{
    List<String> habitsName = preferences.getStringList('habitName') as List<String>;

    for (int i = 0; i < habitsName.length; i++) {
      habits.add(HabitHolder(habitNumber: int.parse(habitsName[i]), key: GlobalKey()));
    }

  }
  @override
  Widget build(BuildContext context) {


    return StreamBuilder<HabitHolder>(
      stream: stream,
      builder: (context, snapshot) {
        if(snapshot.data!=null) {
          bool flag=true;
          List<String> habitNames=preferences.getStringList('habitName') as List<String>;
          habits=List.generate(
              habitNames.length,
                  (index) => HabitHolder(habitNumber:int.parse(habitNames[index]),key: GlobalKey(),)
          );
        }
        return ListView(
          children: habits,
        );
        },);
  }
}





class HabitHolder extends StatefulWidget {
  final int habitNumber;
  const HabitHolder({super.key,required this.habitNumber});


  @override
  State<HabitHolder> createState() => _HabitHolderState();
}

class _HabitHolderState extends State<HabitHolder> {
  double containerWidth=300;
  int value=5000;
  bool isPlaying=false;
  bool hasStopped=false;
  late Duration duraion;
  final StopWatchTimer stopWatchTimer= StopWatchTimer(
      mode: StopWatchMode.countUp);
  double progressRatio=1;
  late TimeOfDay timeOfDay;
  bool transitioned=false;

  @override
  void initState(){
    super.initState();
    setDuration();

  }
  void setDuration()async{
    List<String> habits= preferences.getStringList('habitDuration${widget.habitNumber}') as List<String>;
    duraion=Duration(minutes: int.parse(habits[0]),hours: int.parse(habits[1]));

  }
  void setTimeOfDay()async{
    List<String> startTime= preferences.getStringList('habitStart${widget.habitNumber}') as List<String>;
    timeOfDay=TimeOfDay(hour:int.parse(startTime[0]),minute:int.parse(startTime[1] ));
  }

  String getTimeLeft(){


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
    int timeLeft = targetDateTime
        .difference(now)
        .inMinutes;

    hourTime = timeLeft ~/ 60;
    minuteTime = timeLeft % 60;

    return "$hourTime hours and $minuteTime min left";


  }


  Widget openState(BuildContext context,void Function({Object? returnValue})){
  return HabitSettings(habitNumber: widget.habitNumber,);
  }
  final GlobalKey key=GlobalKey();
  late void Function() actionReference;
  @override
  Widget build(BuildContext context) {
    setTimeOfDay();

    return Align(
      heightFactor: 2,
      alignment: Alignment.center,
      child: Dismissible(
        key: GlobalKey(),
        confirmDismiss: (confirm) async{
          if(confirm==DismissDirection.endToStart){
            actionReference();
            return false;
          }
          else if(confirm==DismissDirection.startToEnd){

            List<String> habitName=preferences.getStringList("habitName") as List<String>;
            print("HEELLLLLLLLLLLLLLLOOOOOOOOOOOOOOOOOOOOOO!!!!!!!!!!!!!!!!!");
            print(habitName.remove(widget.habitNumber.toString()));
            preferences.setStringList('habitName', habitName);

            return true;
          }
          return true;

        },
        background:Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color:Colors.red)),
        secondaryBackground:OpenContainer(
          closedColor:const Color.fromARGB(255, 80, 109, 224),
          tappable: false,
          clipBehavior: Clip.none,
          openColor: const Color.fromARGB(255, 80, 109, 224),
          middleColor: const Color.fromARGB(255, 80, 109, 224),
          transitionDuration: const Duration(milliseconds: 1000),
          transitionType: ContainerTransitionType.fade,
          closedBuilder: (BuildContext context, void Function() action) {
            actionReference=action;
            return Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color:const Color.fromARGB(255, 80, 109, 224)));
          },
          openBuilder: (BuildContext context, void Function({Object? returnValue}) action) {
            return HabitSettings(habitNumber: widget.habitNumber,);
          },

        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                habitBox(child: habitTable()),
                progressBar(),
              ]
          ),
        ),
      ),
    );
  }







  Widget progressBar(){
    setDuration();
    return (isPlaying || hasStopped)?Positioned(
      left: -5,
      child: SimpleAnimationProgressBar(
        height: 12,
        width: containerWidth+5,
        backgroundColor: Colors.transparent,
        foregrondColor: const Color.fromARGB(255, 80, 109, 224),
        ratio: progressRatio,
        direction: Axis.horizontal,
        curve: Curves.linear,
        duration: duraion,
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(10),right: Radius.circular(10)),),
    )
    ///if isPlaying is false
        :const SizedBox(height: 0,width: 0,);

  }




  Widget habitTable(){
    return Table(
      columnWidths: {
        0:FixedColumnWidth(0.05*containerWidth),
        1:FixedColumnWidth(0.5*containerWidth),
        2:FixedColumnWidth(0.45*containerWidth),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        const TableRow(
          children: [
            SizedBox(height: 0,width: 0,),
            Text('Knitting',style: TextStyle(fontSize:34,fontWeight: FontWeight.bold,color:Color.fromARGB(255, 80, 109, 224)),maxLines: 1,),
            SizedBox(height: 0,width: 0,)
          ],),
        TableRow(
            children: [
              const SizedBox(height: 0,width: 0,),
              (isPlaying || hasStopped)?TimeLeft(stopWatchTimer:stopWatchTimer,):Text(getTimeLeft(),style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),),
              IconButton(onPressed: (){
                setState(() {
                  if(!isPlaying && !hasStopped) {isPlaying=true; hasStopped=false;}///Animation Starts
                  else if(isPlaying && !hasStopped) {isPlaying=false; hasStopped=true;
                  progressRatio=0;
                  duraion=const Duration(days: 1000);
                  stopWatchTimer.onStopTimer();

                  }///Animation has stopped
                  else if(!isPlaying && hasStopped) {isPlaying=true; hasStopped=false;stopWatchTimer.onStartTimer();
                  progressRatio=1;
                  duraion=Duration(seconds: 5-stopWatchTimer.secondTime.value);
                  }///Animation Restarts

                });
              }, iconSize:0.25*containerWidth,
                  icon:Icon(
                      ((!isPlaying && !hasStopped) || (isPlaying && !hasStopped))?Icons.play_arrow
                          :Icons.pause
                  ))]),],);
  }


  Widget habitBox({required Widget child}){

    return Container(

        width: containerWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color:  const Color.fromARGB(255, 40, 46, 55),
        ),

        child:child
    );

  }
}


class TimeLeft extends StatelessWidget {
  const TimeLeft({Key? key,required this.stopWatchTimer}) : super(key: key);
  final StopWatchTimer stopWatchTimer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Ticker(stopWatchTimer: stopWatchTimer),
        const Text('/ 45 mins',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color:Color.fromARGB(255, 80, 109, 224))),
      ],
    );
  }
}


class Ticker extends StatefulWidget {
  final StopWatchTimer stopWatchTimer;
  const Ticker({Key? key,required this.stopWatchTimer}) : super(key: key);

  @override
  State<Ticker> createState() => _TickerState();
}

class _TickerState extends State<Ticker> {

  late int _value;
  String _elapsedSeconds='';
  String _elapsedMinutes='';
  String _elapsedHours='';



  @override
  void initState(){
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

          _elapsedSeconds= StopWatchTimer.getDisplayTimeSecond(_value);

          return Text(
            '$_elapsedMinutes:$_elapsedSeconds',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }
    );
  }

  @override
  void dispose()
  {
    super.dispose();
    widget.stopWatchTimer.dispose();
  }



}

