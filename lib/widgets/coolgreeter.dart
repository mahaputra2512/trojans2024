import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../home.dart';

// ignore: must_be_immutable
class CoolGreeter extends StatefulWidget {
  CoolGreeter({Key? key}) : super(key: key);

  // ignore: library_private_types_in_public_api
  late _CoolGreeterState coolGreeterState;

  void setMousePos(x, y) {
    coolGreeterState._setMousePos(x, y);
  }

  @override
  // ignore: no_logic_in_create_state
  State<CoolGreeter> createState() => coolGreeterState = _CoolGreeterState();
}

class _CoolGreeterState extends State<CoolGreeter> {
  String rulesPointerText = "GuideBook";
  String faqPointerText = "FAQ";
  String aboutUsPointerText = "About Us";

  String xPosString = "x: 0.0";
  String yPosString = "y: 0.0";

  String dateString = DateFormat('EEE, d MMM y').format(DateTime.now());
  String timeString = DateFormat('HH:mm:ss').format(DateTime.now());

  Future _setMousePos(x, y) async {
    xPosString = "x: ${x.toStringAsFixed(3)}";
    yPosString = "y: ${y.toStringAsFixed(3)}";
  }

  Future _setTime() async {
    dateString = DateFormat('EEE, d MMM y').format(DateTime.now());
    timeString = DateFormat('HH:mm:ss').format(DateTime.now());
    setState(() {});
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
    if (!smallVer) Timer.periodic(const Duration(seconds: 1), (Timer t) => _setTime());
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
      child: SizedBox(
        width: scrw * (smallVer ? 30 : 18),
        height: scrh * 50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!smallVer)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: DefaultTextStyle(
                  style: TextStyle(
                      color: Colors.purpleAccent.shade400,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Unifont',
                      fontSize: scrw * 1.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            "Welcome, troops!",
                            speed: const Duration(milliseconds: 150),
                          ),
                        ],
                        repeatForever: true,
                        pause: const Duration(milliseconds: 2000),
                        displayFullTextOnTap: true,
                        stopPauseOnTap: true,
                      ),
                      Row(
                        key: ValueKey<String>(xPosString),
                        children: [Text(xPosString), const Spacer(), Text(yPosString)],
                      ),
                      Row(
                        key: ValueKey<String>(dateString),
                        children: [Text(dateString), const Spacer(), Text(timeString)],
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(
              height: scrh * 2,
            ),
            CustomPaint(
              foregroundPainter: BorderPainter(),
              child: Padding(
                padding: EdgeInsets.all(smallVer ? 10 : 20.0),
                child: DefaultTextStyle(
                  style: TextStyle(
                      color: Colors.purpleAccent.shade400,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Unifont',
                      fontSize: scrw * (smallVer ? 5 : 1.5)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onHover: (e) {
                          setState(() {
                            rulesPointerText = "> GuideBook";
                          });
                        },
                        onExit: (e) {
                          setState(() {
                            rulesPointerText = "GuideBook";
                          });
                        },
                        child: Builder(
                          builder: (context) => GestureDetector(
                            onTap: () => _launchUrl(Uri.parse('https://trojans.id/GuideBook')),
                            child: Container(
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Text(rulesPointerText),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onHover: (e) {
                          setState(() {
                            faqPointerText = "> FAQ";
                          });
                        },
                        onExit: (e) {
                          setState(() {
                            faqPointerText = "FAQ";
                          });
                        },
                        child: Builder(
                          builder: (context) => GestureDetector(
                            onTap: () => Scaffold.of(context).openDrawer(),
                            child: Container(
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Text(faqPointerText),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onHover: (e) {
                          setState(() {
                            aboutUsPointerText = "> About Us";
                          });
                        },
                        onExit: (e) {
                          setState(() {
                            aboutUsPointerText = "About Us";
                          });
                        },
                        child: Builder(
                          builder: (context) => GestureDetector(
                            onTap: () => _launchUrl(Uri.parse('https://korpstar-poltekssn.org')),
                            // onTap: () {
                            //   showAlertDialog(context, scrw, smallVer);
                            // },
                            child: Container(
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Text(aboutUsPointerText),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}
