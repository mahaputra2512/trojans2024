import 'dart:async';
import 'dart:convert';
import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hovering/hovering.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:trojans/pages/prize.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late dynamic winners;

  @override
  void initState() {
    readJson();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/winners.json');
    final result = await json.decode(response);
    winners = result['winners'];
    leaderboardStreamController.sink.add(result['winners']);
  }

  StreamController leaderboardStreamController = StreamController.broadcast();

  _searchfun(String ss) {
    ss = ss.toLowerCase();
    List portable = winners.sublist(3, winners.length);
    List mydata = [];
    setState(() {
      mydata = portable.where((element) {
        return element['name'].toString().toLowerCase().contains(ss);
      }).toList();
    });
    leaderboardStreamController.sink.add(winners.sublist(0, 3) + mydata);
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
      style: const TextStyle(color: Colors.white, fontFamily: 'Unifont'),
      child: Container(
          width: scrw * (smallVer ? 90 : 48),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent),
          ),
          height: scrh * (smallVer ? 60 : 40),
          clipBehavior: Clip.hardEdge,
          child: StreamBuilder(
              stream: leaderboardStreamController.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return LinearProgressIndicator();
                }
                dynamic data = snapshot.data;
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: smallVer ? scrh * 10 : 10, bottom: scrh * 6),
                        child: Text("Leaderboard",
                            style: TextStyle(
                                fontFamily: "Unifont",
                                fontSize: scrw * (smallVer ? 6 : 4.5),
                                color: Colors.purpleAccent.shade700)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CupertinoSearchTextField(
                          onChanged: _searchfun,
                          placeholder: 'Search your name',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      smallVer
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('${data[0]['field1']}', style: TextStyle(fontSize: 16)),
                                      SizedBox(width: scrw * 3),
                                      Text(
                                        '${data[0]['name']}',
                                        style: TextStyle(fontSize: 16),
                                        textAlign: TextAlign.center,
                                      ),
                                      Spacer(),
                                      Text('${data[0]['total']}', style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('${data[1]['field1']}', style: TextStyle(fontSize: 16)),
                                      SizedBox(width: scrw * 3),
                                      Text(
                                        '${data[1]['name']}',
                                        style: TextStyle(fontSize: 16),
                                        textAlign: TextAlign.center,
                                      ),
                                      Spacer(),
                                      Text('${data[1]['total']}', style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('${data[2]['field1']}', style: TextStyle(fontSize: 16)),
                                      SizedBox(width: scrw * 3),
                                      Text(
                                        '${data[2]['name']}',
                                        style: TextStyle(fontSize: 16),
                                        textAlign: TextAlign.center,
                                      ),
                                      Spacer(),
                                      Text('${data[2]['total']}', style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BoxPrizes(
                                    title: "#2",
                                    image: Lottie.asset("lotties/coin_silver.json", width: scrw * 5),
                                    description: [data[1]['name'], data[1]['total'].toString(), ''],
                                    width: scrw * 15,
                                    height: scrh * 25),
                                SizedBox(
                                  width: scrw,
                                ),
                                BoxPrizes(
                                    title: "#1",
                                    image: Lottie.asset("lotties/coin_gold.json", width: scrw * 6),
                                    description: [data[0]['name'], data[0]['total'].toString(), ''],
                                    width: scrw * 20,
                                    height: scrh * 30),
                                SizedBox(
                                  width: scrw,
                                ),
                                BoxPrizes(
                                    title: "#3",
                                    image: Lottie.asset("lotties/coin_bronze.json", width: scrw * 3),
                                    description: [data[2]['name'], data[2]['total'].toString(), ''],
                                    width: scrw * 10,
                                    height: scrh * 20),
                              ],
                            ),
                      LiveList(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: data.length - 3,
                        delay: Duration(milliseconds: 50),
                        showItemInterval: Duration(milliseconds: 100),
                        showItemDuration: Duration(milliseconds: 300),
                        visibleFraction: 0.05,
                        reAnimateOnVisibility: false,
                        itemBuilder: (BuildContext context, int index, Animation<double> animation) {
                          return HoverAnimatedContainer(
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                            padding: EdgeInsets.all(15),
                            duration: Duration(milliseconds: 150),
                            // hoverDecoration: BoxDecoration(
                            //     color: cardColor, borderRadius: BorderRadius.circular(25), boxShadow: [defShadowMax]),
                            // decoration: BoxDecoration(
                            //     color: cardColor, borderRadius: BorderRadius.circular(25), boxShadow: [defShadow]),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${data[index + 3]['field1']}', style: TextStyle(fontSize: smallVer ? 16 : 24)),
                                SizedBox(width: scrw * 3),
                                Text(
                                  '${data[index + 3]['name']}',
                                  style: TextStyle(fontSize: smallVer ? 16 : 24),
                                  textAlign: TextAlign.center,
                                ),
                                Spacer(),
                                Text('${data[index + 3]['total']}', style: TextStyle(fontSize: smallVer ? 16 : 24)),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              })),
    );
  }
}
