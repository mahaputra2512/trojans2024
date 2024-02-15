import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({Key? key}) : super(key: key);

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  List<dynamic> timelineEvents = [
    {
      "date": DateTime.parse("2024-01-17"),
      "event": "Open Registration Early Bird"
    },
    {
      "date": DateTime.parse("2024-01-26"),
      "event": "Close Registration Early Bird"
    },
    {
      "date": DateTime.parse("2024-01-29"),
      "event": "Open Registration Reguler"
    },
    {
      "date": DateTime.parse("2024-02-23"),
      "event": "Close Registration Reguler"
    },
    {
      "date": DateTime.parse("2024-02-24"),
      "event": "Webinar",
    },
    {
      "date": DateTime.parse("2024-03-02"),
      "event": "Tryout Luring dan Seminar"
    },
    {
      "date": DateTime.parse("2024-03-16"),
      "event": "Tryout Daring",
    },
  ];

  String happeningNowString = "ON GOING NOW";
  String countdownTimeDaysString = "??";
  String countdownTimeHoursString = "??";
  String countdownTimeMinutesString = "??";
  String countdownTimeSecondsString = "??";

  String countdownEventString = "Loading ...";

  DateTime now = DateTime.now();
  DateTime temp = DateTime.now();

  late Duration diff;
  late Timer timer;
  bool isGoingOn = false;

  int eventIndex = 0;
  Future _setTime() async {
    now = DateTime.now();
    diff = timelineEvents[eventIndex]['date'].difference(now);
    countdownTimeDaysString = "${diff.inDays}";
    countdownTimeHoursString = "${diff.inHours.remainder(24)}";
    countdownTimeMinutesString = "${diff.inMinutes.remainder(60)}";
    countdownTimeSecondsString = "${diff.inSeconds.remainder(60)}";
    countdownEventString = timelineEvents[eventIndex]['event'].toString();
    setState(() {});
  }

  Future _setCountdown() async {
    temp = DateTime.now();
    now = DateTime.parse(DateFormat('yyyy-MM-dd').format(temp));
    for (int i = 0; i < timelineEvents.length; i++) {
      if (timelineEvents[i]['date'].isAfter(now)) {
        eventIndex = i;
        timer =
            Timer.periodic(const Duration(seconds: 1), (Timer t) => _setTime());
        return;
      }
      if (timelineEvents[i]['date'].compareTo(now) == 0) {
        setState(() {
          isGoingOn = true;
          countdownEventString = timelineEvents[i]['event'].toString();
        });
        return;
      }
    }
  }

  @override
  void initState() {
    _setCountdown();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var smallVer = false;
    double scrh = MediaQuery.of(context).size.height / 100;
    double scrw = MediaQuery.of(context).size.width / 100;
    if (scrh + (.2 * scrh) > scrw) {
      smallVer = true;
    } else {
      smallVer = false;
    }
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white),
      child: Flex(
        direction: smallVer ? Axis.vertical : Axis.horizontal,
        children: [
          if (smallVer)
            Padding(
              padding: EdgeInsets.only(top: scrh * 10, bottom: scrh * 3),
              child: Text("Our Timeline",
                  style: TextStyle(
                      fontFamily: "Unifont",
                      fontSize: scrw * (smallVer ? 6 : 4.5),
                      color: Colors.blueAccent.shade700)),
            ),
          Container(
              width: scrw * (smallVer ? 90 : 30),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent),
              ),
              height: scrh * 60,
              clipBehavior: Clip.hardEdge,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: FixedTimeline.tileBuilder(
                  theme: TimelineThemeData(color: Colors.blue),
                  builder: TimelineTileBuilder.connectedFromStyle(
                    contentsAlign: ContentsAlign.alternating,
                    contentsBuilder: (context, index) => Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 7, 25, 229),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(30)),
                      margin: const EdgeInsets.all(8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          side: const BorderSide(color: Colors.blue, width: 1),
                          shape: BeveledRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: null,
                        child: Container(
                          alignment: Alignment.center,
                          // width: scrw * 20,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DefaultTextStyle(
                              style: const TextStyle(
                                  fontFamily: 'Unifont',
                                  fontSize: 14,
                                  color: Colors.white),
                              child: Column(
                                children: [
                                  Text(DateFormat("d MMM y")
                                      .format(timelineEvents[index]["date"])),
                                  const SizedBox(height: 2),
                                  Text(
                                      timelineEvents[index]["event"].toString(),
                                      textAlign: TextAlign.center)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    indicatorStyleBuilder: (context, index) =>
                        IndicatorStyle.dot,
                    connectorStyleBuilder: (context, index) =>
                        ConnectorStyle.solidLine,
                    itemCount: timelineEvents.length,
                  ),
                ),
              )),
          if (smallVer)
            SizedBox(
              height: scrh * 5,
            ),
          SizedBox(
            width: scrw * (smallVer ? 80 : 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!isGoingOn)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(countdownTimeDaysString,
                          style: TextStyle(
                              fontFamily: "Unifont",
                              fontSize: scrw * (smallVer ? 10 : 3.5),
                              color: Colors.blueAccent.shade700)),
                      SizedBox(width: scrw * 0.5),
                      Text('D',
                          style: TextStyle(
                              fontFamily: "Unifont",
                              fontSize: scrw * (smallVer ? 6 : 2))),
                      SizedBox(width: scrw * 1.5),
                      Text(countdownTimeHoursString,
                          style: TextStyle(
                              fontFamily: "Unifont",
                              fontSize: scrw * (smallVer ? 10 : 3.5),
                              color: Colors.blueAccent.shade700)),
                      SizedBox(width: scrw * 0.5),
                      Text('H',
                          style: TextStyle(
                              fontFamily: "Unifont",
                              fontSize: scrw * (smallVer ? 6 : 2))),
                      SizedBox(width: scrw * 1.5),
                      Text(countdownTimeMinutesString,
                          style: TextStyle(
                              fontFamily: "Unifont",
                              fontSize: scrw * (smallVer ? 10 : 3.5),
                              color: Colors.blueAccent.shade700)),
                      SizedBox(width: scrw * 0.5),
                      Text('M',
                          style: TextStyle(
                              fontFamily: "Unifont",
                              fontSize: scrw * (smallVer ? 6 : 2))),
                      SizedBox(width: scrw * 1.5),
                      Text(countdownTimeSecondsString,
                          style: TextStyle(
                              fontFamily: "Unifont",
                              fontSize: scrw * (smallVer ? 10 : 3.5),
                              color: Colors.blueAccent.shade700)),
                      SizedBox(width: scrw * 0.5),
                      Text('S',
                          style: TextStyle(
                              fontFamily: "Unifont",
                              fontSize: scrw * (smallVer ? 6 : 2))),
                    ],
                  ),
                if (!isGoingOn) SizedBox(height: scrh * 2),
                if (!isGoingOn)
                  Text('to ',
                      style: TextStyle(
                          fontFamily: "Unifont",
                          fontSize: scrw * (smallVer ? 7 : 2.3),
                          letterSpacing: 0)),
                if (isGoingOn)
                  Text(happeningNowString,
                      style: TextStyle(
                          fontFamily: "Unifont",
                          fontSize: scrw * (smallVer ? 10 : 3.5),
                          color: Colors.blueAccent.shade700)),
                SizedBox(height: scrh * 2),
                Text(countdownEventString,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontFamily: "Unifont", fontSize: 30))
              ],
            ),
          )
        ],
      ),
    );
  }
}
